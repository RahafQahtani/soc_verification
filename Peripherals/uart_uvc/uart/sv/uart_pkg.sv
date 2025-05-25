package uart_pkg;

  //import the UVM library
  import uvm_pkg::*;

  //include the UVM macros
  `include "uvm_macros.svh"

  typedef uvm_config_db #(virtual uart_if) uart_vif_config;

  // include the YAPP packet definition
  `include "uart_frames.sv"
  `include "uart_seqs.sv"
  `include "uart_tx_driver.sv"
  `include "uart_tx_monitor.sv"
  `include "uart_tx_sequencer.sv"
  `include "uart_rx_monitor.sv"
  `include "uart_rx_agent.sv"
  `include "uart_tx_agent.sv"
  `include "uart_env.sv"

endpackage : uart_pkg