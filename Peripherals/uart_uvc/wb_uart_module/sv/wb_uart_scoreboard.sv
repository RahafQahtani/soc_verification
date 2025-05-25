// class wb_uart_scoreboard extends uvm_scoreboard;
// 	// import uart_pkg::*;
// 	// import wb_pkg::*;

// 	bit[2:0] address;
// 	`uvm_component_utils(wb_uart_scoreboard);



// 	`uvm_analysis_imp_decl(_wb_uart_analysis_imp);
// 	`uvm_analysis_imp_decl(_uart_tx_mon);
// 	`uvm_analysis_imp_decl(_uart_rx_mon);

// 	wb_uart_ref_model m_wb_uart_ref_model;

// 	uvm_analysis_imp_wb_uart_analysis_imp #(wb_transaction, wb_uart_scoreboard) 
// 		wb_uart_analysis_imp  = new("wb_uart_analysis_imp",this);


// 	function void write_wb_uart_analysis_imp(input wb_transaction wb_trans);
// 		wb_transaction clone_m_wb_trans;
// 		$cast(clone_m_wb_trans,wb_trans.clone());
// //		m_wb_uart_ref_model.write_tx_mon(m_uart_frames);
// 		 address = clone_m_wb_trans.adr_i >> 2;
// 		case(address)
// 			3'b000:
// 		       	begin 
			
// 				if(clone_m_wb_trans.trans == READ)
// 				begin	
// 					if(clone_m_wb_trans.data != m_wb_uart_ref_model.get_rx_data())
// 						        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Receiiver FIFO at address = %d. Expected value = %d, Produced value = %d", address,m_wb_uart_ref_model.get_rx_data() , clone_m_wb_trans.data[7:0]))
//                                   	else          
                                        	
// 						        `uvm_info("MATCH", $sformatf("Match between the values of Receiiver FIFO at address = %d. Expected value = %d, Produced value = %d", address,m_wb_uart_ref_model.get_rx_data() , clone_m_wb_trans.data[7:0]),UVM_LOW)
// 				end
// 			end	
// 			3'b010:
// 		       	begin 
			
// 				if(clone_m_wb_trans.trans == READ)
// 				begin	
// 					if(clone_m_wb_trans.data != m_wb_uart_ref_model.get_IIR())
// 						        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of IIR at address = %d. Expected value = %b, Produced value = %b", address,m_wb_uart_ref_model.get_IIR() , clone_m_wb_trans.data[7:0]))
//                                   	else          
                                        	
// 						        `uvm_info("MATCH", $sformatf("Match between the values of IIRF at address = %d. Expected value = %b, Produced value = %b", address,m_wb_uart_ref_model.get_IIR() , clone_m_wb_trans.data[7:0]),UVM_LOW)
// 				end
// 			end	
					
// 			3'b101:
// 		       	begin 
// 		/*	
// 				if(clone_m_wb_trans.trans == READ)
// 				begin	
// 					if(clone_m_wb_trans.data != m_wb_uart_ref_model.get_LSR())
// 						        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of LSR at address = %d. Expected value = %b, Produced value = %b", address,m_wb_uart_ref_model.get_LSR() , clone_m_wb_trans.data[7:0]))
//                                   	else          
                                        	
// 						        `uvm_info("MATCH", $sformatf("Match between the values of LSR at address = %d. Expected value = %b, Produced value = %b", address,m_wb_uart_ref_model.get_LSR() , clone_m_wb_trans.data[7:0]),UVM_LOW)
// 				end*/
// 			end	
					
		
// 		endcase

// 	endfunction


// 	uvm_analysis_imp_uart_tx_mon#(uart_frames, wb_uart_scoreboard) 
// 		uart_tx_analysis_imp  = new("uart_tx_analysis_imp",this);


// 	function void write_uart_tx_mon(input uart_frames m_uart_frames);
// 		uart_frames clone_m_uart_frames;
// 		$cast(clone_m_uart_frames,m_uart_frames.clone());
// 		m_wb_uart_ref_model.write_tx_mon(m_uart_frames);
// 	endfunction

// 	uvm_analysis_imp_uart_rx_mon#(uart_frames, wb_uart_scoreboard) 
// 		uart_rx_analysis_imp  = new("uart_rx_analysis_imp",this);


// 	function void write_uart_rx_mon(input uart_frames m_uart_frames);
// 		uart_frames clone_m_uart_frames;
// 		$cast(clone_m_uart_frames,m_uart_frames.clone());
// 		m_wb_uart_ref_model.write_rx_mon(m_uart_frames);
// 		$display("I am in rx_mon");
// 		if(clone_m_uart_frames.data != m_wb_uart_ref_model.get_tx_data())
// 						        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Transmitter FIFO. Expected value = %d, Produced value = %d", m_wb_uart_ref_model.get_tx_data() , clone_m_uart_frames.data))
//                                   	else          
                                        	
// 						        `uvm_info("MATCH", $sformatf("Match between the values of Transmitter FIFO. Expected value = %d, Produced value = %d",m_wb_uart_ref_model.get_tx_data() , clone_m_uart_frames.data),UVM_LOW)
			
// 	endfunction




// 	function new(string name = "wb_uart_scoreboard",uvm_component parent);
// 		super.new(name,parent);
// 	endfunction

	
// 	function void report_phase(uvm_phase phase);
// 		super.report_phase(phase);

// 	endfunction


// endclass:wb_uart_scoreboard

