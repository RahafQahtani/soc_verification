// // module top();
    
// //     import uvm_pkg::*;
// // `include "uvm_macros.svh"


// // // import uart_pkg::*;
// // import wb_pkg::*;
// // import clock_and_reset_pkg::*;
// // import spi_pkg::*;
// // // import uart_pkg::*;

// // // import wb_uart_module_pkg::*;
// // import spi_module_pkg::*;
// // import soc_pkg::* ; 


// // `include "defines.sv"
// // `include "soc_mcsequencer.sv"
// // `include "wb_soc_sequences.sv"
// // `include "wb_spi_sequences.sv"
// // // `include "wb_uart_sequences.sv"
// // `include "wb_spi_mcseqs_lib.sv"
// // // `include "wb_uart_mcseqs_lib.sv"
// // `include "soc_mcseqs_lib.sv"
// // `include "soc_tb.sv"
// // `include "soc_system_test_lib.sv"
// // `include "wb_spi_test_lib.sv"
// // // `include "wb_uart_test_lib.sv"



// // hw_top dut();


// // initial begin
// //     //=============================================

// // //check path

// //     //=============================================
// //     // uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
// //     spi_vif_config::set(null,"*.spienv1.slave_agent.*","vif",dut.in_spi1);
// //    spi_vif_config::set(null,"*.spienv2.slave_agent.*","vif",dut.in_spi2);
// //     //  uart_vif_config::set(null, "*.m_soc_tb.m_uart_env.*", "vif", dut.UART_if);
// //     wb_vif_config::set(null,"*.wbenv.*","vif",dut.in_wb);
// //     clock_and_reset_vif_config::set(null , "*.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
// // run_test("base_test") ; 

// // end



// // initial begin
// // $dumpfile("test.vcd");
// // $dumpvars();
// // end
// // //
// //  initial begin
// // #100000
// //  $finish;end


// // endmodule

// module top();
    
//     import uvm_pkg::*;
// `include "uvm_macros.svh"


// // import uart_pkg::*;
// import wb_pkg::*;
// import clock_and_reset_pkg::*;
// import spi_pkg::*;

// import spi_module_pkg::*;
// import i2c_pkg::*;
// import i2c_module_pkg::*;
// import soc_pkg::* ; 


// `include "defines.sv"
// `include "soc_mcsequencer.sv"
// `include "wb_soc_sequences.sv"
// `include "wb_spi_sequences.sv"
// `include "wb_i2c_sequences.sv"
// `include "wb_spi_mcseqs_lib.sv"
// `include "wb_i2c_mcseqs_lib.sv"
// `include "soc_mcseqs_lib.sv"
// `include "soc_tb.sv"
// `include "soc_system_test_lib.sv"
// `include "wb_spi_test_lib.sv"
// `include "wb_i2c_test_lib.sv"


// hw_top dut();


// initial begin
//     //=============================================

// //check path

//     //=============================================
//     // uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
//     spi_vif_config::set(null,"*.spienv1.slave_agent.*","vif",dut.in_spi1);
//    spi_vif_config::set(null,"*.spienv2.slave_agent.*","vif",dut.in_spi2);
//    i2c_vif_config::set(null,"*.i2cenv.slaves[0].*","vif",dut.in_i2c);
//     wb_vif_config::set(null,"*.wbenv.*","vif",dut.in_wb);
//     clock_and_reset_vif_config::set(null , "*.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
// run_test("base_test") ; 

// end



// initial begin
// $dumpfile("test.vcd");
// $dumpvars();
// end
// //
//  initial begin
// //#100000
// #55267000
//  $finish;end


// endmodule

module top();
    
    import uvm_pkg::*;
`include "uvm_macros.svh"


import uart_pkg::*;
import wb_uart_module_pkg::*;
import wb_pkg::*;
import clock_and_reset_pkg::*;
import spi_pkg::*;

import spi_module_pkg::*;
import i2c_pkg::*;
import i2c_module_pkg::*;
import soc_pkg::* ; 


`include "defines.sv"
`include "soc_mcsequencer.sv"
`include "wb_soc_sequences.sv"
`include "wb_spi_sequences.sv"
`include "wb_i2c_sequences.sv"
`include "wb_uart_sequences.sv"
`include "wb_spi_mcseqs_lib.sv"
`include "wb_i2c_mcseqs_lib.sv"
`include "wb_uart_mcseqs_lib.sv"
`include "soc_mcseqs_lib.sv"
`include "soc_tb.sv"
`include "soc_system_test_lib.sv"
`include "wb_spi_test_lib.sv"
`include "wb_i2c_test_lib.sv"
`include "wb_uart_test_lib.sv"

hw_top dut();


initial begin
    //=============================================

//check path

    //=============================================
    // uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
    spi_vif_config::set(null,"*.spienv1.slave_agent.*","vif",dut.in_spi1);
   spi_vif_config::set(null,"*.spienv2.slave_agent.*","vif",dut.in_spi2);
   i2c_vif_config::set(null,"*.i2cenv.slaves[0].*","vif",dut.in_i2c);
    uart_vif_config::set(null, "*.uartenv.*", "vif", dut.in_uart1);
    wb_vif_config::set(null,"*.wbenv.*","vif",dut.in_wb);
    clock_and_reset_vif_config::set(null , "*.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
run_test("base_test") ; 

end



initial begin
$dumpfile("test.vcd");
$dumpvars();
end
//
//  initial begin
// //#100000
// //#55267000
//  $finish;end


endmodule
