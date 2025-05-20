class wb_ref_model extends uvm_component;
  `uvm_component_utils(wb_ref_model)
//sending to scb
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2scb_port;

uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi1ref_port;
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi2ref_port;


// port for the wb uvc)
  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(wb_transaction, wb_ref_model) wb_in; 

//   uvm_analysis_imp_hbus#(hbus_transaction, router_reference) hbus_in;



  function new(string name = "wb_ref_model", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
    wb2scb_port = new("wb2scb_port", this);
    wb2spi1ref_port = new("wb2spi1ref_port", this);
     wb2spi2ref_port = new("wb2spi2ref_port", this);
    wb_in = new("wb_in", this);
    // hbus_in = new("hbus_in", this);
    // yapp_valid_port = new("yapp_valid_port", this);
  endfunction


function void write_wb(wb_transaction tr);   // type need to be fixed

// tr.addr ; 
//*********
// some mapping logic for uart
//*********
 if (tr.addr >= 32'h20000200 && tr.addr <= 32'h2000027F) begin
        // SPI_1

        wb2scb_port.write(tr);
        wb2spi1ref_port.write(tr);
       $display("SPI_1 transaction received (addr: %h)", tr.addr);

    end
    else if (tr.addr >= 32'h20000280 && tr.addr <= 32'h80040000) begin
        // SPI_2
        wb2scb_port.write(tr);
        wb2spi2ref_port.write(tr);
 wb2spi1ref_port.write(tr);
        $display("SPI_2 transaction received (addr: %h)", tr.addr);
    end
    else if (tr.addr >= 32'h00000020 && tr.addr <= 32'h0000003F) begin
        // UART

        
        $display("UART transaction received (addr: %h)", tr.addr);
    end
    else begin
        $display("Unknown address: %h", tr.addr);
    end
   
endfunction: write_wb




  // write_wb(wb_transaction t); // to scb

//ref_analysis_port.write_wb() // in spi_refmodel
//scb_port.write_wb() ; 


//


endclass