class wb_x_spi_module extends uvm_component;
  `uvm_component_utils(wb_x_spi_module)

  // Registers
  logic [7:0] SPCR = 8'h10;  // Control Register
  logic [7:0] SPSR ;  // Status Register
  logic [7:0] SPDR = 8'h00;  // Data Register
  logic [7:0] SPER = 8'h00;  // Extensions Register
  logic [7:0] CSREG = 8'h00; // Chip Select Register
  bit rest;
  // Queues for tracking TX (WB) and RX (SPI) data
  bit [7:0] tx_queue[$]; // Data sent from WB to SPI
  bit [7:0] rx_queue[$]; // Data received from SPI UVC

  wb_transaction wb_queue[$];
  spi_transaction spi_queue[$]; 

  // Analysis port to send transactions to scoreboard
  uvm_analysis_port#(wb_transaction) ref_analysis_port;

  // Analysis implementation port to receive WB transactions from monitor
  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(wb_transaction, wb_x_spi_module) wb_in;

  function new(string name = "wb_x_spi_module", uvm_component parent);
    super.new(name, parent);
    ref_analysis_port = new("ref_analysis_port", this);
    wb_in = new("wb_in", this);
  endfunction

  function void write_wb(wb_transaction t);
    wb_transaction s;
    s = wb_transaction::type_id::create("s", this);
`uvm_info("Spi ref", $sformatf("Received REF Transaction: %s", t.sprint()), UVM_MEDIUM)
    
    s.addr = t.addr;
    s.op_type = t.op_type;
    s.valid_sb = t.valid_sb;
    s.rest_rf=t.rest_rf; 
  //  rest=t.rest_rf; 
    if (t.rest_rf==1 )begin 
      `uvm_info("sc","reseted",UVM_LOW)
      SPCR = 8'h10;  // Control Register
      SPSR = 8'h05;  // Status Register
      SPDR = 8'h00;  // Data Register
      SPER = 8'h00;  // Extensions Register
      CSREG = 8'h00; // Chip Select Register
//  update_status_register(1); // update SPSR flags
 tx_queue.delete();
  rx_queue.delete();
  wb_queue.delete();
  spi_queue.delete();
    end 
    else begin
    if (t.op_type == wb_write) begin
      s.dout = t.dout;
      s.din  = t.din;

       case (t.addr[4:2])
        32'h0: begin  
        
        SPCR = t.din;
         if (SPCR[6]==0) begin
          tx_queue.delete();
          rx_queue.delete();
          SPSR[7] = 1'b0;
          SPSR[6] = 1'b0;
          end 
        end 
        32'h1: SPSR = t.din;
        32'h2: begin 
                  SPDR = t.din;
                  SPSR[7] = 1'b1;
                    if (SPSR[3]) SPSR[6] = 1'b1; //WCOL is stressed if Write fifo full 
                   tx_queue.push_back(t.din);
               
              end
        32'h3: SPER = t.din;
        32'h4: CSREG = t.din;
        default: ;
      endcase
      // update_status_register(rest); // update SPSR flags
    end else if (t.op_type == wb_read) begin
      s.din = t.din;
      case (t.addr[4:2])
        32'h0: s.dout = SPCR;
        32'h1: s.dout = SPSR;
        32'h2: begin s.dout = SPDR;
        // SPSR[7] = 1'b0; 
        end  
        32'h3: s.dout = SPER;
        32'h4: s.dout = CSREG;
        default: s.dout = 8'h00;
      endcase
    end
       update_status_register(t.rest_rf); // update SPSR flags

    end 
   
    ref_analysis_port.write(s);
    
  endfunction

   
   task update_status_register(input logic reset);
   if (reset == 0) begin
    // Normal update mode
    SPSR[7] = SPSR[7]; // preserve IF if already set
    SPSR[6] = 0; // WCOL
    SPSR[3] = (tx_queue.size() >= 4); // WFFULL
    SPSR[2] = (tx_queue.size() == 0); // WFEMPTY
    SPSR[1] = (rx_queue.size() >= 4); // RFFULL
    SPSR[0] = (rx_queue.size() == 0); // RFEMPTY
    if( SPSR[3]) SPSR[0]=0;
  end
   `uvm_info("SPSR_MON", $sformatf("SPSR Updated: %02h | IF=%0b WCOL=%0b WFFULL=%0b WFEMPTY=%0b RFFULL=%0b RFEMPTY=%0b",
                                SPSR,
                                SPSR[7], SPSR[6], SPSR[3], SPSR[2], SPSR[1], SPSR[0]), UVM_MEDIUM)

endtask


  // Getter Functions
  function logic [7:0] get_SPCR();
    return SPCR;
  endfunction

  function logic [7:0] get_SPSR();

    `uvm_info("SPSR_MON_1", $sformatf("SPSR Updated: %0h ",
                                SPSR), UVM_LOW)
 return SPSR;
  endfunction

  function logic [7:0] get_SPER();
    return SPER;
  endfunction
  function logic [7:0] get_SPDR();
  
    return SPDR;
  endfunction

  function logic [7:0] get_CSREG();
    return CSREG;
  endfunction

endclass
