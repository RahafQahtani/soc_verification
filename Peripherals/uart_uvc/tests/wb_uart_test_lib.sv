`ifndef SOC
class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  string m_tb_name;
  testbench tb;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_tb_name = "tb";
    tb = testbench::type_id::create(m_tb_name, this);

    uvm_config_db#(string)::set(null, "*", "m_tb_name", m_tb_name);
    uvm_config_db#(string)::set(null, "*", "test_name", get_type_name());
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);

    `uvm_info(get_type_name(), "Inside build phase of base_test", UVM_MEDIUM)
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction : check_phase

endclass : base_test
`endif

//Test for checking Data transmitted = Data in transmit FIFO
class test_Data_Transmitted_equals_data_in_transmit_FIFO extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Transmitted_equals_data_in_transmit_FIFO)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("testlib","in test",UVM_LOW)
        if (!uvm_config_db#(string)::get(null, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
         uvm_config_wrapper::set(this,$sformatf("%s.clk_rst_env_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcseqr.run_phase",m_tb_name),
                                "default_sequence", Data_Transmitted_equals_data_in_FIFO::get_type());

       uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","Data_Transmitted_equals_data_in_FIFO");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","UART");                
    endfunction: build_phase

endclass : test_Data_Transmitted_equals_data_in_transmit_FIFO

//Test for checking Data received = Data written on Rx pin
class test_Data_Received_equals_data_in extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Received_equals_data_in)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
 	if (!uvm_config_db#(string)::get(null, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
         uvm_config_wrapper::set(this,$sformatf("%s.clk_rst_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcseqr.run_phase",m_tb_name),
                                "default_sequence", Data_Received_equals_Data_in_FIFO::get_type());
                
      uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","Data_Received_equals_Data_in_FIFO");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","UART"); 
    endfunction: build_phase

endclass : test_Data_Received_equals_data_in

//Data transmission at baud rate = 4800
//Test for checking Data transmitted = Data in transmit FIFO
class test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
  	if (!uvm_config_db#(string)::get(null, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
         uvm_config_wrapper::set(this,$sformatf("%s.clk_rst_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcseqr.run_phase",m_tb_name),
                                "default_sequence", Data_Transmitted_equals_data_in_FIFO_BD_115200::get_type());
                 uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","Data_Transmitted_equals_data_in_FIFO_BD_115200");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","UART"); 
    endfunction: build_phase
endclass : test_Data_Transmitted_equals_data_in_transmit_FIFO_BD_115200 
///Test for checking Data received = Data written on Rx pin
class test_Data_Received_equals_data_in_FIFO_BD_4800 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_Data_Received_equals_data_in_FIFO_BD_4800)
   
    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
   	if (!uvm_config_db#(string)::get(null, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
          uvm_config_wrapper::set(this,$sformatf("%s.clk_rst_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcseqr.run_phase",m_tb_name),
                                "default_sequence", Data_Received_equals_Data_in_FIFO_BD_4800::get_type());
                   uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","Data_Received_equals_Data_in_FIFO_BD_4800");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","UART"); 
    endfunction: build_phase

endclass : test_Data_Received_equals_data_in_FIFO_BD_4800

///Test to check the parity bit by transmitting the wrong parity via transmit
//UVC of UART with buad rate = 115200 
class test_BAD_PARITY_BD_115200_EVEN_1 extends base_test;
    
    //Component macro
    `uvm_component_utils(test_BAD_PARITY_BD_115200_EVEN_1)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    	if (!uvm_config_db#(string)::get(null, "", "m_tb_name", m_tb_name))
			  `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");
           uvm_config_wrapper::set(this,$sformatf("%s.clk_rst_env.agent.sequencer.run_phase",m_tb_name),
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this,$sformatf("%s.mcseqr.run_phase",m_tb_name),
                                "default_sequence", BAD_PARITY_BD_115200_EVEN_1::get_type());
                   uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","BAD_PARITY_BD_115200_EVEN_1");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","UART"); 
    endfunction: build_phase

endclass : test_BAD_PARITY_BD_115200_EVEN_1


