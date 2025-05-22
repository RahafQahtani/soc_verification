.section .init
.globl _start
_start:
    li sp, 0x80042000     # Set the stack pointer
    call main             # Call the main function
