class mc_seq extends uvm_sequence;
    
    `uvm_object_utils(mc_seq)
  
   //declare the multichannel_sequencer
   
 `ifndef SOC
	   `uvm_declare_p_sequencer(mc_sequencer)
    `else
	   `uvm_declare_p_sequencer(soc_mcsequencer)
   `endif

    function new(string name ="mc_seq");
        super.new(name);
    endfunction:new



task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body



endclass: mc_seq



class en_spi1_seq extends mc_seq;

  `uvm_object_utils(en_spi1_seq)

  function new(string name = "en_spi1_seq");
    super.new(name);
  endfunction : new

  enable_spi_core en_spi;

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI1 enable mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(en_spi, p_sequencer.wb_seqr)
    join
  endtask : body

endclass : en_spi1_seq

class en_spi2_seq extends mc_seq;

  `uvm_object_utils(en_spi2_seq)

  function new(string name = "en_spi2_seq");
    super.new(name);
  endfunction : new

  enable_spi2_core en_spi;

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 100ns);
  endtask : run_phase

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI2 enable mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(en_spi, p_sequencer.wb_seqr)
    join
  endtask : body

endclass : en_spi2_seq





class write_wbxspi1_seq extends mc_seq;
  `uvm_object_utils(write_wbxspi1_seq)

  function new(string name = "write_wbxspi1_seq");
    super.new(name);
  endfunction : new

  wb_write_spi1_seq wb_spi1_write;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI1 write mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
    join
  endtask : body
endclass : write_wbxspi1_seq

class write_wbxspi2_seq extends mc_seq;
  `uvm_object_utils(write_wbxspi2_seq)

  function new(string name = "write_wbxspi2_seq");
    super.new(name);
  endfunction : new

  wb_write_spi2_seq wb_spi2_write;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI2 write mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi2_write, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi2_seqr)
    join
  endtask : body
endclass : write_wbxspi2_seq

class read_wbxspi1_seq extends mc_seq;
  `uvm_object_utils(read_wbxspi1_seq)

  function new(string name = "read_wbxspi1_seq");
    super.new(name);
  endfunction : new

  wb_read_spi1_seq wb_spi1_read;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI1 read mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi1_read, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
    join
  endtask : body
endclass : read_wbxspi1_seq

class read_wbxspi2_seq extends mc_seq;
  `uvm_object_utils(read_wbxspi2_seq)

  function new(string name = "read_wbxspi2_seq");
    super.new(name);
  endfunction : new

  wb_read_spi2_seq wb_spi2_read;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI2 read mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi2_read, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi2_seqr)
    join
  endtask : body
endclass : read_wbxspi2_seq

class flag_wbxspi1_seq extends mc_seq;
  `uvm_object_utils(flag_wbxspi1_seq)

  function new(string name = "flag_wbxspi1_seq");
    super.new(name);
  endfunction : new

  wb_flags_spi1_seq wb_spi1_flag;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI1 flag mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi1_flag, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
    join
  endtask : body
endclass : flag_wbxspi1_seq

class flag_wbxspi2_seq extends mc_seq;
  `uvm_object_utils(flag_wbxspi2_seq)

  function new(string name = "flag_wbxspi2_seq");
    super.new(name);
  endfunction : new

  wb_flags_spi2_seq wb_spi2_flag;
  spi_slave_response_seq spi_seq;

  virtual task body;
    `uvm_info(get_type_name(), "body of SPI2 flag mc_sequence 🧑🏻‍⚖️", UVM_FULL)
    fork
      `uvm_do_on(wb_spi2_flag, p_sequencer.wb_seqr)
      `uvm_do_on(spi_seq, p_sequencer.spi2_seqr)
    join
  endtask : body
endclass : flag_wbxspi2_seq

class stress_wbxspi_seq extends mc_seq;
    
    `uvm_object_utils(stress_wbxspi_seq)
 

    function new(string name ="stress_wbxspi_seq");
        super.new(name);
    endfunction:new


  // declare the sequences to run
  wb_read_spi1_seq wb_spi1_read;
  // wb_read_spi2_seq wb_spi2_read;
  wb_write_spi1_seq wb_spi1_write;
  // wb_write_spi2_seq wb_spi2_write;
  spi_slave_response_seq spi_seq;


virtual task body;
`uvm_info(get_type_name(), "body of mc_sequence 🧑🏻‍⚖️" , UVM_FULL)
fork
`uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
// `uvm_do_on(wb_spi2_write, p_sequencer.wb_seqr)
// `uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
`uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
`uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
`uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
`uvm_do_on(wb_spi1_write, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
`uvm_do_on(wb_spi1_read, p_sequencer.wb_seqr)
`uvm_do_on(spi_seq, p_sequencer.spi1_seqr)
join

endtask:body


endclass: stress_wbxspi_seq
