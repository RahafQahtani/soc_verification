`timescale 1ns/1ps

//Testbech top
module tb_top;

    //importing the uvm package and macros.svh
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    //Importing the uart package
    import uart_pkg::*;

    //Including the files located in the same directory
    `include "uart_tb.sv"
    `include "uart_test_lib.sv"

    //instantiate the interface here in case hw_top is not created

    //Running the test and configuring the interface in the initial block
    initial 
        begin
            uart_vif_config::set(null, "*.m_uart_tb.m_uart_env.*", "vif", hw_top.u_if);
            run_test("base_test");
        end



endmodule : tb_top