// class wb_ref_model extends uvm_component;
//   `uvm_component_utils(wb_ref_model)
// //sending to scb
// uvm_analysis_port #(wb_transaction,wb_ref_model) wb2scb_port;

// uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi1ref_port;
// uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi2ref_port;
// uvm_analysis_port #(wb_transaction,wb_ref_model) wb2i2cref_port;
// uvm_analysis_port #(wb_transaction,wb_ref_model) wb2uartref_port;
// // port for the wb uvc)
//   `uvm_analysis_imp_decl(_wb)
//   uvm_analysis_imp_wb#(wb_transaction, wb_ref_model) wb_in; 





//   function new(string name = "wb_ref_model", uvm_component parent);
//     super.new(name, parent);
//     `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
//     wb2scb_port = new("wb2scb_port", this);
//     wb2spi1ref_port = new("wb2spi1ref_port", this);
//      wb2spi2ref_port = new("wb2spi2ref_port", this);
//       wb2i2cref_port = new("wb2i2cref_port", this);
//       wb2uartref_port= new("wb2uartref_port", this);
//     wb_in = new("wb_in", this);
  
//   endfunction


// function void write_wb(wb_transaction tr);  


//  if (tr.addr >= 32'h20000200 && tr.addr <= 32'h2000027F) begin
//         // SPI_1

//         wb2scb_port.write(tr);
//         wb2spi1ref_port.write(tr);
//        $display("SPI_1 transaction received (addr: %h)", tr.addr);

//     end
//     else if (tr.addr >= 32'h20000280 && tr.addr <= 32'h200002FF) begin
//         // SPI_2
//         wb2scb_port.write(tr);
//         wb2spi2ref_port.write(tr);

//         $display("SPI_2 transaction received (addr: %h)", tr.addr);
//     end
//     else if (tr.addr >= 32'h20000000 && tr.addr <= 32'h200000FF) begin
//         // UART
//        wb2scb_port.write(tr);
//         wb2uartref_port.write(tr);
        
//         $display("UART transaction received (addr: %h)", tr.addr);
//     end
//     else if (tr.addr >= 32'h20000300 && tr.addr <= 32'h200003FF) begin
//       //I2C
//         wb2scb_port.write(tr);
//         wb2i2cref_port.write(tr);  
//         $display("i2c transaction received (addr: %h)", tr.addr);
//     end
//     else begin
//         $display("Unknown address: %h", tr.addr);
//     end
   
// endfunction: write_wb







// endclass

class wb_ref_model extends uvm_component;
  `uvm_component_utils(wb_ref_model)
//sending to scb
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2scb_port;

uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi1ref_port;
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2spi2ref_port;
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2i2cref_port;
uvm_analysis_port #(wb_transaction,wb_ref_model) wb2uart1ref_port;
// port for the wb uvc)
  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(wb_transaction, wb_ref_model) wb_in; 





  function new(string name = "wb_ref_model", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
    wb2scb_port = new("wb2scb_port", this);
    wb2spi1ref_port = new("wb2spi1ref_port", this);
     wb2spi2ref_port = new("wb2spi2ref_port", this);
      wb2i2cref_port = new("wb2i2cref_port", this);
      wb2uart1ref_port=new("wb2uart1ref_port", this);
    wb_in = new("wb_in", this);
  
  endfunction


function void write_wb(wb_transaction tr);  


 if (tr.addr >= 32'h20000200 && tr.addr <= 32'h2000027F) begin
        // SPI_1

        wb2scb_port.write(tr);
        wb2spi1ref_port.write(tr);
       $display("SPI_1 transaction received (addr: %h)", tr.addr);

    end
    else if (tr.addr >= 32'h20000280 && tr.addr <= 32'h200002FF) begin
        // SPI_2
        wb2scb_port.write(tr);
        wb2spi2ref_port.write(tr);

        $display("SPI_2 transaction received (addr: %h)", tr.addr);
    end
    else if (tr.addr >= 32'h20000000 && tr.addr <= 32'h200000FF) begin
        // UART
         wb2scb_port.write(tr);
        wb2uart1ref_port.write(tr);
        
        $display("UART 1 transaction received (addr: %h)", tr.addr);
    end
    else if (tr.addr >= 32'h20000300 && tr.addr <= 32'h200003FF) begin
      //I2C
        wb2scb_port.write(tr);
        wb2i2cref_port.write(tr);  
        $display("i2c transaction received (addr: %h)", tr.addr);
    end
    else begin
        $display("Unknown address: %h", tr.addr);
    end
   
endfunction: write_wb







endclass