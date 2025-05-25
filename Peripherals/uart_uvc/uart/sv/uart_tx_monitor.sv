class uart_tx_monitor extends uvm_monitor;

  //Virtual Interface
  virtual interface uart_if vif;

  //Member of class uart_frames for monitoring the signals and wrapping them into the transaction
  uart_frames m_uart_frames;

  //Component macro
  `uvm_component_utils(uart_tx_monitor)

  //UVM analysis port of uart_tx_monitor
  uvm_analysis_port #(uart_frames) uart_tx_analysis_port;

  //Class constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    //Creating an instance of UART tx analysis port
    uart_tx_analysis_port = new("uart_tx_analysis_port", this);
  endfunction : new

  //Build phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside the build phase of uart_tx_monitor.", UVM_LOW)
  endfunction : build_phase

  //Run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Inside the run phase of uart_tx_monitor.", UVM_LOW)
    forever
	  begin
        m_uart_frames = uart_frames::type_id::create("m_uart_frames", this);
        vif.collect_from_dut_tx_mon(m_uart_frames.data, m_uart_frames.frame_delay, m_uart_frames.parity, m_uart_frames.baud_rate, m_uart_frames.char_len,
                        m_uart_frames.stop_bits, m_uart_frames.parity_enable, m_uart_frames.stick_parity, m_uart_frames.even_parity_select, m_uart_frames.stop_bits_ctrl);
 	$display("Sending UART data fro UART UVC");
	 	m_uart_frames.print();
        uart_tx_analysis_port.write(m_uart_frames);
      end
  endtask : run_phase

  //Connect phase
  virtual function void connect_phase(uvm_phase phase);
    if(!(uart_vif_config::get(this, get_type_name(), "vif", vif)))
      		`uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction : connect_phase


endclass : uart_tx_monitor
