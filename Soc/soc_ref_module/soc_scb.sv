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

  // Status
  int total_packets_received = 0;
  int total_matched_packets  = 0;
  int total_wrong_packets    = 0;
  int total_spi_transactions = 0;
  int total_ref_transactions = 0;

  // Reference model instance 
  wb_x_spi_module spi_ref_model;

  // Result tracking
  test_result_s results[$];
  test_result_s result;


  function new(string name = "soc_scb", uvm_component parent);
    super.new(name, parent);
    spi_in1 = new("spi_in1", this);
    spi_in2 = new("spi_in2", this);
    wb_in  = new("wb_in", this);
    spi_ref_model = wb_x_spi_module::type_id::create("spi_ref_model", this);
  endfunction

  function void write_spi1(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_ref_model.rx_queue.push_back(t.data_out);
    spi_ref_model.spi_queue.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_spi_transactions();
  endfunction

  function void write_spi2(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI2 Transaction: %s", t.sprint()), UVM_MEDIUM)
    spi_ref_model.rx_queue.push_back(t.data_out);
    spi_ref_model.spi_queue.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_spi_transactions();
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
              result.result_data = $sformatf("Expected: %h, Actual: %h", spi_pkt.data_in, spi_ref_model.get_SPDR());
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
        `uvm_warning("SCOREBOARD", "Unhandled address in comparison");
         end 
    endcase
   
  end 
  
  end 
endfunction

//resuable function for all peripherals
function void compare_reg(string name, bit [31:0] actual, bit [31:0] expected);
    void'(spi_ref_model.rx_queue.pop_front());
      void'(spi_ref_model.tx_queue.pop_front());
      result.sub_sequence_name = $sformatf("Compare %s", name);
    result.result_data = $sformatf("Expected: %0h, Actual: %0h", expected, actual);
    result.result_status = (actual == expected) ? "PASSED" : "FAILED";
    results.push_back(result);
  if (actual == expected) 
    total_matched_packets++;
   else
    total_wrong_packets++;
  
endfunction

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

