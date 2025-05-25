class uart_rx_agent extends uvm_agent;

  //Handle of uart_rx_monitor
  uart_rx_monitor m_uart_rx_monitor;

  //Component macro
  `uvm_component_utils(uart_rx_agent)

  //Class Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_uart_rx_monitor = uart_rx_monitor::type_id::create("m_uart_rx_monitor", this);
  endfunction : build_phase


endclass : uart_rx_agent