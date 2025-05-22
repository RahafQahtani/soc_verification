#ifndef SPI_H
#define SPI_H

#include "defines.h"



#define SPI1_SPCR_PTR  (char*)(SOC_SPI1_BASE_ADDRESS+4*0)     //SPI 1 Control Register - Read/Write
#define SPI1_SPSR_PTR (char*)(SOC_SPI1_BASE_ADDRESS+4*1)        // SPI 1 Status Register - Read/Write

#define SPI1_SPDR_PTR (char*)(SOC_SPI1_BASE_ADDRESS+4*2)       //SPI 1 Data Register - Read/Write
#define SPI1_SPER_PTR (char*)(SOC_SPI1_BASE_ADDRESS+4*3)       //SPI 1 Extensions Register

#define SPI2_SPCR_PTR  (char*)(SOC_SPI2_BASE_ADDRESS+4*0)     //SPI 2 Control Register - Read/Write
#define SPI2_SPSR_PTR (char*)(SOC_SPI2_BASE_ADDRESS+4*1)        // SPI 2 Status Register - Read/Write
#define SPI2_SPDR_PTR (char*)(SOC_SPI2_BASE_ADDRESS+4*2)       //SPI 2 Data Register - Read/Write
#define SPI2_SPER_PTR (char*)(SOC_SPI2_BASE_ADDRESS+4*3)       //SPI 2 Extensions Register



typedef enum SPI_ID { SPI1,SPI2} enum_SPI_ID;

void spi_write_test();
void spi_read_test();
void spi_toggle_test(enum_SPI_ID);

#endif

