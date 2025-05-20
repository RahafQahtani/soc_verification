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



