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

    // Set testbench name for flexible hierarchy
    m_tb_name = "tb";
    tb = testbench::type_id::create(m_tb_name, this);

    // Set testbench name in config DB so child tests can use it
    uvm_config_db#(string)::set(null, "*", "m_tb_name", m_tb_name);

    // Set the test name (optional but useful for logging/reporting)
    uvm_config_db#(string)::set(null, "*", "test_name", get_type_name());

    // Enable full transaction recording
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
class mcsequencer_basic_test extends base_test;

  `uvm_component_utils(mcsequencer_basic_test)

  spi_config m_spi_config;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);



    uvm_config_db #(spi_config)::set(this, "*", "spi_config", m_spi_config);

    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    // Use m_tb_name to construct correct path for setting default sequences
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst.agent.sequencer.run_phase", m_tb_name),
                            "default_sequence", clk10_rst5_seq::get_type());

    uvm_config_wrapper::set(this, $sformatf("%s.mc_seqr.run_phase", m_tb_name),
                            "default_sequence", wb_spi_mcsequence_lib::get_type());
  endfunction : build_phase

endclass : mcsequencer_basic_test

`endif



//----------------------------------------------------------------
// TESTS:
//----------------------------------------------------------------

class wbxspi1_en_test extends base_test;

  `uvm_component_utils(wbxspi1_en_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", en_spi1_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
      uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","en_spi1_seq");      
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL","SPI");      
  endfunction : build_phase

endclass : wbxspi1_en_test

class wbxspi2_en_test extends base_test;

  `uvm_component_utils(wbxspi2_en_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", en_spi2_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
       uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "en_spi2_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI2");
  endfunction : build_phase

endclass : wbxspi2_en_test


class wbxspi1_flags_test extends base_test;

  `uvm_component_utils(wbxspi1_flags_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", flag_wbxspi1_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
   uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "flag_wbxspi1_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI1");
  endfunction : build_phase

endclass : wbxspi1_flags_test

class wbxspi2_flags_test extends base_test;

  `uvm_component_utils(wbxspi2_flags_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", flag_wbxspi2_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
       uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "flag_wbxspi2_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI2");
  endfunction : build_phase

endclass : wbxspi2_flags_test

class wbxspi1_write_test extends base_test;

  `uvm_component_utils(wbxspi1_write_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", write_wbxspi1_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
      uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "write_wbxspi1_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI1");
  endfunction : build_phase

endclass : wbxspi1_write_test

class wbxspi2_write_test extends base_test;

  `uvm_component_utils(wbxspi2_write_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", write_wbxspi2_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
    uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "write_wbxspi2_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI2");
  endfunction : build_phase

endclass : wbxspi2_write_test

class wbxspi1_read_test extends base_test;

  `uvm_component_utils(wbxspi1_read_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", read_wbxspi1_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
     uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "read_wbxspi1_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI1");
  endfunction : build_phase

endclass : wbxspi1_read_test

class wbxspi2_read_test extends base_test;

  `uvm_component_utils(wbxspi2_read_test)

  function new(string name = get_type_name(), uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(string)::get(this, "", "m_tb_name", m_tb_name))
      `uvm_error("CONFIGDB", "Could not find Testbench Name in config DB");

    uvm_config_wrapper::set(this, $sformatf("%s.mcseqr.run_phase", m_tb_name), "default_sequence", read_wbxspi2_seq::get_type());
    uvm_config_wrapper::set(this, $sformatf("%s.clk_rst_env.agent.sequencer.run_phase", m_tb_name), "default_sequence", clk10_rst5_seq::get_type());
     
     uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());
      uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME", "read_wbxspi2_seq");
      uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI2");
  endfunction : build_phase
   
endclass : wbxspi2_read_test

