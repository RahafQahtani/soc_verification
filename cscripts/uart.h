#ifndef SOC_UART_H
#define SOC_UART_H

#include "defines.h"


#define RX_PTR  (char*)(SOC_UART_BASE_ADDRESS+4*0)     //Receive Buffer - Read Only at address 0
#define THR_PTR (char*)(SOC_UART_BASE_ADDRESS+4*0)        // Transmit Hold Register (THR) - Write Only at address 0
#define IER_PTR  (char*)(SOC_UART_BASE_ADDRESS+4*1)  	    // Interrupt Enable Register (IER)	- Read/Write at address 1
#define IIR_PTR (char*)(SOC_UART_BASE_ADDRESS+4*2)       // Interrupt Identitifcation Regiser (IIR) - Read Only at address 2
#define FCR_PTR (char*)(SOC_UART_BASE_ADDRESS+4*2)       //	FIFO Control Register (FCR) - Write Only at address 2
#define LCR_PTR (char*)(SOC_UART_BASE_ADDRESS+4*3)      //Line Conttrol Register (LCR) - Read/WRite at address 3
#define LSR_PTR (char*)(SOC_UART_BASE_ADDRESS+4*5)	    // Line Status Register (LSR) - Read at address 5

#define DL_LSB_PTR  (char*)(SOC_UART_BASE_ADDRESS+4*0)     //It acts as Divisor Latch LSB for Baudrate when LCR[7] = 1
#define DL_MSB_PTR (char*)(SOC_UART_BASE_ADDRESS+4*1)        // It acts as Divisor Latch MSB for BaudRate when LCR[7] = 1


typedef enum BAUDRATE { BAUD_4800 = 4800, BAUD_9600 = 9600} enumBaudRate;
typedef enum CHARLEN { CHAR_LEN_5 = 5, CHAR_LEN_6 = 6,CHAR_LEN_7 = 7, CHAR_LEN_8 = 8} enumCharLen;
typedef enum PARITYENABLE { FALSE, TRUE} enumParityEnable;
typedef enum PARITYTYPE { EVEN,ODD} enumParityType;


void uart_tx_test();
void uart_rx_test();
void uart_toggle_test();
void uart_baud_rate_test(enumBaudRate baudRate);
void write_baud_rate(enumBaudRate baudRate);
void read_baud_rate();

#endif

