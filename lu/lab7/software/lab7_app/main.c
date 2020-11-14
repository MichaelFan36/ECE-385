// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile char *LED_PIO = (char	*)0x60; //make a pointer to access the PIO block
	volatile unsigned int *Reset_PIO = (unsigned int*)0x40;
	volatile unsigned int *Accumulate_PIO = (unsigned int*)0x30;
	volatile unsigned int *Switch_PIO = (unsigned int*)0x50;

	unsigned int sum = 0;
	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		if (*Reset_PIO == 0){
			sum = 0;
		}else{
		if (*Accumulate_PIO == 0){
			sum += *Switch_PIO;
			if (sum > 255){
				sum -= 256;
			}
		}
	}
		for (i = 0; i < 50000; i++); //software delay

		*LED_PIO = sum;
	}


	return 1; //never gets here
}

// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

//int main()
//{
//	int i = 0;
//	volatile unsigned int* LED_PIO = (unsigned int)0x60; //make a pointer to access the PIO block
//	// volatile used when interface with hard-ware;
//	// tell compiler not to optimize anything to do with this variable
//	//so that compiler won't mess up with our operation with hardware
//	//e.g :data assignment
//	// character since LED is only 8 bits
//	// assign LED 0-8 to corresponding addresses
//
//	volatile unsigned int* Switch_PIO = (unsigned int) 0x50;
//	//when we assign Switch_PIO as int* does it follow the c prosedure
//	//and view Switch_PIO as a 32 bit chunk of data or does it follow our
//	//hard-ware implementation so it is only 8 bits.
//	volatile unsigned int* Reset = (unsigned int) 0x40;
//	volatile unsigned int* Set = (unsigned int) 0x30;
//	int accum = 0;
//	(*LED_PIO) = 0; //clear all LEDs
//	while (1) //infinite loop
//	{
//		if(!(*Reset)){
//			accum =0;
//		}else{
//		if(!(*Set)){
//			accum += (*Switch_PIO);
//			if(accum > 255){
//				accum -= 256;
//			}
//				}
//			}
//		for (i = 0; i < 100000; i++); //software delay
//////		*LED_PIO |= 0x1; //set LSB, bit wise assignment a = a|b
//		*LED_PIO = accum;
//	}
//	return 1; //never gets here
//}
