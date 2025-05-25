class base_test extends uvm_test;

  // component macro
  `uvm_component_utils(base_test)

  //Handle of uart_tb class
  uart_tb m_uart_tb;

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // UVM build_phase()
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_int::set( this, "*", "recording_detail", 1);
    m_uart_tb = uart_tb::type_id::create("m_uart_tb", this);
  endfunction : build_phase
  
  //Run phase
  virtual function void run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection(); 
    obj.set_drain_time(this, 400ns); 
  endfunction : run_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  // start_of_simulation
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
  endfunction : start_of_simulation_phase

  function void check_phase(uvm_phase phase);
    // configuration checker
    check_config_usage();
  endfunction

endclass : base_test

//Test to run the sequence with delay value between 15 to 45
class delay_seq1_test extends base_test;

  //Component macro
  `uvm_component_utils(delay_seq1_test)

  //Class constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_wrapper::set(this, "m_uart_tb.m_uart_env.m_uart_tx_agent.m_uart_tx_sequencer.run_phase",
                            "default_sequence", delay_seq1::get_type());
  endfunction : build_phase


endclass : delay_seq1_test

