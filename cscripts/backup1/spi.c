#include "spi.h"


void spi_toggle_test(enum_SPI_ID spi_id)
{

	char regValue;

	if(spi_id == SPI1)
	{
		*SPI1_SPCR_PTR = 0x10;			
		regValue = *SPI1_SPCR_PTR;

		*SPI1_SPCR_PTR = 0xff;			
		regValue = *SPI1_SPCR_PTR;
	
		*SPI1_SPCR_PTR = 0x10;			
		regValue = *SPI1_SPCR_PTR;



	}


}

void spi_write_test(enum_SPI_ID spi_id)
{

	char regValue;

	if(spi_id == SPI1)
	{

		int* ptr = (int*)(SOC_GPIO_BASE_ADDRESS+4*3);		//Select register for shared lines
		*ptr = 0xffffffff;
		//Enable SPI peripheral

		*SPI1_SPCR_PTR = 0x50;			//4th bit is for Master and 6 bit is Peripheral Enable
		regValue = *SPI1_SPCR_PTR;
		
		//Write data to the the SPDR Data Register, three transactions
		
		*SPI1_SPDR_PTR = 0x01;			
		*SPI1_SPDR_PTR = 0x02;			
		*SPI1_SPDR_PTR = 0x03;		

		//After this dummy 3 transactions from the slave	
	
	}


}

void spi_read_test(enum_SPI_ID spi_id)
{

	char regValue;

	if(spi_id == SPI1)
	{

		int* ptr = (int*)(SOC_GPIO_BASE_ADDRESS+4*3);		//Select register for shared lines
		*ptr = 0xffffffff;
		//Enable SPI peripheral

		*SPI1_SPCR_PTR = 0x50;			//4th bit is for Master and 6 bit is Peripheral Enable
		regValue = *SPI1_SPCR_PTR;
		
		//Write data to the the SPDR Data Register, three transactions
		
		*SPI1_SPDR_PTR = 0x01;			
		*SPI1_SPDR_PTR = 0x02;			
		*SPI1_SPDR_PTR = 0x03;		
		*SPI1_SPDR_PTR = 0x04;		

		//After dummy 4 transactions, slave will send 4 transactions
		while((*SPI1_SPSR_PTR & 0x02)==0);
		
		regValue = *SPI1_SPDR_PTR;
		regValue = *SPI1_SPDR_PTR;
		regValue = *SPI1_SPDR_PTR;
		regValue = *SPI1_SPDR_PTR;

	
	}


}


