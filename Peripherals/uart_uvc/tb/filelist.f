
// include directories
+timescale+1ns/100ps
-debug_access+all
+incdir+../sv+../rtl/uart/

//+define+SOC

+incdir+../sv
+incdir+../tests/
+incdir+../sequences/

../sv/uart_defines.sv
+incdir+../uart/sv
../uart/sv/uart_pkg.sv          //UART pkg should be there
../uart/sv/uart_if.sv           //This is UART interface

//+incdir+../wishbone/sv//
//../wishbone/sv/wishbone_pkg.sv 
//../wishbone/sv/wishbone_if.sv 
+incdir+../wb/sv
../wb/sv/wb_pkg.sv 
../wb/sv/wb_if.sv 

+incdir+../clock_and_reset/sv
../clock_and_reset/sv/clock_and_reset_pkg.sv 
../clock_and_reset/sv/clock_and_reset_if.sv 

+incdir+../wb_uart_module/sv
../wb_uart_module/sv/wb_uart_module_pkg.sv 


clkgen.sv 
../rtl/uart/uart_wb.v
../rtl/uart/uart_receiver.v
../rtl/uart/uart_regs.v
../rtl/uart/uart_rfifo.v
../rtl/uart/uart_sync_flops.v
../rtl/uart/uart_tfifo.v
../rtl/uart/uart_transmitter.v
../rtl/uart/raminfr.v
../rtl/uart/uart_top.v
hw_top.sv 
tb_top.sv 
