//#include <stdio.h>
#include "defines.h"
#include "uart.h"
#include "spi.h"
#include <string.h>

/*
#ifndef PERIPHERAL
#define PERIPHERAL "UNKOWN"
#endif

#ifndef TEST
#define TEST "UNKOWN"
#endif
*/

int main() {

//	const char peripheral[]  = PERIPHERAL;
//	const char test[] = TEST;
	char regValue;

	spi_toggle_test(SPI1);	
	
/*
		#ifdef uart_toggle_test
			uart_toggle_test();
		#endif

		#ifdef uart_tx_test
			uart_baud_rate_test(BAUD_9600);
			uart_tx_test();
		#endif		

		#ifdef uart_rx_test
			uart_baud_rate_test(BAUD_9600);
			uart_rx_test();
		#endif
*/

//	uart_baud_rate_test(BAUD_9600);
//	uart_rx_test();
//	uart_toggle_test();
//	spi_toggle_test(SPI1);
	
	
/*	if(strcmp(peripheral,"UART") == 0)
	{
		if(strcmp(test, "uart_tx_test")==0)
		{
			uart_baud_rate_test(BAUD_9600);
			uart_tx_test();
		}
		else if(strcmp(test, "uart_toggle_test")==0)
		{
			uart_toggle_test();
		}
		else if(strcmp(test, "uart_rx_test")==0)
		{
			uart_baud_rate_test(BAUD_9600);
			uart_rx_test();
		}
	
	}
	else if (strcmp (peripheral,"SPI1") == 0)
	{
	   	if(strcmp(test, "spi_toggle_test")==0)
		{
			spi_toggle_test(SPI1);
			//uart_test(test);
		}
		else if(strcmp(test, "spi_write_test")==0)
		{
			spi_write_test(SPI1);
		}
		else if(strcmp(test, "spi_read_test")==0)
		{
			spi_read_test(SPI1);
		}
	}
	else if (strcmp (peripheral,"SPI2") == 0)
	{
	//	spi_write_test(SPI2);
	}
*/
	char*ptr = (char*)DATA_MEMORY_ADDRESS_FOR_CORE_2_UVM_SYNC;
	*ptr = CORE_2_UVM_FINISH_SYNC_MASK;


	while(1) {}
}

