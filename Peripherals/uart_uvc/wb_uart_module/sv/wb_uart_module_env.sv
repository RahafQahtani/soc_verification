class wb_uart_module_env extends uvm_env;
	`uvm_component_utils(wb_uart_module_env);
	wb_uart_scoreboard m_wb_uart_sbd;
	wb_uart_ref_model m_wb_uart_ref_model;


	function new(string name ="wb_uart_module_env", uvm_component parent);
		super.new(name,parent);

	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		m_wb_uart_sbd = wb_uart_scoreboard::type_id::create("m_wb_uart_sbd",this);
		m_wb_uart_ref_model = wb_uart_ref_model::type_id::create("m_wb_uart_ref_model",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_wb_uart_sbd.m_wb_uart_ref_model = m_wb_uart_ref_model;
		m_wb_uart_ref_model.wb_uart_analysis_imp_sbd.connect(m_wb_uart_sbd.wb_uart_analysis_imp);		

	endfunction
endclass
