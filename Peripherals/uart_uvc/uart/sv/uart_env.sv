class uart_env extends uvm_env;

  //Handle of uart_tx_agent and uart_rx_agent
  uart_tx_agent m_uart_tx_agent;
  uart_rx_agent m_uart_rx_agent;

  //Component macro
  `uvm_component_utils(uart_env)

  //Class constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new  

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside the build phase of uart_env.", UVM_LOW)
    m_uart_rx_agent = uart_rx_agent::type_id::create("m_uart_rx_agent", this);
    m_uart_tx_agent = uart_tx_agent::type_id::create("m_uart_tx_agent", this);
  endfunction : build_phase

  //start_of_simulation_phase
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_LOW)
  endfunction : start_of_simulation_phase

endclass : uart_env