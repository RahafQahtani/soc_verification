#include "spi.h"


void spi1_toggle_test(void) {
        char *config = (char *)SPI1_SPCR_ADDR;


   *config = 0x50;    //enable spi
 char result1 = *config ;
   *config = 0xFF;    //enable spi
 char result2 = *config ;
   *config = 0x00;    //enable spi

 char result3 = *config ;


}

void spi1_write_test(void) {
    
     char *config = (char *)SPI1_SPCR_ADDR;
     char *data = (char *)SPI1_SPDR_ADDR;
     char *spsr = (char *)SPI1_SPSR_ADDR;

   //  *config  = 0x70;   //enable spi maye to 0x50
    *config  = 0x50;   //enable spi maye to 0x50
    *data = 0x01;     //writing data

    while (*spsr & 0x01);//(spsr &1)  RFEMPTY:3.3.6 RFEMPTY – Read FIFO Empty 

char result =  *data ;


}


void spi1_read_test(void) {//fix
    
     char *config = (char *)SPI1_SPCR_ADDR;
     char *spsr = (char *)SPI1_SPSR_ADDR;
     char *data = (char *)SPI1_SPDR_ADDR;

   *config  = 0x50;    //enable spi

    while (*spsr & 0x01);//(spsr &1)  RFEMPTY:3.3.6 RFEMPTY – Read FIFO Empty 
char result = *data ;

}