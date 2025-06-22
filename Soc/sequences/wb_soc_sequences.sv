class wishbone_base_sequence  extends uvm_sequence #(wishbone_transaction);

//    int UART_BASE_ADDRESS=32'h20000000; 	
    int ok;
    wishbone_transaction rsp;
    `uvm_object_utils(wishbone_base_sequence)

    //Class constructor
    function new(string name = "wishbone_base_sequence");
      super.new(name);
        // set_automatic_phase_objection(1);
        endfunction

    //Raising the objection in Pre body
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
          phase = get_starting_phase();
        `else
          phase = starting_phase;
        `endif
        if(phase != null)
          begin
            phase.raise_objection(this);
            `uvm_info(get_type_name(), "Objection has been raised.", UVM_LOW)
          end

    
  
//        uvm_config_db#(string)::set(null, "*", "CUR_SUB_SEQ_NAME", "rafique");       
  endtask : pre_body


// task body();

// if (!uvm_config_db#(int)::get(m_sequencer, "", "SOC_UART_BASE_ADDRESS", SOC_UART_BASE_ADDRESS))
// 			  `uvm_error("CONFIGDB", "SOC UART Base Address not found in config DB");  
// endtask

    //Dropping the objection in post body
    task post_body();
      uvm_phase phase;
      `ifdef UVM_VERSION_1_2
        phase = get_starting_phase();
      `else
        phase = starting_phase;
      `endif
      if(phase != null)
        begin
          phase.drop_objection(this);
        end
    endtask : post_body

  endclass : wishbone_base_sequence