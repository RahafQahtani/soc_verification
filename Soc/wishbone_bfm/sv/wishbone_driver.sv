class wishbone_driver  extends uvm_driver #(wishbone_transaction );
   
   virtual interface wishbone_if vif;
   wishbone_transaction req, rsp;

   logic [7 : 0] Data_out;
   bit LSR0;

  `uvm_component_utils(wishbone_driver )

   //Class constructor
   function new(string name , uvm_component parent);
      super.new(name, parent);
   endfunction

   //run phase
   virtual task run_phase(uvm_phase phase);
      //get pakets from sequencer and send to DUT
      forever begin
         int rec1;      //For transaction recording
         req = wishbone_transaction::type_id::create("req");
         rsp = wishbone_transaction::type_id::create("rsp");
         $display("WB Drv Waiting");
         seq_item_port.get_next_item(req);
         $display("WB Drv Wait over");
//         $display("[DRIVER : Before send to DUT]" );
//	 req.print();
         rec1 = begin_tr(req, "Wishbone master driver transaction");
        $display("Before send to dut in WB Drv at time = %t. wb_trans.adr_i = %h, wb_trans.data = %h", $time, req.adr_i, req.data);
         vif.send_to_dut(req);
         $display("Before send to dut in WB Drv at time = %t. wb_trans.adr_i = %h, wb_trans.data = %h", $time, req.adr_i, req.data);
         //rsp = req.clone();
         rsp.data = vif.dat_o;
         rsp.adr_i = vif.adr_i;
         rsp.set_sequence_id(req.get_sequence_id());
         rsp.set_id_info(req);
         // Send back response to sequencer
            end_tr(req);
         seq_item_port.item_done(rsp);
       // seq_item_port.put_response(rsp);
      
        $display("[DRIVER] response  = %h", rsp.data);
//	 req.print();
      end

   endtask : run_phase

   //Connect phase
    virtual function void connect_phase(uvm_phase phase);
	   `uvm_info(get_type_name(), "Inside connect phase of wishbone driver class.", UVM_LOW)
        if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
            `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
    endfunction : connect_phase


endclass : wishbone_driver


