`include "defines.sv"
interface wishbone_if (input clock, reset);

  //Importing the UVM and Wishbone package
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wishbone_pkg::*;

  //Interface Signals
  logic cyc_i, stb_i, we_i, inta_o, ack_o;
  logic [31 : 0] adr_i;
  logic [31: 0] dat_o, dat_i;
  logic [3 : 0] sel_i;
  //For testing purpose
  // assign dat_o = dat_i;
  logic start;
  bit a, b;

  //Send to Dut task for driving the signals
  task send_to_dut(input wishbone_transaction m_wb_trans);
    
    //Reset check with highest priority
    if (a == 0)
      begin
        wait(reset);
        @(negedge reset);
        cyc_i = 0;
        stb_i = 0;
        we_i = 0;
        sel_i = 4'b1111;
      end

        @(negedge clock iff (reset == 0));
          //Driving signals for WRITE transactions
          if(m_wb_trans.trans == WRITE && reset == 0)
            begin
              cyc_i <= 1;
              stb_i <= 1;
              sel_i <= 4'b1111;
              adr_i <= m_wb_trans.adr_i;
              we_i <= 1'b1;
              dat_i <= m_wb_trans.data;
              
	      
//	      $display("Waiting for acknowledgement");
	      //Waiting for acknowledge
              wait (ack_o);

              @(posedge clock);
             // #2;
              //After acknowledge disconnecting the signals
              cyc_i <= 1'b0;
              stb_i <= 1'b0;
              we_i <= 1'b0;
            end
          //Driving Signals for READ transaction
          else if(m_wb_trans.trans == READ && reset == 0)
            begin
              cyc_i <= 1;
              stb_i <= 1;
             sel_i <= 4'b1111;
              adr_i <= m_wb_trans.adr_i;
              we_i <= 1'b0;
              dat_i <= 8'bzzzzzzzz;
              
              //Waiting for acknowledge
              wait(ack_o);
              m_wb_trans.Data_o = dat_o;
              $display("Wishbone Transaction data = %h in Interface",m_wb_trans.Data_o);
              //#2;
              @(posedge clock);
              //After acknowledge disconnecting the signals
              cyc_i <= 1'b0;
              stb_i <= 1'b0;
              we_i <= 1'b0;
            end
          //In case of IDLE
          else if(m_wb_trans.trans == IDLE && reset == 0)
            begin
              cyc_i <= 1'b0;
              stb_i <= 1'b0;
              sel_i <= 4'b0000;
              adr_i <= 2'bzz;
              we_i <= 1'b0;
              dat_i <= 8'bzzzzzzzz;

            end
            
      a = 1;
  endtask : send_to_dut

  // Debug signal 
  logic [31 : 0] addr_i_debug, data_debug;
  transaction_type trans_debug; 
  logic int_o_debug, Reset_debug;
  logic trans_started;
  logic trans_complete;
  logic trans_in_prog;
  logic frk_00;
  logic frk_01;


    //Task for collecting the data
  task collect_data(output logic [31 : 0] addr_i, transaction_type trans, logic int_o, output logic [31: 0] data, logic Reset);
	  data = 0;
    //Reset check with highest priority
    if (b == 0)
      begin
        wait(reset);
        Reset = reset;
        Reset_debug = reset;
        @(negedge reset);
      end
    else
      begin
        trans = IDLE;
        // wait for transaction start
        int_o = inta_o;
        trans_in_prog = 1;

                    // @(posedge clock);
                    // #3;
                    // `uvm_info("SERIES",$sformatf("Wait for posedge has been over and values of stb = %b, cyc = %b, we_i = %b", stb_i, cyc_i, we_i), UVM_LOW )
                    // if(~we_i & cyc_i & stb_i) begin 
                    //   trans = READ;
                    //   addr_i = adr_i;
                    //   trans_debug = READ;
                    //   addr_i_debug = adr_i;
                    //   `uvm_info("WB_IF_READ", $sformatf("Driven inputs for the Read transaction, addr = %d time = %t", addr_i, $time), UVM_LOW)
                    // end 
                    // else if (we_i & cyc_i & stb_i) begin 
                    //   trans = WRITE;
                    //   @(posedge clock);   //Wait for posedge before write so that data becomes stable
                    //   data = dat_i;
                    //   addr_i = adr_i;
                    //   trans_debug = WRITE;
                    //   data_debug = dat_i;
                    //   addr_i_debug = adr_i;

                    //   `uvm_info("WB_IF_WRITE", $sformatf("Driven Write transaction, data = %h, addr = %d, time = %t", data, addr_i, $time), UVM_LOW)
                    // end

                    // if(stb_i) //Wait only if strobe is 1 else end this and wait for next posedge of clock
                    // begin 
                    //   frk_01 = 1; // TODO debug
                    //   @(posedge ack_o);
                    //   `uvm_info("FORK",$sformatf("Acknowledge occurs at time = %t", $time), UVM_LOW )
                    //   if(trans == READ) begin 
                    //     data = dat_o;
                    //     data_debug =  dat_o;
                    //     `uvm_info("WB_IF_READ", $sformatf("Completed Write/Read transaction, data = %h, addr = %d, timr = %t", data, addr_i, $time), UVM_LOW)

                    //   end
                    //   `uvm_info("WB_IF_WRITE", $sformatf("Completed Write/Read transaction, data = %h, addr = %d, time = %t", data, addr_i, $time), UVM_LOW)
                    //   frk_01 = 0; // TODO debug
                    // end



        // fork
        //   begin 
        //         fork
        //           begin 
        //             `uvm_info("FORK","Waiting for posedge of clock", UVM_LOW )
        //             frk_00 = 1; // TODO debug
        //             @(posedge clock);
        //             #1;
        //             `uvm_info("FORK",$sformatf("Wait for posedge has been over and values of stb = %b, cyc = %b, we_i = %b", stb_i, cyc_i, we_i), UVM_LOW )
        //             if(~we_i & cyc_i & stb_i) begin 
        //               trans = READ;
        //               addr_i = adr_i;
        //               trans_debug = READ;
        //               addr_i_debug = adr_i;
        //               `uvm_info("WB_IF_READ", $sformatf("Driven inputs for the Read transaction, addr = %d time = %t", adr_i, $time), UVM_LOW)
        //             end 
        //             else if (we_i & cyc_i & stb_i) begin 
        //               trans = WRITE;
        //               data = dat_i;
        //               addr_i = adr_i;
        //               trans_debug = WRITE;
        //               data_debug = dat_i;
        //               addr_i_debug = adr_i;

        //               `uvm_info("WB_IF_WRITE", $sformatf("Driven Write transaction, data = %h, addr = %d, time = %t", dat_i, adr_i, $time), UVM_LOW)
        //             end
        //             frk_00 = 0; // TODO debug
        //           end 
        //           begin                
        //             // if(stb_i) //Wait only if strobe is 1 else end this and wait for next posedge of clock
        //             // begin 
        //               frk_01 = 1; // TODO debug
        //               @(posedge ack_o);
        //               `uvm_info("FORK",$sformatf("Acknowledge occurs at time = %t", $time), UVM_LOW )
        //               if(trans == READ) begin 
        //                 data = dat_o;
        //                 data_debug =  dat_o;
        //                 `uvm_info("WB_IF_READ", $sformatf("Completed Write/Read transaction, data = %h, addr = %d, timr = %t", dat_o, adr_i, $time), UVM_LOW)

        //               // end
        //               `uvm_info("WB_IF_WRITE", $sformatf("Completed Write/Read transaction, data = %h, addr = %d, time = %t", dat_o, adr_i, $time), UVM_LOW)
        //               frk_01 = 0; // TODO debug
        //             end

        //           end
        //         join
        //   end
          // begin 
          //   @(posedge clock);
          //   if(stb_i & cyc_i)
          //     while (1) begin #1; end
          //   `uvm_info("WB_IF", $sformatf("TRANSACTION_DROPPED to IDLE"), UVM_LOW)            
          // end
        // join_any
        // disable fork;



  fork
          begin 
                fork
                  begin 
                    `uvm_info("FORK","Waiting for posedge of clock", UVM_LOW )
                    frk_00 = 1; // TODO debug
                    @(posedge we_i & cyc_i & stb_i);
                    `uvm_info("FORK",$sformatf("Wait for posedge has been over and values of stb = %b, cyc = %b, we_i = %b", stb_i, cyc_i, we_i), UVM_LOW )
                    @(posedge clock);
                    if (we_i & cyc_i & stb_i) begin 
                      trans = WRITE;
                      data = dat_i;
                      addr_i = adr_i;
                      trans_debug = WRITE;
                      data_debug = dat_i;
                      addr_i_debug = adr_i;
                      // if(addr_i >= 32'h20000300 && addr_i <= 32'h200003FF)
                      // begin
                      //   @(posedge ack_o);
                      //   @(posedge ack_o);
                      // end
                      `uvm_info("WRITE TERMINATE", $sformatf("Write block terminates at time = %t", $time), UVM_LOW)
                      `uvm_info("WB_IF_WRITE", $sformatf("Driven Write transaction, data = %h, addr = %d, time = %t", dat_i, adr_i, $time), UVM_LOW)
                    end
                    frk_00 = 0; // TODO debug
                  end 
                  begin                
                    // if(stb_i) //Wait only if strobe is 1 else end this and wait for next posedge of clock
                    // begin 
                      frk_01 = 1; // TODO debug
                      @(posedge ack_o);
                      @(posedge clock);
                    if(~we_i & cyc_i & stb_i) begin 
                      trans = READ;
                      addr_i = adr_i;
                      data = dat_o;
                      //  if(addr_i >= 32'h20000300 && addr_i <= 32'h200003FF)
                      // begin
                      //   @(posedge ack_o);
                      //   // @(posedge ack_o);
                      // end
                      `uvm_info("WB_IF_READ", $sformatf("Driven inputs for the Read transaction, addr = %d time = %t", adr_i, $time), UVM_LOW)
                    end 
                      `uvm_info("FORK",$sformatf("Acknowledge occurs at time = %t", $time), UVM_LOW )
                      `uvm_info("READ TERMINATE", $sformatf("Read block terminates at time = %t", $time), UVM_LOW)
                  end
                join_any
          end
          begin 
            @(posedge clock);
            if(stb_i & cyc_i)
              while (1) begin #1; end
            `uvm_info("WB_IF", $sformatf("TRANSACTION_DROPPED to IDLE"), UVM_LOW)    
            `uvm_info("OUTER BLOCK TERMINATE", $sformatf("Outer block terminates at time = %t", $time), UVM_LOW)        
          end
        join_any
        disable fork;


        trans_started = 0;
        trans_complete = 1;


        Reset = reset;

      end
    b = 1;
  endtask : collect_data

  
  // //Task for slave agent's driver
  // task send_to_dut_slave(output logic [2 : 0] addr_i, logic [7 : 0] data, transaction_type trans, logic Ack_o);

  //   @(posedge clock iff (reset == 0 && start == 1));
  //   if(stb_i && cyc_i)
  //     begin
  //       if(we_i == 1)
  //         begin
  //           trans = WRITE;
  //           addr_i = adr_i;
  //           data = dat_i;
  //           #20;
  //           ack_o = 1;
  //           Ack_o = ack_o;
  //           #2;
  //           ack_o = 0;
  //         end
  //       else if(we_i == 0)
  //         begin
  //           trans = READ;
  //           addr_i = adr_i;
  //           dat_o = 35;
  //           data = dat_o;
  //           #25;
  //           ack_o = 1;
  //           Ack_o = ack_o;
  //           #2;
  //           ack_o = 0;
  //         end
  //     end
  //   else
  //     begin
  //       trans = IDLE;
  //       addr_i = 'bx;
  //       data = 'b0;
  //       ack_o = 1'b0;
  //     end
    

  // endtask : send_to_dut_slave


endinterface : wishbone_if



