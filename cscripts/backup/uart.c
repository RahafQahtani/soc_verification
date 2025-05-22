#include "uart.h"


void uart_tx_test()
{

	unsigned char regValue;

	*LCR_PTR = 0x03;			//Set the Line Control Register to 0x03 to enable address 0 as Transmit Register
	*THR_PTR = 0x55;			//Write value in transmit register

	//For tx, comparison will be done in Scoreboard comparing Tx FIFO with the data recevied by the UART UVC

	//For rx, comparisons will be done in Scoreboard comparing Rx FIFO with the data transmitted by UART UVC
}

void uart_rx_test()
{

	unsigned char regValue;

	*LCR_PTR = 0x03;			//Set the Line Control Register to 0x03 to enable address 0 as Transmit Register


	while((*LSR_PTR & 0x01) != 0x01);		// Wait for the value written by UART UVC 


	regValue = *THR_PTR;			//Read the value from the Receive Register

	//For rx, comparisons will be done in Scoreboard comparing Rx FIFO with the data transmitted by UART UVC
}

/*
void uart_toggle_test()
{

	char regValue;

	*LCR_PTR = 0x00;			//Set the Line Control Register to 0x00
	 regValue = *LCR_PTR;


	*LCR_PTR = 0xFF;			//Set the Line Control Register to 0xFF for 0 to 1  toggle testing
	 regValue = *LCR_PTR;

	*LCR_PTR = 0x00;			//Set the Line Control Register to 0x00 for 1 to 0 toggle testing
	 regValue = *LCR_PTR;

	//For every read comparisons will be done in Scoreboard
}

*/
void uart_baud_rate_test(enumBaudRate baudRate)
{
	write_baud_rate(baudRate);
	read_baud_rate();
}	



void write_baud_rate(enumBaudRate baudRate)
{

	*LCR_PTR = 0x83;			//Set the Line Control Register Bit to 1 for configuring the Baudrate

	unsigned short baudRateTemp = SYSTEM_CLK / (16 * baudRate);


	
	unsigned char DL_MSB = (baudRateTemp >> 8) & 0xff;
	unsigned char DL_LSB = baudRateTemp & 0xff ;
	*DL_MSB_PTR = DL_MSB;
//	printf("%d %x, %x %x",baudRate, baudRateTemp, DL_MSB, DL_LSB);

	*DL_LSB_PTR = DL_LSB;
	*LCR_PTR = 0x03;			//Set the Line Control Register Bit to 1 for configuring the Baudrate
	

}

//This will get compared in Scorebaoard
void read_baud_rate()
{

	*LCR_PTR = 0x83;			//Set the Line Control Register Bit to 1 for configuring the Baudrate



	
	unsigned char DL_MSB;// = (baudRateTemp >> 8) & 0xff;
	unsigned char DL_LSB;// = baudRateTemp & 0xff ;
	DL_MSB = *DL_MSB_PTR;
	//printf("%d, %d %d",baudRateTemp, DL_MSB, DL_LSB);
	DL_LSB = *DL_LSB_PTR;
	*LCR_PTR = 0x03;			//Set the Line Control Register Bit to 1 for configuring the Baudrate
	

}


void uart_toggle_test()
{

	unsigned char regValue;

	*LCR_PTR = 0x00;			//Set the Line Control Register to 0x00
	 regValue = *LCR_PTR;


	*LCR_PTR = 0xFF;			//Set the Line Control Register to 0xFF for 0 to 1  toggle testing
	 regValue = *LCR_PTR;

	*LCR_PTR = 0x00;			//Set the Line Control Register to 0x00 for 1 to 0 toggle testing
	 regValue = *LCR_PTR;

	//For every read comparisons will be done in Scoreboard
}
