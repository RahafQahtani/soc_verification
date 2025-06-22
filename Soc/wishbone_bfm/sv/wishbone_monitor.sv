class wishbone_monitor extends uvm_monitor;

   `uvm_component_utils(wishbone_monitor)
 mailbox #(wishbone_transaction) sync_mb;
 mailbox #(int) core_2_uvm_sync_mb;

   virtual interface wishbone_if vif;
   wishbone_transaction m_wb_trans;

   //UVM analysis port
   uvm_analysis_port #(wishbone_transaction) wb_analysis_port;

   //Class constructor
   function new(string name, uvm_component parent);
      super.new(name, parent);  
      //Creating the instance of analysis port
      wb_analysis_port = new("wb_analysis_port", this);
   endfunction

   //Build phase
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Inside the build phase of wishbone monitor", UVM_LOW)
        if(!uvm_config_db#(mailbox#(wishbone_transaction))::get(null, "", "sync_mb", sync_mb))       
		`uvm_error("CONFIGDB", "Mailbox could not be found in config DB");
    if(!uvm_config_db#(mailbox#(int))::get(null, "", "core_2_uvm_sync_mb", core_2_uvm_sync_mb))       
		`uvm_error("CONFIGDB", "Mailbox could not be found in config DB");
   endfunction : build_phase

   //Run phase
   virtual task run_phase(uvm_phase phase);
      `uvm_info(get_type_name(), "Inside the run_phase of wishbone monitor class.", UVM_LOW)
      forever begin 
        int mon_rec;    //For transaction recording
        m_wb_trans = wishbone_transaction::type_id::create("m_wb_trans", this);
        mon_rec = begin_tr(m_wb_trans, "Wishbone bus monitor");
        $display("Before collect data in WB mon at time = %t. wb_trans.adr_i = %h, wb_trans.data = %h", $time, m_wb_trans.adr_i, m_wb_trans.data);
        vif.collect_data(m_wb_trans.adr_i, m_wb_trans.trans, m_wb_trans.inta_o, m_wb_trans.data, m_wb_trans.reset);
        $display("Afetr collect data in WB mon at time = %t. adr_i = %h, data = %h, trans = %s", $time, m_wb_trans.adr_i, m_wb_trans.data, m_wb_trans.trans);
        end_tr(m_wb_trans);
//        $display("[MONITOR]" );
//       
	if(m_wb_trans.adr_i == `DATA_MEMORY_ADDRESS_FOR_CORE_2_UVM_SYNC) // 80040000
	begin	
    $display("Data 1");
		if((m_wb_trans.data & `CORE_2_UVM_FINISH_SYNC_MASK))	begin   // 04
      $display("Data 2");
			sync_mb.put(m_wb_trans);
			m_wb_trans.print();
		end
    else if((m_wb_trans.data & `CORE_2_UVM_SEQ_SYNC_MASK))	begin
			core_2_uvm_sync_mb.put(1);
		end
	end

  // if(vif.stb_i == 1 || vif.reset == 1)
	  m_wb_trans.print();
    
       wb_analysis_port.write(m_wb_trans);
      end
   endtask : run_phase

  //Connect phase
  function void connect_phase(uvm_phase phase);
    if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: connect_phase

endclass : wishbone_monitor

