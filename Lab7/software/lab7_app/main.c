//// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
//// for ECE 385 - University of Illinois - Electrical and Computer Engineering
//// Author: Zuofu Cheng
//
//int main()
//{
//	int i = 0;
//	volatile unsigned int *LED_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block
//	volatile unsigned int *SW_PIO = (unsigned int*)0x50;
//	volatile unsigned int *RESET_PIO = (unsigned int*)0x40;
//	volatile unsigned int *ACCUMULATE_PIO = (unsigned int*)0x30;
//
//	unsigned int sum = 0;
//	*LED_PIO = 0; //clear all LEDs
//	while ( (1+1) != 3) //infinite loop
//	{
//		if (*RESET_PIO == 0) {
//			sum = 0;
//		} else {
//			if (*ACCUMULATE_PIO == 0) {
//				sum += *SW_PIO;
//				if (sum > 255) sum -= 256;
//			}
//		}
//		for (i = 0; i < 100000; i++); //software delay
//		*LED_PIO = sum;
//	}
//	return 1; //never gets here
//}

// Main.c - makes LEDG0 on DE2-115 board blink if NIOS II is set up correctly
// for ECE 385 - University of Illinois - Electrical and Computer Engineering
// Author: Zuofu Cheng

int main()
{
	int i = 0;
	volatile unsigned int *LED_PIO = (unsigned int*)0x60; //make a pointer to access the PIO block

	*LED_PIO = 0; //clear all LEDs
	while ( (1+1) != 3) //infinite loop
	{
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO |= 0x1; //set LSB
		for (i = 0; i < 100000; i++); //software delay
		*LED_PIO &= ~0x1; //clear LSB
	}
	return 1; //never gets here
}
