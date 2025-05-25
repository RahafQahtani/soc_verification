class uart_tx_sequencer extends uvm_sequencer #(uart_frames);

  //Component macro
  `uvm_component_utils(uart_tx_sequencer)

  //Class constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside the build phase of uart_tx_sequencer.", UVM_LOW)
  endfunction : build_phase

endclass : uart_tx_sequencer