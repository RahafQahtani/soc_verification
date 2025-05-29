// typedef struct {
//   string test_name;
//   string sequence_name;
//   string sub_sequence_name;
//   string peripheral_name;
//   string result_data;
//   string result_status;
// } test_result_s;
// class soc_scb extends uvm_scoreboard;
//   `uvm_component_utils(soc_scb)

//   // Analysis ports
//   `uvm_analysis_imp_decl(_spi1)
//   uvm_analysis_imp_spi1#(spi_transaction, soc_scb) spi_in1;

//   `uvm_analysis_imp_decl(_spi2)
//   uvm_analysis_imp_spi2#(spi_transaction, soc_scb) spi_in2;

//   `uvm_analysis_imp_decl(_wb)
//     uvm_analysis_imp_wb#(wb_transaction, soc_scb) wb_in;


//   `uvm_analysis_imp_decl(_i2c)
//    uvm_analysis_imp_i2c#(i2c_transaction, soc_scb)  i2c_in;

//   // Status
//   int total_matched_packets  = 0;
//   int total_wrong_packets    = 0;

// //queues 
// //  i2c_transaction i2c_queue[$];   
// //     wb_transaction wb_queue[$];  
//   // Reference model instance 
//   wb_x_spi_module spi_ref_model;
//   wb_x_i2c_ref_model i2c_ref_model;
//   // Result tracking
//   test_result_s results[$];
//   test_result_s result;


//   function new(string name = "soc_scb", uvm_component parent);
//     super.new(name, parent);
//     spi_in1 = new("spi_in1", this);
//     spi_in2 = new("spi_in2", this);
//     wb_in  = new("wb_in", this);
//    i2c_in  = new("i2c_in", this);
//     spi_ref_model = wb_x_spi_module::type_id::create("spi_ref_model", this);
//   endfunction

//   function void write_spi1(spi_transaction t);
//     `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
//     spi_ref_model.rx_queue.push_back(t.data_out);
//     spi_ref_model.spi_queue.push_back(t);

//     compare_spi_transactions();
//   endfunction

//   function void write_spi2(spi_transaction t);
//     `uvm_info("SCOREBOARD", $sformatf("Received SPI2 Transaction: %s", t.sprint()), UVM_MEDIUM)
//     spi_ref_model.rx_queue.push_back(t.data_out);
//     spi_ref_model.spi_queue.push_back(t);

//     compare_spi_transactions();
//   endfunction

// function void write_i2c(i2c_transaction tr);

//         // i2c_queue.push_back(tr);
//         i2c_ref_model.i2c_queue.push_back(tr);
//         `uvm_info("SCOREBOARDy", $sformatf("Received i2c Transaction: %s", tr.sprint()), UVM_FULL)
                  
        
//         i2c_compare_transactions();
//     endfunction

//     function void write_wb(wb_transaction t);
//     `uvm_info("SCOREBOARD", $sformatf("Received REF Transaction: %s", t.sprint()), UVM_MEDIUM)
    
//        if (!uvm_config_db#(string)::get(this, "", "CUR_TEST_NAME", result.test_name))
//       `uvm_warning("SCOREBOARD", "Could not retrieve CUR_TEST_NAME from config DB");

//     if (!uvm_config_db#(string)::get(this, "", "CUR_SEQ_NAME", result.sequence_name))
//       `uvm_warning("SCOREBOARD", "Could not retrieve CUR_SEQ_NAME from config DB");
//          if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", result.peripheral_name))
//       `uvm_warning("SCOREBOARD", "Could not retrieve PERIPHERAL from config DB");
     
     
//      if(result.peripheral_name == "SPI1" ||result.peripheral_name == "SPI2" ) begin
//      if(t.addr ==2) begin
//     spi_ref_model.tx_queue.push_back(t.din);
//     spi_ref_model.rx_queue.push_back(t.dout);
//      end
//     spi_ref_model.wb_queue.push_back(t);
//      compare_spi_transactions();
//      end 
//   if(result.peripheral_name == "I2C" ) begin
//     //  wb_transaction clone_tr;
// 		// $cast(clone_tr,t.clone());
//     // wb_queue.push_back(t);
//         i2c_ref_model.wb_queue.push_back(t);
//         `uvm_info("SCOREBOARD", $sformatf("Received WB Transaction: %s", t.sprint()), UVM_FULL)

//  end             
    
//   endfunction


// function void compare_spi_transactions();
//   if (spi_ref_model.wb_queue.size() == 0)
//     return;

//   else begin
//   wb_transaction ref_pkt = spi_ref_model.wb_queue.pop_front();
//    if (ref_pkt.op_type == wb_read) begin
//   // Only expect SPI data for SPDR register 
//     case (ref_pkt.addr[4:2])
//       3'b0: compare_reg("SPCR", ref_pkt.dout, spi_ref_model.get_SPCR());
//       3'b001: compare_reg("SPSR", ref_pkt.dout, spi_ref_model.get_SPSR());
//        3'b010: begin // SPDR
//             if (spi_ref_model.spi_queue.size() > 0 &&
//             spi_ref_model.rx_queue.size() > 0 &&
//             spi_ref_model.tx_queue.size() > 0) begin
//             bit [7:0] expected_data = spi_ref_model.rx_queue.pop_front();
//             bit [7:0] actual_data   = spi_ref_model.tx_queue.pop_front();
//             spi_transaction spi_pkt = spi_ref_model.spi_queue.pop_front();
//             result.sub_sequence_name = "SPI Data Compare";
//               result.result_data = $sformatf("Expected: %h, Actual: %h", spi_ref_model.get_SPDR(), spi_pkt.data_in);
//               result.result_status = (spi_pkt.data_in == spi_ref_model.get_SPDR()) ? "PASSED" : "FAILED";
//               results.push_back(result);
//              if (spi_pkt.data_in == spi_ref_model.get_SPDR()) 
//               total_matched_packets++;
//             else 
//               total_wrong_packets++;
            
//             end
//             end 
//       3'b011: compare_reg("SPER", ref_pkt.dout, spi_ref_model.get_SPER());
//       3'b100: compare_reg("CSREG", ref_pkt.dout, spi_ref_model.get_CSREG());
//      default: begin 
//         `uvm_warning("SCOREBOARD", "Unhandled wb_pkt.addr in comparison");
//          end 
//     endcase
   
//   end 
  
//   end 
// endfunction


//   function void i2c_compare_transactions();
//        if (i2c_ref_model.i2c_queue.size() > 0 ) begin //&& wb_queue.size() > 0
//         // if (i2c_ref_model.i2c_queue.size() > 0 && i2c_ref_model.wb_queue.size() > 0) begin //
//             i2c_transaction i2c_pkt = i2c_ref_model.i2c_queue.pop_front();
//             wb_transaction wb_pkt = i2c_ref_model.wb_queue.pop_front();
//                wb_transaction wb_pkt = i2c_ref_model.wb_queue.pop_front();
//             if (wb_pkt.op_type==wb_write)begin 
//               result.sub_sequence_name = "I2C Data Compare";
//               result.result_data = $sformatf("Expected: %0h, Actual: %0h",i2c_pkt.din, wb_pkt.din);
//               result.result_status = (i2c_pkt.din == wb_pkt.din) ? "PASSED" : "FAILED";
//               results.push_back(result);

//                 if (i2c_pkt.din == wb_pkt.din) 
//                    total_matched_packets++;
//                 else 
//                   total_wrong_packets++;
//             end  
//             else if  (wb_pkt.op_type==wb_read) begin 
//                  result.sub_sequence_name = "I2C Data Compare";
//               result.result_data = $sformatf("Expected: %h, Actual: %h",i2c_pkt.din, wb_pkt.din);
//               result.result_status = (i2c_pkt.din == wb_pkt.din) ? "PASSED" : "FAILED";
//               results.push_back(result);

//                 if (i2c_pkt.dout == wb_pkt.din) 
//                    total_matched_packets++;
//                 else 
//                   total_wrong_packets++;
//             end  
            
//         end
//     endfunction:i2c_compare_transactions

// //resuable function for all peripherals
// function void compare_reg(string name, bit [31:0] actual, bit [31:0] expected);
//     void'(spi_ref_model.rx_queue.pop_front());
//       void'(spi_ref_model.tx_queue.pop_front());
//       result.sub_sequence_name = $sformatf("Compare %s", name);
//       `uvm_info("SCO", $sformatf("SPSR before compare: %h", spi_ref_model.get_SPSR()), UVM_LOW)

//     result.result_data = $sformatf("Expected: %0h, Actual: %0h", expected, actual);
//     result.result_status = (actual == expected) ? "PASSED" : "FAILED";
//     results.push_back(result);
//   if (actual == expected) 
//     total_matched_packets++;
//    else
//     total_wrong_packets++;
  
// endfunction

//   function void report_phase(uvm_phase phase);
  

//     int fd;
//     string msg;
//       super.report_phase(phase);
//     `uvm_info(get_name(), "===== SCOREBOARD SUMMARY =====", UVM_NONE)

//     fd = $fopen("scoreboard_summary.txt", "a");
//     msg = "==================================================";
//     $fwrite(fd, msg, "\n");

 

//     msg = $sformatf("TEST: %s | SEQ: %s", result.test_name, result.sequence_name);
//     $fwrite(fd, msg, "\n");

//     foreach (results[i]) begin
//       msg = $sformatf("Sub Seq: %s | Peripheral: %s | Result : %s | Status: %s",
//                       results[i].sub_sequence_name,
//                       results[i].peripheral_name,
//                       results[i].result_data,
//                       results[i].result_status);
//       `uvm_info(get_name(), msg, UVM_NONE)
//       $fwrite(fd, msg, "\n");
//     end

//     $fwrite(fd, "--------------------------------------------------\n");
//     $fwrite(fd, "Total Matched Packets : %0d\n", total_matched_packets);
//     $fwrite(fd, "Total Mismatched Packets   : %0d\n", total_wrong_packets);
//     $fclose(fd);
//   endfunction : report_phase

// endclass 

typedef struct {
  string test_name;
  string sequence_name;
  string sub_sequence_name;
  string peripheral_name;
  string result_data;
  string result_status;
} test_result_s;
class soc_scb extends uvm_scoreboard;
  `uvm_component_utils(soc_scb)

  // Analysis ports
  `uvm_analysis_imp_decl(_spi1)
  uvm_analysis_imp_spi1#(spi_transaction, soc_scb) spi_in1;

  `uvm_analysis_imp_decl(_spi2)
  uvm_analysis_imp_spi2#(spi_transaction, soc_scb) spi_in2;

  `uvm_analysis_imp_decl(_wb)
    uvm_analysis_imp_wb#(wb_transaction, soc_scb) wb_in;

  `uvm_analysis_imp_decl(_i2c)
   uvm_analysis_imp_i2c#(i2c_transaction, soc_scb)  i2c_in;
   
  `uvm_analysis_imp_decl(_uart1tx)
   uvm_analysis_imp_uart1tx#(uart_frames, soc_scb)  uart1_tx_in;
  `uvm_analysis_imp_decl(_uart1rx)
   uvm_analysis_imp_uart1rx#(uart_frames, soc_scb)  uart1_rx_in;
  // Status
  int total_matched_packets  = 0;
  int total_wrong_packets    = 0;

  // Reference model instance 
  wb_x_spi_module spi_ref_model;
  wb_x_i2c_ref_model i2c_ref_model;
   wb_uart_ref_model uart_ref_model;
  // Result tracking
  test_result_s results[$];
  test_result_s result;
 //uart fifos 
uvm_tlm_fifo #(logic [7:0]) uart_expected_value_fifo;
	uvm_tlm_fifo #(logic [7:0]) uart_actual_value_fifo;
  logic [7:0] expected_value;
logic [7:0] actual_value;
  // //uart events
  //  uvm_event e;
  // uvm_event_pool sbd_2_seq_event_pool;
	// uvm_event sbd_2_seq_event;
	// uvm_event uvm_2_core_sync_event;

  //builders 
  function new(string name = "soc_scb", uvm_component parent);
    super.new(name, parent);
    spi_in1 = new("spi_in1", this);
    spi_in2 = new("spi_in2", this);
    wb_in  = new("wb_in", this);
   i2c_in  = new("i2c_in", this);
   uart1_tx_in  = new("uart1_tx_in", this);
    uart1_rx_in  = new("uart1_rx_in", this);
    spi_ref_model = wb_x_spi_module::type_id::create("spi_ref_model", this);
     i2c_ref_model = wb_x_i2c_ref_model::type_id::create("i2c_ref_model", this);
       uart_ref_model=wb_uart_ref_model::type_id::create("uart_ref_model", this);
    uart_expected_value_fifo = new("uart_expected_value_fifo",this,100);
		uart_actual_value_fifo = new("uart_actual_value_fifo",this,100);
    // add_event("UART_Data_Event");
	 	// add_event("SPI_Data_Event");
  endfunction
function void  build_phase(uvm_phase phase);
		super.build_phase(phase);
	      //   if (!uvm_config_db#(uvm_event_pool)::get(this, "", "sbd_2_seq_event_pool", sbd_2_seq_event_pool))
			  // `uvm_error("CONFIGDB", "Event Pool not found in config DB");

endfunction
  function void write_spi1(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_ref_model.rx_queue.push_back(t.data_out);
    spi_ref_model.spi_queue.push_back(t);

    compare_spi_transactions();
  endfunction

  function void write_spi2(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI2 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_ref_model.rx_queue.push_back(t.data_out);
    spi_ref_model.spi_queue.push_back(t);

    compare_spi_transactions();
  endfunction

function void write_i2c(i2c_transaction tr);

        // i2c_queue.push_back(tr);
        i2c_ref_model.i2c_queue.push_back(tr);
        `uvm_info("SCOREBOARD", $sformatf("Received i2c Transaction: %s", tr.sprint()), UVM_FULL)
                  
        
        i2c_compare_transactions();
    endfunction

function void write_uart1tx(uart_frames f);

    //  	uart_frames clone_m_uart_frames;
		// uart_ref_model.write_tx_mon(clone_m_uart_frames);
		uart_expected_value_fifo.try_put(f.data);
    `uvm_info("SCOREBOARD", $sformatf("Received uart Transaction: %s", f.sprint()), UVM_FULL)
                

    endfunction

function void write_uart1rx(uart_frames f);
		uart_frames clone_m_uart_frames;
		$cast(clone_m_uart_frames,f.clone());
		uart_ref_model.write_rx_mon(f);

		result.sub_sequence_name = "passive : tx from wishbone and rx by UART";
		uart_actual_value_fifo.try_put(clone_m_uart_frames.data);

	
	endfunction  
    
    function void write_wb(wb_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received REF Transaction: %s", t.sprint()), UVM_MEDIUM)
    
       if (!uvm_config_db#(string)::get(this, "", "CUR_TEST_NAME", result.test_name))
      `uvm_warning("SCOREBOARD", "Could not retrieve CUR_TEST_NAME from config DB");

    if (!uvm_config_db#(string)::get(this, "", "CUR_SEQ_NAME", result.sequence_name))
      `uvm_warning("SCOREBOARD", "Could not retrieve CUR_SEQ_NAME from config DB");
         if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", result.peripheral_name))
      `uvm_warning("SCOREBOARD", "Could not retrieve PERIPHERAL from config DB");
     
     
     if(result.peripheral_name == "SPI1" ||result.peripheral_name == "SPI2" ) begin
     if(t.addr ==2) begin
    spi_ref_model.tx_queue.push_back(t.din);
    spi_ref_model.rx_queue.push_back(t.dout);
     end
    spi_ref_model.wb_queue.push_back(t);
     compare_spi_transactions();
     end 
  if(result.peripheral_name == "I2C" ) begin
        uart_ref_model.wb_queue.push_back(t);
        `uvm_info("SCOREBOARD", $sformatf("Received WB Transaction: %s", t.sprint()), UVM_FULL)

 end  
 
 if (result.peripheral_name == "UART" ) begin
      // if (!uvm_config_db#(uvm_event)::get(this, "", "uvm_2_core_sync_event", uvm_2_core_sync_event))
			//   `uvm_error("SYNC_EVENT", "UVM to Core sync event not found");
 uart_ref_model.wb_queue.push_back(t);
// if(t.op_type=wb_write && t.addr[4:2]==0)
// uart_expected_value_fifo.try_put(t);
// if(t.op_type=wb_read && t.addr[4:2]==0)
// uart_actual_value_fifo.try_put(t);
  uart_compare_transactions(t);
   end  
  endfunction


function void compare_spi_transactions();
  if (spi_ref_model.wb_queue.size() == 0)
    return;

  else begin
  wb_transaction ref_pkt = spi_ref_model.wb_queue.pop_front();
   if (ref_pkt.op_type == wb_read) begin
  // Only expect SPI data for SPDR register 
    case (ref_pkt.addr[4:2])
      3'b0: compare_reg("SPCR", ref_pkt.dout, spi_ref_model.get_SPCR());
      3'b001: compare_reg("SPSR", ref_pkt.dout, spi_ref_model.get_SPSR());
       3'b010: begin // SPDR
            if (spi_ref_model.spi_queue.size() > 0 &&
            spi_ref_model.rx_queue.size() > 0 &&
            spi_ref_model.tx_queue.size() > 0) begin
            bit [7:0] expected_data = spi_ref_model.rx_queue.pop_front();
            bit [7:0] actual_data   = spi_ref_model.tx_queue.pop_front();
            spi_transaction spi_pkt = spi_ref_model.spi_queue.pop_front();
            result.sub_sequence_name = "SPI Data Compare";
              result.result_data = $sformatf("Expected: %h, Actual: %h", spi_ref_model.get_SPDR(), spi_pkt.data_in);
              result.result_status = (spi_pkt.data_in == spi_ref_model.get_SPDR()) ? "PASSED" : "FAILED";
              results.push_back(result);
             if (spi_pkt.data_in == spi_ref_model.get_SPDR()) 
              total_matched_packets++;
            else 
              total_wrong_packets++;
            
            end
            end 
      3'b011: compare_reg("SPER", ref_pkt.dout, spi_ref_model.get_SPER());
      3'b100: compare_reg("CSREG", ref_pkt.dout, spi_ref_model.get_CSREG());
     default: begin 
        `uvm_warning("SCOREBOARD", "Unhandled wb_pkt.addr in comparison");
         end 
    endcase
   
  end 
  
  end 
endfunction


  function void i2c_compare_transactions();
       if (i2c_ref_model.i2c_queue.size() > 0 ) begin //&& wb_queue.size() > 0
        // if (i2c_ref_model.i2c_queue.size() > 0 && i2c_ref_model.wb_queue.size() > 0) begin //
            i2c_transaction i2c_pkt = i2c_ref_model.i2c_queue.pop_front();
            wb_transaction wb_pkt = i2c_ref_model.wb_queue.pop_front();
               wb_transaction wb_pkt = i2c_ref_model.wb_queue.pop_front();
            if (wb_pkt.op_type==wb_write)begin 
              result.sub_sequence_name = "I2C Data Compare";
              result.result_data = $sformatf("Expected: %0h, Actual: %0h",i2c_pkt.din, wb_pkt.din);
              result.result_status = (i2c_pkt.din == wb_pkt.din) ? "PASSED" : "FAILED";
              results.push_back(result);

                if (i2c_pkt.din == wb_pkt.din) 
                   total_matched_packets++;
                else 
                  total_wrong_packets++;
            end  
            else if  (wb_pkt.op_type==wb_read) begin 
                 result.sub_sequence_name = "I2C Data Compare";
              result.result_data = $sformatf("Expected: %h, Actual: %h",i2c_pkt.din, wb_pkt.din);
              result.result_status = (i2c_pkt.din == wb_pkt.din) ? "PASSED" : "FAILED";
              results.push_back(result);

                if (i2c_pkt.dout == wb_pkt.din) 
                   total_matched_packets++;
                else 
                  total_wrong_packets++;
            end  
            
        end
    endfunction:i2c_compare_transactions
    
    
function void uart_compare_transactions(wb_transaction wb_pkt);
  //  wb_transaction wb_pkt = uart_ref_model.wb_queue.pop_front();
  if (wb_pkt.op_type==wb_write) begin
    case (wb_pkt.addr[4:2])
      3'b000: begin
        if (uart_ref_model.get_LCR() == 8'h03) begin
          uart_expected_value_fifo.try_put(wb_pkt.din[7:0]);

        end
      end
    endcase
  end

  else if (wb_pkt.op_type==wb_read) begin
    case (wb_pkt.addr [4:2])
      3'b000: begin
        if (uart_ref_model.get_LCR() == 8'h83) begin
         // compare_result("DL_LSB", uart_ref_model.get_Divisor_Latch_LSB(), wb_pkt.dout, result);
           result.sub_sequence_name = "UART Data Compare DL_LSB";
              result.result_data = $sformatf("Expected: %h, Actual: %h",uart_ref_model.get_Divisor_Latch_LSB(), wb_pkt.dout);
              result.result_status = (uart_ref_model.get_Divisor_Latch_LSB() == wb_pkt.dout) ? "PASSED" : "FAILED";
              results.push_back(result);
        end
        else begin  
          $display("Rx FIFO Data Received in Scoreboard");
          uart_actual_value_fifo.try_put(wb_pkt.dout);

        end
      end

      3'b001: begin
        if (uart_ref_model.get_LCR() == 8'h83) begin
          //compare_result("DL_MSB", uart_ref_model.get_Divisor_Latch_MSB(), wb_pkt.dout, result);
          result.sub_sequence_name = "UART Data Compare DL_MSB";
              result.result_data = $sformatf("Expected: %h, Actual: %h",uart_ref_model.get_Divisor_Latch_MSB(), wb_pkt.dout);
              result.result_status = (uart_ref_model.get_Divisor_Latch_MSB() == wb_pkt.dout) ? "PASSED" : "FAILED";
              results.push_back(result);
        end  
        else begin  
          //compare_result("IER", uart_ref_model.get_IER(), wb_pkt.dout, result);
           result.sub_sequence_name = "UART Data Compare IER";
              result.result_data = $sformatf("Expected: %h, Actual: %h",uart_ref_model.get_IER(), wb_pkt.dout);
              result.result_status = (uart_ref_model.get_IER() == wb_pkt.dout) ? "PASSED" : "FAILED";
              results.push_back(result);
        end
      end

      3'b010: begin
        //compare_result("IIR", uart_ref_model.get_IIR(), wb_pkt.dout, result);
        result.sub_sequence_name = "UART Data Compare IIR";
              result.result_data = $sformatf("Expected: %h, Actual: %h",uart_ref_model.get_IIR(), wb_pkt.dout);
              result.result_status = (uart_ref_model.get_IIR() == wb_pkt.dout) ? "PASSED" : "FAILED";
              results.push_back(result);
      end

      3'b011: begin      
       // compare_result("LCR", uart_ref_model.get_LCR(), wb_pkt.dout, result);
           result.sub_sequence_name = "UART Data Compare LCR";
              result.result_data = $sformatf("Expected: %h, Actual: %h",uart_ref_model.get_LCR(), wb_pkt.dout);
              result.result_status = (uart_ref_model.get_LCR() == wb_pkt.dout) ? "PASSED" : "FAILED";
              results.push_back(result);
      end
    endcase


  end
endfunction : uart_compare_transactions


task run_phase (uvm_phase phase);
// super.run_phase(phase);

		forever begin
			if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", result.peripheral_name))
			  `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");

	
			if(result.peripheral_name == "UART")
			begin	
				uart_expected_value_fifo.get(expected_value);
				uart_actual_value_fifo.get(actual_value);

				//compare_result("UART_Data",expected_value, actual_value,result);
         result.sub_sequence_name = "UART Data Compare";
              result.result_data = $sformatf("Expected: %h, Actual: %h",expected_value, actual_value);
              result.result_status = (expected_value == actual_value) ? "PASSED" : "FAILED";
              results.push_back(result);
								end
    end 
    endtask
//resuable function for all peripherals
function void compare_reg(string name, bit [31:0] actual, bit [31:0] expected);
    void'(spi_ref_model.rx_queue.pop_front());
      void'(spi_ref_model.tx_queue.pop_front());
      result.sub_sequence_name = $sformatf("Compare %s", name);
      `uvm_info("SCO", $sformatf("SPSR before compare: %h", spi_ref_model.get_SPSR()), UVM_LOW)

    result.result_data = $sformatf("Expected: %0h, Actual: %0h", expected, actual);
    result.result_status = (actual == expected) ? "PASSED" : "FAILED";
    results.push_back(result);
  if (actual == expected) 
    total_matched_packets++;
   else
    total_wrong_packets++;
  
endfunction
// //uart event 
//       function void add_event(string name);
// 	  uvm_event e;

// 	  if (!sbd_2_seq_event_pool.exists(name)) begin
// 	    e = new(name);                          // Create the event
// 	    sbd_2_seq_event_pool.add(name, e);              // Add it to the pool
// 	    `uvm_info("SB", $sformatf("Added event: %s", name), UVM_LOW)
// 	  end else begin
// 	    `uvm_warning("SB", $sformatf("Event already exists: %s", name))
// 	  end
// 	endfunction

  function void report_phase(uvm_phase phase);
  

    int fd;
    string msg;
      super.report_phase(phase);
    `uvm_info(get_name(), "===== SCOREBOARD SUMMARY =====", UVM_NONE)

    fd = $fopen("scoreboard_summary.txt", "a");
    msg = "==================================================";
    $fwrite(fd, msg, "\n");

 

    msg = $sformatf("TEST: %s | SEQ: %s", result.test_name, result.sequence_name);
    $fwrite(fd, msg, "\n");

    foreach (results[i]) begin
      msg = $sformatf("Sub Seq: %s | Peripheral: %s | Result : %s | Status: %s",
                      results[i].sub_sequence_name,
                      results[i].peripheral_name,
                      results[i].result_data,
                      results[i].result_status);
      `uvm_info(get_name(), msg, UVM_NONE)
      $fwrite(fd, msg, "\n");
    end

    $fwrite(fd, "--------------------------------------------------\n");
    $fwrite(fd, "Total Matched Packets : %0d\n", total_matched_packets);
    $fwrite(fd, "Total Mismatched Packets   : %0d\n", total_wrong_packets);
    $fclose(fd);
  endfunction : report_phase

endclass 
