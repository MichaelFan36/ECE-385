/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

////////////////////////////////////////////////////////////////////////////////////

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100; 

////////////////////////////////////////////////////////////////////////////////////

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

void subWord(unsigned char *word) {
	for (int i = 0; i < 4; i++) {
		word[i] = aes_sbox[word[i]];
	}
}

void subState(unsigned char *state){
	for (int i = 0; i < 16; i++) {
		state[i] = aes_sbox[state[i]];
	}
}

void keyExpansion(unsigned int *key, unsigned int *key_schedule){

	// first four columns remain the same
	for (int i = 0; i < 4; i++) {
		key_schedule[i] = key[i];
	}

	for (int i = 4; i < 44; i++) { 	
		unsigned int rotword = key_schedule[i-1];
		if (i%4 == 0){
			rotword = (rotword << 24) | (rotword >> 8);		// shift col
			subWord((unsigned char*)&rotword);				// subword
			rotword = (Rcon[i/4] >> 24) ^ rotword; 			// calcualte the key
		}
		key_schedule[i] = key_schedule[i-4] ^ rotword;
	}
}

void addRoundKey (unsigned char * state, unsigned char * key) {

	for (int i = 0; i < 16; i++) {
		state[i] = state[i] ^ key[i];
	}
}

void shiftRow (unsigned char * state) {
	unsigned char temp[16];

	for (int i=0; i<16; i++){
		temp[i] = state[i];
	}

	state[0] = temp[0];
	state[1] = temp[5];
	state[2] = temp[10];
	state[3] = temp[15];
	state[4] = temp[4];
	state[5] = temp[9];
	state[6] = temp[14];
	state[7] = temp[3];
	state[8] = temp[8];
	state[9] = temp[13];
	state[10] = temp[2];
	state[11] = temp[7];
	state[12] = temp[12];
	state[13] = temp[1];
	state[14] = temp[6];
	state[15] = temp[11];
	
}

void cal_colmix(unsigned char *col, unsigned char a, unsigned char b, unsigned char c, unsigned char d){
	col[0] = gf_mul[a][0] ^ gf_mul[b][1] ^ c ^ d;
	col[1] = a ^ gf_mul[b][0] ^ gf_mul[c][1] ^ d;
	col[2] = a ^ b ^ gf_mul[c][0] ^ gf_mul[d][1];
	col[3] = gf_mul[a][1] ^ b ^ c ^ gf_mul[d][0];
}

void mixColumn (unsigned char * state) {
	unsigned char col[4];
	for (int i=0; i<4; i++) {
		cal_colmix(col, state[i*4], state[i*4+1], state[i*4+2], state[i*4+3]);
		for (int j=0; j<4; j++) {
			state[i*4+j] = col[j];
		}
	}
}

/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	unsigned char state[16];
	unsigned char key_schedule[176];
	unsigned char char_key[16];

	for (int i = 0; i < 16; i++) {
		int pair1 = i*2;
		int pair2 = i*2+1;
		state[i] = charsToHex(msg_ascii[pair1], msg_ascii[pair2]);
		char_key[i] = charsToHex(key_ascii[pair1], key_ascii[pair2]);
	}

	keyExpansion((unsigned int*)char_key, (unsigned int*)key_schedule);

	addRoundKey(state, key_schedule);

	for (int round = 1; round < 10; round++) {
		subState(state);
		shiftRow(state);
		mixColumn(state);
		addRoundKey(state, key_schedule+round*16);
	}
	
	subState(state);
	shiftRow(state);
	addRoundKey(state, key_schedule+160);


	for (int i = 0; i < 4; i++) {
		msg_enc[i] = ((uint)state[4*i] << 24) | ((uint)state[4*i+1] << 24 >> 8) | ((uint)state[4*i+2] << 24 >> 16) | ((uint)state[4*i+3] << 24 >> 24);
		key[i] = ((uint)char_key[i*4] << 24) | ((uint)char_key[i*4+1] << 24 >> 8) | ((uint)char_key[i*4+2]<< 24 >> 16) | ((uint)char_key[i*4+3] << 24 >> 24);
	}

	// for (int i = 0; i < 4; i++) {
	// 	printf("%08x ", ((uint)state[4*i] << 24));
	// 	printf("%08x ", ((uint)state[4*i+1] << 24 >> 8));
	// 	printf("%08x ", ((uint)state[4*i+2] << 24 >> 16));
	// 	printf("%08x ", ((uint)state[4*i+3] << 24 >> 24));
	// }

}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
