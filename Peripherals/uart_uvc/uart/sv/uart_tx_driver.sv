class uart_tx_driver extends uvm_driver #(uart_frames);

  //Virtual interface
  virtual interface uart_if vif;
  //Component macro
  `uvm_component_utils(uart_tx_driver)

  //Variable for controlling the transmission of transaction
  int i = 0;
  //Variable for counting the number of 1's in the data being transmitted
  int count_1s = 0;

  //Class Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside the build phase of uart_tx_driver.", UVM_LOW)
  endfunction : build_phase

  //Run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Inside the run phase of uart_tx_driver.", UVM_LOW)
    forever
      begin
        seq_item_port.get_next_item(req);
        vif.send_to_dut(req);
        seq_item_port.item_done();
        req.print();
      end
  endtask : run_phase

  //Connect phase
  function void connect_phase(uvm_phase phase);
	  if(!(uart_vif_config::get(this, get_type_name(), "vif", vif)))
      		`uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction : connect_phase

endclass : uart_tx_driver