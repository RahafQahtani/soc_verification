class uart_tx_agent extends uvm_agent;

  // predeclared field inherited from uvm_agent determines whether an agent is active or passive.
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  //Component macro
  `uvm_component_utils_begin(uart_tx_agent)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
  `uvm_component_utils_end

  //Handles of tx_driver, tx_monitor and tx_sequencer
  uart_tx_driver m_uart_tx_driver;
  uart_tx_monitor m_uart_tx_monitor;
  uart_tx_sequencer m_uart_tx_sequencer;

  //Class constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside the build phase of uart_tx_agent.", UVM_LOW)
    //Creating the instance of monitor
    m_uart_tx_monitor = uart_tx_monitor::type_id::create("m_uart_tx_monitor", this);
    //if agent is active then create the instances of driver and sequencer
    if(is_active == UVM_ACTIVE)
      begin
        m_uart_tx_driver = uart_tx_driver::type_id::create("m_uart_tx_driver", this);
        m_uart_tx_sequencer = uart_tx_sequencer::type_id::create("m_uart_tx_sequencer", this);
      end
  endfunction : build_phase

  //Connect phase
  virtual function void connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Inside the connect phase of uart_tx_agent", UVM_LOW)
    //If agent is active then develop the connection between the driver and the sequencer
    if(is_active == UVM_ACTIVE)
      m_uart_tx_driver.seq_item_port.connect(m_uart_tx_sequencer.seq_item_export);
  endfunction : connect_phase

endclass : uart_tx_agent