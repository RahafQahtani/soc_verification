#ifndef SPI1_H
#define SPI1_H
// #include "defines.h"

// SPI1 Base Address Range
#define SPI1_BASEADDR   0x20000200
#define SPI1_ENDADDR    0x200002FF

// SPI1 Register Offsets
#define SPI1_SPCR_ADDR  (SPI1_BASEADDR + 4* 0x00)  // Serial Peripheral Control Register
#define SPI1_SPSR_ADDR  (SPI1_BASEADDR + 4* 0x01)  // Serial Peripheral Status Register
#define SPI1_SPDR_ADDR  (SPI1_BASEADDR + 4* 0x02)  // Serial Peripheral Data Register
#define SPI1_SPER_ADDR  (SPI1_BASEADDR + 4* 0x03)  // Serial Peripheral Extensions Register




void spi1_toggle_test(void);
void spi1_write_test(void);
void spi1_read_test(void);

#endif
