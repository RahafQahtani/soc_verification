class soc_mcseq_lib extends uvm_sequence ;
    `uvm_object_utils(soc_mcseq_lib)
//declare the multichannel_sequencer
    `uvm_declare_p_sequencer(soc_mcsequencer)

  function new(string name="soc_mcseq_lib");
    super.new(name);
    uvm_config_db#(string)::set(null, "*", "seq_name", get_type_name());
  endfunction

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

endclass : soc_mcseq_lib





class  C_toggle_seq extends soc_mcseq_lib ;

  mailbox #(int) comp_mbox;
  int temp;

  `uvm_object_utils(C_toggle_seq)

  function new(string name="C_toggle_seq");
    super.new(name);
  endfunction : new
  task body();
    uvm_config_db#(string)::set(null, "*", "PERIPHERAL", "SPI1");



    `uvm_info(get_type_name(), "Starting C_toggle_seq  body", UVM_MEDIUM)
    wait_for_comparison(3);
  endtask
    bit matched = 0;
task wait_for_comparison(int expected_comp);
temp=0;
  // Get the mailbox
if (!uvm_config_db#(mailbox#(int))::get(null, "*", "comp_mbox", comp_mbox))
  `uvm_fatal("SEQ", "Failed to get comp_mbox");


    `uvm_info("WAITING", "waiting", UVM_MEDIUM)
    repeat(expected_comp)begin
comp_mbox.get(temp);end

// comp_mbox.get(temp);
// comp_mbox.get(temp);
 

    `uvm_info("FINISH", $sformatf("\nnum of COMP expected value %0d \nReceived  value: %0d",expected_comp, temp), UVM_MEDIUM)



endtask

endclass :C_toggle_seq


class  C_write_seq extends soc_mcseq_lib ;
   mailbox #(int) comp_mbox;
  int temp;

  `uvm_object_utils(C_write_seq)


  function new(string name="C_write_seq");
    super.new(name);
  endfunction : new

  task body();

    `uvm_info(get_type_name(), "Starting C_write_seq  body", UVM_MEDIUM)
    wait_for_comparison(1);//should be 1
  endtask

task wait_for_comparison(int expected_comp);
temp=0;
  // Get the mailbox
if (!uvm_config_db#(mailbox#(int))::get(null, "*", "comp_mbox", comp_mbox))
  `uvm_fatal("SEQ", "Failed to get comp_mbox");


    `uvm_info("WAITING", "waiting", UVM_MEDIUM)
    repeat(expected_comp)begin
comp_mbox.get(temp);end

// comp_mbox.get(temp);
// comp_mbox.get(temp);
 

    `uvm_info("FINISH", $sformatf("\nnum of COMP expected value %0d \nReceived  value: %0d",expected_comp, temp), UVM_MEDIUM)



endtask

endclass :C_write_seq

spi_slave_write_seq spi1_write;
class  C_read_seq extends soc_mcseq_lib;
    mailbox #(int) comp_mbox;

  int temp;

  `uvm_object_utils(C_read_seq)

  function new(string name="C_read_seq");
    super.new(name);
  endfunction : new

  task body();

    `uvm_info(get_type_name(), "Starting C_read_seq  body", UVM_MEDIUM)
    `uvm_do(spi1_write) ; 

    wait_for_comparison(1);
  endtask
task wait_for_comparison(int expected_comp);
temp=0;
  // Get the mailbox
if (!uvm_config_db#(mailbox#(int))::get(null, "*", "comp_mbox", comp_mbox))
  `uvm_fatal("SEQ", "Failed to get comp_mbox");


    `uvm_info("WAITING", "waiting", UVM_MEDIUM)
    repeat(expected_comp)begin
comp_mbox.get(temp);end

// comp_mbox.get(temp);
// comp_mbox.get(temp);
 

    `uvm_info("FINISH", $sformatf("\nnum of COMP expected value %0d \nReceived  value: %0d",expected_comp, temp), UVM_MEDIUM)



endtask


endclass :C_read_seq

