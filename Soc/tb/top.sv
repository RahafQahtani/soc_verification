module top();
    
    import uvm_pkg::*;
`include "uvm_macros.svh"


// import uart_pkg::*;
import wb_pkg::*;
import clock_and_reset_pkg::*;
import spi_pkg::*;

import spi_module_pkg::*;

import soc_pkg::* ; 


`include "defines.sv"
`include "soc_mcsequencer.sv"
`include "wb_soc_sequences.sv"
`include "wb_spi_sequences.sv"
`include "wb_spi_mcseqs_lib.sv"
`include "soc_mcseqs_lib.sv"
`include "soc_tb.sv"
`include "soc_system_test_lib.sv"
`include "wb_spi_test_lib.sv"



hw_top dut();
logic [31:0] inst_mem [8192];
//need to read from the inst.hex
initial begin
//`ifdef VCS_SIM
                $readmemh("../../core_tests/inst_formatted.hex", inst_mem);
  //  `endif     
force dut.DUT.u_rv32i_soc.inst_mem_inst.tsmc_32k_inst.u0.mem_core_array = inst_mem;
for (int i=0;   i<10; ++i) begin
$display("\nINST MEME[%d]: %h",i, inst_mem[i]);
    
end

end

initial begin
    //=============================================

//check path

    //=============================================
    // uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
    spi_vif_config::set(null,"*.spienv1.slave_agent.*","vif",dut.in_spi1);
   spi_vif_config::set(null,"*.spienv2.slave_agent.*","vif",dut.in_spi2);
    wb_vif_config::set(null,"*.wbenv.*","vif",dut.in_wb);
    clock_and_reset_vif_config::set(null , "*.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
run_test("base_test") ; 

end


initial begin

$monitor(dut.in_wb.ack) ; 
$monitor(dut.in_wb.addr) ; 
$monitor(dut.in_wb.din) ; 
$monitor(dut.in_wb.cyc) ; 

end

initial begin
$dumpfile("test.vcd");
$dumpvars();
end
//
//  initial begin
// #100000
//  $finish;end


endmodule