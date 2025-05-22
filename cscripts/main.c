//#include <stdio.h>
#include "defines.h"
#include "uart.h"
#include "spi.h"
#include <string.h>

int main(void) {
// #ifdef spi1_C_toggle_test
    spi1_toggle_test();
// #endif

#ifdef test2
    spi1_write_test();
#endif

#ifdef test3
    spi1_read_test();
#endif

// #if !defined(spi1_C_toggle_test) && !defined(test2)&& !defined(test3)
//     #error "No test defined. Use make test=test1 or test=\"test1 test2\""
// #endif

    return 0;
}
//make -f CMakefile