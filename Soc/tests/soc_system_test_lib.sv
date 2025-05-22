
class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  // SoC testbench
  soc_tb tb_soc;

  // Optional config objects
  string m_tb_name;

  // Constructor
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Set dynamic testbench name
    m_tb_name = "tb_soc";
    tb_soc = soc_tb::type_id::create(m_tb_name, this);


    // Common testbench-wide config
      uvm_config_db#(string)::set(null, "*", "m_tb_name", m_tb_name);//commented
    uvm_config_int::set(this, "tb_soc.wbenv.masters[0]", "is_active", UVM_PASSIVE);
    uvm_config_int::set(this, "*", "recording_detail", UVM_FULL);
    
  

    `uvm_info(get_type_name(), "Inside Build phase", UVM_HIGH)
  endfunction

  // Optional check phase
  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

  // Print topology
  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  // Drain time if needed
  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask

endclass : base_test

//simple test for mcsequencer
class mcsequencer_simple_test extends base_test;

    `uvm_component_utils(mcsequencer_simple_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "tb_soc.clk_rst_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb_soc.mcseqr.run_phase",
                                "default_sequence", soc_mcseq_lib::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
    endfunction: build_phase

endclass : mcsequencer_simple_test
//====================================================
//=================  C toggle test ===================
//====================================================
class spi1_C_toggle_test extends base_test;

    `uvm_component_utils(spi1_C_toggle_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "tb_soc.clk_rst_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());

        uvm_config_wrapper::set(this,"tb_soc.mcseqr.run_phase","default_sequence", C_toggle_seq::get_type());

       uvm_config_db#(string)::set(null, "*", "spi1_C_toggle_test", get_type_name());   //commented


    endfunction: build_phase

endclass : spi1_C_toggle_test


//====================================================
//=================  C write test ===================
//====================================================
class spi1_C_write_test extends base_test;

    `uvm_component_utils(spi1_C_write_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "tb_soc.clk_rst_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb_soc.mcseqr.run_phase",
                                "default_sequence", C_write_seq::get_type());

        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());   


    endfunction: build_phase

endclass : spi1_C_write_test

//====================================================
//=================  C read test ===================
//====================================================

class spi1_C_read_test extends base_test;

    `uvm_component_utils(spi1_C_read_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "tb_soc.clk_rst_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "tb_soc.mcseqr.run_phase",
                                "default_sequence", C_read_seq::get_type());

        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());   


    endfunction: build_phase

endclass : spi1_C_read_test