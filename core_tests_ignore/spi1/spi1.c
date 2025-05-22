// #include <stdio.h>
#include "spi1.h"


void spi1_toggle_test(void) {
   volatile  char *config = (char *)SPI1_SPCR_ADDR;
// 7:disable inta 6:en spi 5:reserved 4:set spi as master 
//3:S_polarity 2: S_phase  [1:0]: sclk=clk/2

   *config = 0x00;    //enable spi
volatile char result = *config ;
   *config = 0xFF;    //enable spi
 result = *config ;
   *config = 0x00;    //enable spi

 result = *config ;
}


void spi1_write_test(void) {
    
     char *config = (char *)SPI1_SPCR_ADDR;
     char *data = (char *)SPI1_SPDR_ADDR;

   //  *config  = 0x70;   //enable spi maye to 0x50
    *config  = 0x80;   //enable spi maye to 0x50
    *data = 0x01;     //writing data

//int result =  *data ;

}


void spi1_read_test(void) {//fix
    
     char *config = (char *)SPI1_SPCR_ADDR;
     char *spsr = (char *)SPI1_SPSR_ADDR;
     char *data = (char *)SPI1_SPDR_ADDR;

   *config  = 0x70;    //enable spi

    while (*spsr & 0x01);//(spsr &1)  RFEMPTY:3.3.6 RFEMPTY – Read FIFO Empty 

char result = *data ;

}