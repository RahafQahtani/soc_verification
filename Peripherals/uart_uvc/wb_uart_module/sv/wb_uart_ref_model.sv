class wb_uart_ref_model extends uvm_scoreboard;

//	import wb_pkg::*;
	// import uart_pkg::*;
//..........................................................................................................................//
//                                              Variable/Registers/Queues of wb_mon                                         //
//..........................................................................................................................//
    //Receive FIFO
    logic [7 : 0] Receive_FIFO [$ : 16];
    //Transmit FIFO
    logic [7 : 0] Transmit_FIFO [$ : 17];
    //Buffer to model the transmit buffer
    logic [7 : 0] Transmit_Buffer;
    //Transmit buffer status (transmission completed or not)
    logic Transmit_Buffer_Status = 0;
    //Interrupt Enable Register
    logic [7 : 0] IER;
    //Interrupt Identification register
    logic [7 : 0] IIR;
    //FIFO Control Register
    logic [7 : 0] FCR;
    //Line Control Register
    logic [7 : 0] LCR;
    //Line Status Register
    logic [7 : 0] LSR;
    //Modem Control Register
    logic [7 : 0] MCR;
    //Modem Status Register
    logic [7 : 0] MSR;
    //Divisor latch register (for LSB portion)
    logic [7 : 0] Divisor_Latch_LSB;
    //Divisor latch register (for MSB portion)
    logic [7 : 0] Divisor_Latch_MSB;

    //Vector for saving data of Receive FIFO when there's READ transaction
    logic [7 : 0] Receive_FIFO_vector;

    //Vector for saving data of Receive FIFO for checking the parity error indicator
    logic [7 : 0] Receive_FIFO_vector_Dummy;
    //Queue for saving the parity information (From LCR)
    logic Received_Parity_enable[$ : 16];     
    logic Received_Even_Parity[$ : 16];
    logic Received_Stick_parity[$ : 16];
    logic Received_parity_bit[$ : 16];
    //Dummy variable for storing the parity available in the received data available at the top of the receive FIFO
    logic Dummy_Receive_parity;
    //QUEUE for storing the char len of data received (from LCR)
    logic [3 : 0] Received_char_len[$ : 16];
    //Received_baud_rate for(For LCR)
    logic [31 : 0] Received_baud_rate[$ : 16];
    //Received stop bits (For LCR)
    logic Received_Stop_bits[$ : 16];
    
    //Vector for saving the data of register used for scoreboard comparison
    logic [7 : 0] Register_vector;

    //control variable
    bit top_data_PEI;
    bit top_data_FEI;
    bit top_data_BII;

//..........................................................................................................................//
//                                              Variable/Registers/Queues of tx_mon                                         //
//..........................................................................................................................//
    //Rx FIFO for tx monitor
    logic [7 : 0] rx_data;
    //Queue storing the parity enable bit of rx transaction
    logic rx_enable_parity [$ : 16];
    //Queue storing the even/odd parity information
    logic rx_even_parity [$ : 16];
    //Queue storing the parity bit of each rx transaction 
    logic rx_parity_bit [$ : 16]; 
    //Queue storing the character length of each rx transaction
    logic [3 : 0] rx_char_len [$ : 16];
    //Queue storing the stop bits info
    logic rx_stop_bits [$ : 16];
    //Queue storing the baud rate info
    logic [31 : 0] rx_baud_rate [$ : 16];
    //Queue storing the stick parity info
    logic rx_stick_parity [$ : 16]; 
    //Variable for counting the number of transactions received and how many are read.
    int count_receive = 0;


//..........................................................................................................................//
//                                              Variable/Registers/Queues of rx_mon                                         //
//..........................................................................................................................//
    //Rx FIFO for tx monitor
    logic [7 : 0] tx_data;
    //variable storing the parity enable bit of tx transaction
    logic tx_enable_parity;
    //variable storing the even/odd parity information
    logic tx_even_parity;
    //Dummy variable storing the parity bit of each tx transaction 
    logic tx_parity_bit; 
    //variable storing the actual parity bit of each tx transaction 
    logic tx_parity;
    //variable storing the character length of each tx transaction
    logic [3 : 0] tx_char_len;
    //variable storing the stop bits info
    logic [1 : 0] tx_stop_bits;
    //variable storing the baud rate info
    logic [31 : 0] tx_baud_rate;
    //variable storing the stick parity info
    logic tx_stick_parity; 
    //Variable for counting the number of transactions received and how many are read.
    int count_transmit = 0;
    //Character length variable for loop
    int character_length;
    //Test variable
    bit test_rx;
    bit test_tx;

    //TLM implementation ports
    `uvm_analysis_imp_decl(_wb)
    `uvm_analysis_imp_decl(_tx_mon)     //UART tx monitor
    `uvm_analysis_imp_decl(_rx_mon)     //UART rx monitor

    uvm_analysis_imp_wb #(wb_transaction, wb_uart_ref_model) wb_analysis_imp;
    uvm_analysis_port #(wb_transaction) wb_uart_analysis_imp_sbd;
//    uvm_analysis_imp_tx_mon #(uart_frames, scoreboard) uart_tx_analysis_imp;
//    uvm_analysis_imp_rx_mon #(uart_frames, scoreboard) uart_rx_analysis_imp;

    //Component utility macro
    `uvm_component_utils(wb_uart_ref_model)

    //Class constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        wb_analysis_imp = new("wb_analysis_imp", this);
        wb_uart_analysis_imp_sbd = new("wb_analysis_imp_sbd", this);
//        uart_tx_analysis_imp = new("uart_tx_analysis_imp", this);
  //      uart_rx_analysis_imp = new("uart_rx_analysis_imp", this);
    endfunction : new

    //Write implementation of wb analysis import
    function void write_wb (wb_transaction m_wb_trans);
        
        //Creating the handle to clone it
        wb_transaction clone_m_wb_trans;
        $cast(clone_m_wb_trans, m_wb_trans.clone());


        if(clone_m_wb_trans.reset == 1)
            begin
                IER = 8'b00000000;
                IIR = 8'b11000001;
                FCR = 8'b11000000;
                LCR = 8'b00000011;
                LSR = 8'b01100000;
                MCR = 8'b00000000;
                Divisor_Latch_LSB = 8'd0;
                Divisor_Latch_MSB = 8'd0;
                Transmit_FIFO.delete();
                Receive_FIFO.delete();
                $display("Abid In Reset.");
                Print_Reg();
            end

        else
            begin
                //Checking the transaction type, address and doing the corresponding action
                if(clone_m_wb_trans.trans == WRITE)
                    begin
                        if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*0 && LCR[7] === 0 && (count_transmit >= 0 && count_transmit < 17))
                            begin
                                if(count_transmit < 17)
                                    begin
                                        Transmit_FIFO.push_back(clone_m_wb_trans.data);
                                        count_transmit++;
					$display("Data written in tranmit FIFO = %d",clone_m_wb_trans.data);
                                        //After writing into the transmit FIFO setting value of LSR[5] equal to 0
                                        LSR[5] = 0;
                                        LSR[6] = 0;
                                        //Writing to the transmit buffer
                                        // if(Transmit_Buffer_Status == 0)         //Writing into the buffer only when there is no data in the buffer and this is the check
                                        //     begin
                                        //         Transmit_Buffer = Transmit_FIFO.pop_front();
                                        //         Transmit_Buffer_Status = 1;
                                        //         count_transmit--;
                                        //     end
                                    end
                                else
                                    `uvm_info(get_type_name(), "Trying to enter the data beyond the capacity of the transmit FIFO.", UVM_HIGH)
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*1 && LCR[7] === 0)
                            begin
                                IER[3 : 0] = clone_m_wb_trans.data[3 : 0];
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*2)
                            begin
                                FCR = clone_m_wb_trans.data;
                                //Clearing the Receiver FIFO
                                if(FCR[1] == 1)
                                    begin
                                        Receive_FIFO.delete();
                                        rx_baud_rate.delete();
                                        rx_char_len.delete();
                                        rx_enable_parity.delete();
                                        rx_even_parity.delete();
                                        rx_parity_bit.delete();
                                        rx_stick_parity.delete();
                                        rx_stop_bits.delete();
                                        count_receive = 0;
                                    end
                                //Clearing the Transmitter FIFO
                                if(FCR[2] == 1)
                                    begin
                                        Transmit_FIFO.delete();
                                        count_transmit = 0;
                                    end
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*3)
                            begin
                                LCR = clone_m_wb_trans.data;
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*4)
                            begin
                                MCR [4 : 0] = clone_m_wb_trans.data[4 : 0]; 
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*0 && LCR[7] === 1)
                            begin
                                Divisor_Latch_LSB = clone_m_wb_trans.data;

				$display("Divisor Latch LSB=%d", Divisor_Latch_LSB);
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*1 && LCR[7] === 1)
                            begin
                                Divisor_Latch_MSB = clone_m_wb_trans.data;

				$display("Divisor Latch MSB=%d", Divisor_Latch_MSB);
                            end
                    end 
                //If transaction type is READ
                else if(clone_m_wb_trans.trans == READ)
                    begin
                                        //$display("Outside If  Rx FIFO Read= %h, LCR=%h,count_receive=%d",  clone_m_wb_trans.adr_i,LCR,count_receive );
                        if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*0 && LCR[7] === 0)
                            begin
                                //Enter in this block only when there is some data in the receive FIFO
//                                        $display("Inside If Rx FIFO Read= %h, LCR=%h,count_receive=%d",  clone_m_wb_trans.adr_i,LCR,count_receive );
                                if(count_receive > 0)
                                    begin
                                        //Received value available at the top of the received FIFO
                                        
					Receive_FIFO_vector = Receive_FIFO[0];
                                        $display("Receive FIFO = %d\n",Receive_FIFO_vector);
					count_receive--;    //Decrementing the received counter after reading the value

                                        //Writing the value in LSR register's bit 0 when at least 1 character has been received (Data Ready indicator)
                                        if(count_receive == 0)
                                            LSR[0] = 0;
                                        else
                                            LSR[0] = 1;

                                        //For LSR
                                        Calculate_status();
                                        Receive_FIFO_vector = Receive_FIFO.pop_front();

                                        //Assigning top data read value to know that it's been read and now check for another data located at the top of the FIFO 
                                        top_data_PEI = 0;
                                        top_data_FEI = 0;
                                        top_data_BII = 0;

                                        //Compare the results
                                        if(Receive_FIFO_vector !== clone_m_wb_trans.data)
                                            begin
                                                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Receiver FIFO at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, Receive_FIFO_vector, clone_m_wb_trans.data))
                                            end
                                        else if(Receive_FIFO_vector == clone_m_wb_trans.data)
                                                `uvm_info(get_type_name(), $sformatf("READ Data from Rx FIFO = %d, Data Written from Tx mon of UART = %d", clone_m_wb_trans.data, Receive_FIFO_vector), UVM_HIGH)

                                        //Calling the compare
                                        test_rx = compare_rx_data(clone_m_wb_trans);
                                        
                                        rx_baud_rate.pop_front();
                                        rx_char_len.pop_front();
                                        rx_enable_parity.pop_front();
                                        rx_even_parity.pop_front();
                                        rx_stick_parity.pop_front();
                                        Received_Parity_enable.push_back(LCR[3]);
                                        Received_Even_Parity.pop_front();
                                        Received_Stick_parity.pop_front();
                                        Received_char_len.pop_front();
                                        Received_baud_rate.pop_front();    
                                        Received_Stop_bits.pop_front();
                                     end
                                else
                                    `uvm_info(get_type_name(), "Trying to read the empty receive FIFO.", UVM_LOW)
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*1 && LCR[7] === 0)
                            begin
                              //  Print_Reg();
                                //Compare the results
                                if(IER != clone_m_wb_trans.data)
                                    begin
                                        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Interrupt Enable Register at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, IER, clone_m_wb_trans.data))
                                    end
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*2)
                            begin
                                bit change_value;   //Local variable for changing the value of last bit of IIR in case of THR empty interrupt after reading from it

                                //Writing the value on the basis of interrupt's priority
                                if(IER[2] == 1)
                                    begin
                                        if(LSR[7] == 1)
                                            IIR = 8'b11000110;
                                        else
                                            IIR = 8'b11000001;
                                    end
                                
                                //2nd highest priority
                                else if(IER[0] == 1)    
                                    begin
                                        if(FCR[7 : 6] == 2'b00)
                                            begin
                                                if(count_receive >= 1)
                                                    IIR = 8'b11000100;
                                                else
                                                    IIR = 8'b11000001;
                                            end
                                        else if(FCR[7 : 6] == 2'b01)
                                            begin
                                                if(count_receive >= 4)
                                                    IIR = 8'b11000100;
                                                else
                                                    IIR = 8'b11000001;
                                            end
                                        else if(FCR[7 : 6] == 2'b10)
                                            begin
                                                if(count_receive >= 8)
                                                    IIR = 8'b11000100;
                                                else
                                                    IIR = 8'b11000001;
                                            end
                                        else if(FCR[7 : 6] == 2'b11)
                                            begin
                                                if(count_receive == 16)
                                                    IIR = 8'b11000100;
                                                else
                                                    IIR = 8'b11000001;
                                            end
                                    end

                                //2nd highest priority(Think about it)

                                //3rd highest priority
                                else if(IER[1] == 1)
                                    begin                                
                                        if(LSR[5] == 1)
                                            begin
                                                IIR = 8'b11000010;
                                                change_value = 1;
                                            end
                                        else
                                            IIR = 8'b11000001;
                                    end
                                
                                //No interrupt
                                else    
                                    IIR = 8'b11000001;  //Not sure about it

                                //Now comparing the values
                                if(IIR !== clone_m_wb_trans.data)
                                    begin
                                        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of IIR at address = %d. Expected value = %b, Produced value = %b", clone_m_wb_trans.adr_i, IIR, clone_m_wb_trans.data))
                                        `uvm_error("COUNT RECEIVE", $sformatf("Value of count_receive = %d", count_receive))
                                    end
                                    //For Debugging
                                  //  Print_Reg();
                                //if change_value is 1
                                if(change_value == 1)
                                    IIR = 8'b11000011;
                                
                                change_value = 0; //Will only be 1 when certain interrupt occurs
                                
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*3)
                            begin
                                //For Debug
//                                Print_Reg();
                                //Compare the results                       
                                if(LCR != clone_m_wb_trans.data)
                                    begin
                                        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Line Control Register at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, LCR, clone_m_wb_trans.data))
                                    end
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*5)
                            begin
                                //Checking for overrun condition and setting the bit accordingly
                                if(count_receive >= 16)
                                    begin
                                        LSR[1] = 1;     //Writing 1 to the bit 1 of LSR because Overrun condition has been met
                                    end
                                    else
                                        LSR[1] = 0; //No overrun condition

                                    // Update flags BEFORE decrementing
                                    // LSR[5] = (count_transmit <= 1) ? 1 : 0;  // THR empty if <=1 byte left
                                    // LSR[6] = (count_transmit == 1) ? 1 : 0;  // Fully empty after this pop

                                // //Setting the value of bit 5 of LSR if transmitter FIFO is empty
                                // if(count_transmit == 1)
                                //     begin
                                //         LSR[5] = 1;
                                //     end
                                // else 
                                //     begin
                                //         LSR[5] = 0;
                                //     end  
                                
                                // if(count_transmit == 0)
                                //     LSR[6] = 1;
                                // else
                                //     LSR[6] = 0;

                                //Comparing for output
                                // if(LSR !== clone_m_wb_trans.data)
                                //     begin
                                //         `uvm_error("MISMATCH", $sformatf("Mismatch between the values of LSR Register at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, LSR, clone_m_wb_trans.data))
                                //         $display("Value of count_transmit = %d", count_transmit);
                                //     end
                                // else
                                //     begin
                                //         $display("Value of count transmit = %d", count_transmit);
                                //         $display("Value of Expected value = %d, Produced value = %d", LSR, clone_m_wb_trans.data);
                                //     end
                                //     //For Debug
                                //     Print_Reg();
                                
                                //Setting certain bits = 0 as per specs
                                // LSR[4 : 1] = 0;
                                // LSR[7] = 0;

                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*0 && LCR[7] === 1)
                            begin
                                //For Debug
                               // Print_Reg();                        //compare the results
                                if(Divisor_Latch_LSB != clone_m_wb_trans.data)
                                    begin
                                        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Divisor latch LSB Register at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, Divisor_Latch_LSB, clone_m_wb_trans.data))
                                    end
                            end
                        else if(clone_m_wb_trans.adr_i == `UART_BASE_ADDRESS+`OFFSET*1 && LCR[7] == 1)
                            begin
                                //For Debug
//                                Print_Reg();
                                //compare results
                                if(Divisor_Latch_MSB != clone_m_wb_trans.data)
                                    begin
                                        `uvm_error("MISMATCH", $sformatf("Mismatch between the values of Divisor latch MSB Register at address = %d. Expected value = %d, Produced value = %d", clone_m_wb_trans.adr_i, Divisor_Latch_MSB, clone_m_wb_trans.data))
                                    end
                            end

                    end
            end
	    Print_Reg();
	    wb_uart_analysis_imp_sbd.write(clone_m_wb_trans);
    endfunction : write_wb

    //write implementation of uart tx analysis imp
    function void write_tx_mon(uart_frames m_uart_frames);

        //Handle of uart frame for cloning
        uart_frames clone_m_uart_frames;
        $cast(clone_m_uart_frames, m_uart_frames.clone());
        
        //Writing the receive data into the receive FIFO 
        if(count_receive >= 0 && count_receive < 16)
            begin

                Receive_FIFO.push_back(clone_m_uart_frames.data);
                rx_baud_rate.push_back(clone_m_uart_frames.baud_rate);
                rx_char_len.push_back(clone_m_uart_frames.char_len);
                rx_enable_parity.push_back(clone_m_uart_frames.parity_enable);
                rx_even_parity.push_back(clone_m_uart_frames.even_parity_select);
                rx_parity_bit.push_back(clone_m_uart_frames.parity);
                rx_stick_parity.push_back(clone_m_uart_frames.stick_parity);
                rx_stop_bits.push_back(clone_m_uart_frames.stop_bits);
                count_receive++;
                $display("rx stop bits = %b", clone_m_uart_frames.stop_bits);
                $display("Count Receive = %d", count_receive);
                //Writing the value in LSR register's bit 0 when at least 1 character has been received (DAta Ready indicator)
                LSR[0] = 1; //Writing 1 because count_receive != 0
                LSR[1] = 0; //No overrun condition

                //Saving the value of LCR in a queue for future uses
                Received_Parity_enable.push_back(LCR[3]);
                Received_Even_Parity.push_back(LCR[4]);
                Received_Stick_parity.push_back(LCR[5]);
                Received_char_len.push_back(LCR[1 : 0]);
                Received_baud_rate.push_back((100000000)/(16*({Divisor_Latch_MSB, Divisor_Latch_LSB})));    //Assuming clock = 1 MHz freqeuency
                Received_Stop_bits.push_back(LCR[2]);
                //Earliest Receive data in the queue
                Receive_FIFO_vector_Dummy = Receive_FIFO[0];
            end
            else if(count_receive == 16)
                begin
                    rx_data = clone_m_uart_frames.data;     //Keeping the data in the shift register instead of saving it inside the FIFO because it is full
                    LSR[1] = 1;     //Writing 1 to the bit 1 of LSR because Overrun condition has been met
                end
            
            //For calculating the status bits
            Calculate_status();
            Print_Reg();
    endfunction : write_tx_mon


    //Write implementation of uart rx analysis imp
    function void write_rx_mon(uart_frames m_uart_frames);

        // `uvm_fatal("FATAL", "INSIDE RX MON")
	$display("In Rx Mon Write Function");

        //Only execute when divisor latch is non zero
        if({Divisor_Latch_MSB, Divisor_Latch_LSB} !== 0)
            begin
                //Handle of uart frame for cloning
                uart_frames clone_m_uart_frames;
                $cast(clone_m_uart_frames, m_uart_frames.clone());

	$display("Inside Divisor Latch Check");
                //Writing the receive data into the receive FIFO 
                if(count_transmit > 0 && count_transmit <= 17)
                    begin
                        //Data ttansmitted from the FIFO is taken from the FIFO for comparison
                        tx_data = Transmit_FIFO.pop_front();

			$display("Gettting data from transmit FIFO = %d",tx_data);
                        //Next data written to the receive buffere
                        // Transmit_Buffer_Status = 0;     //Data has been transmitted from the FIFO
                        // if(count_transmit > 0 && count_transmit <= 16)
                        //     begin
                        //         Transmit_Buffer = Transmit_FIFO.pop_front();        //Previous data has been transmitted so write the next data in the buffer
                        //         Transmit_Buffer_Status = 1;
                        //         count_transmit--;
                        //     end
                        
                         count_transmit--;
                                       
                        //Setting the value of bit 5 of LSR if transmitter FIFO is empty

                        // Check flags BEFORE decrementing count_transmit
                    if (count_transmit == 1) begin
                        LSR[5] = 1;  // THR Empty (only 1 byte left in FIFO)
                        LSR[6] = 0;  // Transmitter not fully empty yet
                    end
                    else if (count_transmit == 0) begin
                        LSR[5] = 1;  // THR remains empty (no data in FIFO)
                        LSR[6] = 1;  // Transmitter fully empty (FIFO + Shift Register)
                    end
                    else begin
                        LSR[5] = 0;  // THR not empty (FIFO has >1 byte)
                        LSR[6] = 0;  // Transmitter not empty
                    end

                        // if(count_transmit == 1)
                        //     begin
                        //         LSR[5] = 1;
                        //     end
                        // else 
                        //     begin
                        //         LSR[5] = 0;
                        //     end
                        
                        // if(count_transmit == 0)
                        //     LSR[6] = 1;
                        // else
                        //     LSR[6] = 0;

                        //Taking the decision of char len
                        if(LCR[1 : 0] == 2'b00)
                            tx_char_len = 5;    //char len is 5
                        else if(LCR[1 : 0] == 2'b01)
                            tx_char_len = 6;    //char len is 6
                        else if(LCR[1 : 0] == 2'b10)
                            tx_char_len = 7;    //char len is 7
                        else if(LCR[1 : 0] == 2'b11)
                            tx_char_len = 8;    //char len is 8


                        //checking the bit of parity enable
                        if(LCR[3] == 1)
                            tx_enable_parity = 1;
                        else
                            tx_enable_parity = 0;

                        //Checking the even parity bit
                        if(LCR[4] == 1)
                            tx_even_parity = 1;
                        else
                            tx_even_parity = 0;

                        //checking the bit of stick parity
                        if(LCR[5] == 1)
                            tx_stick_parity = 1;
                        else
                            tx_stick_parity = 0;

                        //Calculating the parity (if enabled)
                        if(tx_enable_parity == 1 && tx_stick_parity == 0)
                            begin
                                //Calculating the parity
                                for(int i = 0; i < tx_char_len; i++)
                                    begin
                                        if(i == 0)
                                            tx_parity_bit = tx_data[i];
                                        else
                                            tx_parity_bit ^= tx_data[i]; 
                                    end
                                //Tranmitting the parity bit on the basis of even or odd selection
                                if(tx_even_parity == 1 && tx_parity_bit == 1)
                                    begin
                                            //# of bits are odd that's why tx_parity_bit = 1 so send parity = 1
                                            tx_parity = 1;   
                                    end
                                else if(tx_even_parity == 1 && tx_parity_bit == 0)
                                    begin
                                            //# of bits are even that's why tx_parity_bit = 0 so send parity = 0
                                            tx_parity = 0;
                                    end

                                //Now checking in case of odd number of 1's
                                if(tx_even_parity == 0 && tx_parity_bit == 0)
                                    begin
                                            //# of bits are even that's why tx_parity_bit = 0 so send parity = 0
                                            tx_parity = 1;
                                    end
                                else if(tx_even_parity == 0 && tx_parity_bit == 1)
                                    begin
                                            //# of bits are odd that's why tx_parity_bit = 1 so send parity = 1
                                            tx_parity = 0;
                                    end

                                //In case of stick parity bit is enabled
                                if(tx_even_parity == 1 && tx_stick_parity == 1)
                                    begin
                                        tx_parity = 0;
                                    end
                                else if(tx_even_parity == 0 && tx_stick_parity == 1)
                                    begin
                                        tx_parity = 1;
                                    end
                            end


                            if(clone_m_uart_frames.data !== tx_data)
                                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of transmitted data. Expected = %b, Actual = %b", tx_data, m_uart_frames.data))
                    
                            test_tx = compare_tx_data(clone_m_uart_frames);
                        
                        
                    end

            end

            Print_Reg();
    endfunction : write_rx_mon

    //compare function for comparing the transmit data
    function bit compare_tx_data(uart_frames m_uart_frames);
        //First compare the data
        if(m_uart_frames.data != tx_data)
            begin
                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of transmitted data. Expected = %b, Actual = %b", tx_data, m_uart_frames.data))
                return 0;
            end

        //Compare the parity bit
        if(m_uart_frames.parity != tx_parity)
            begin
                `uvm_error("MISMATCH", $sformatf("Micmatch between the parity bit of transmitted data. Expected = %d, Actual = %d", tx_parity, m_uart_frames.parity))
                return 0;
            end

        //Compare the stop bits
        if(m_uart_frames.stop_bits != 1)
            begin
                `uvm_error("MISMATCH", $sformatf("Micmatch between the stop bit of transmitted data. Expected = %d, Actual = %d", 1, m_uart_frames.stop_bits))
                return 0;
            end
        
        //return 1 while normal termination
        return 1;

    endfunction : compare_tx_data

    //compare function for comparing the receive data
    function bit compare_rx_data(wb_transaction m_wb_trans);

        //Comparing the data
        if(Receive_FIFO_vector != m_wb_trans.data)
            begin
                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of received data. Expected = %b, Actual = %b", Receive_FIFO_vector, m_wb_trans.data))
                return 0;
            end
        //Comparing the parity
        if(Received_parity_bit[0] != rx_parity_bit[0])
            begin
                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of parity bits. Expected = %b, Actual = %b", Received_parity_bit.pop_front(), rx_parity_bit.pop_front()))
                return 0;
            end
        //comparing the stop bit
        if( rx_stop_bits[0] !== 1)
            begin
                `uvm_error("MISMATCH", $sformatf("Mismatch between the values of stop bits. Expected = 1, Actual = %b", rx_stop_bits.pop_front()))
                return 0;
            end

        //In case of normal termination
        return 1;

    endfunction : compare_rx_data
    
    //Print function for debugging
    function void Print_Reg();
        `uvm_info(get_type_name(), $sformatf("Value of IER = %b", IER), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of IIR = %b", IIR), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of FCR = %b", FCR), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of LCR = %b", LCR), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of LSR = %b", LSR), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of Divisor_Latch_LSB = %b", Divisor_Latch_LSB), UVM_HIGH)
        `uvm_info(get_type_name(), $sformatf("Value of Divisor_Latch_MSB = %b", Divisor_Latch_MSB), UVM_HIGH)
    endfunction : Print_Reg


    //Function to calculate the status register's bit
    function void Calculate_status();

            //Earliest Receive data in the queue
                Receive_FIFO_vector_Dummy = Receive_FIFO[0];

            //For Parity Error Indicator    
            if(top_data_PEI == 0)
                begin
                    $display("Inside PEI");
                    //Set the character length
                    if(Received_char_len[0] == 0)
                        character_length = 5;
                    else if(Received_char_len[0] == 1)
                        character_length = 6;
                    else if(Received_char_len[0] == 2)
                        character_length = 7;
                    else if(Received_char_len[0] == 3)
                        character_length = 8;

                    //Calculating the parity of received data and compare it with the parity of data available at the top of receiver FIFO (Needed for setting the value of bit 2 of LSR)
                    if(Received_Parity_enable[0] == 1)    //Only check when parity is enabled
                        begin
                            for(int i = 0; i < character_length; i++)
                                begin
                                    if(i == 0)  
                                        Dummy_Receive_parity = Receive_FIFO_vector_Dummy[i];
                                    else    
                                        Dummy_Receive_parity = Dummy_Receive_parity ^ Receive_FIFO_vector_Dummy[i];
                                end
                       
                            if(Received_Even_Parity[0] == 1 && Received_Stick_parity[0] == 0)
                                begin
                                    if(Dummy_Receive_parity == 1)
                                        Dummy_Receive_parity = 1;   //Dummy_Receive_parity = 1 when # of 1's in the data are odd. So we are transmitting 1 to keep # of 1's even.
                                    else
                                        Dummy_Receive_parity = 0;    //Dummy_Receive_parity = 0 when # of 1's in the data are even. So we are transmitting 0 to keep # of 1's even.
                                end
                            else if(Received_Even_Parity[0] == 0 && Received_Stick_parity[0] == 0)
                                begin
                                    if(Dummy_Receive_parity == 0)
                                        Dummy_Receive_parity = 1;   //Dummy_Receive_parity = 0 when # of 1's in the data are even. So we are transmitting 1 to keep # of 1's odd.
                                    else
                                        Dummy_Receive_parity = 0;    //Dummy_Receive_parity = 1 when # of 1's in the data are odd. So we are transmitting 1 to keep # of 1's odd.
                                end
                            
                            if(Received_Even_Parity[0] == 1 && Received_Stick_parity[0] == 1)
                                Dummy_Receive_parity = 0;   //Stick the parity bit with the value of 0
                            else if(Received_Even_Parity[0] == 0 && Received_Stick_parity[0] == 1)
                                Dummy_Receive_parity = 1;   //Stick the parity bit with the value of 1.

                            //Writing it inside the if block because we want this to only be checked if parity enable bit is 1
                            //Writing the value in LSR register's bit 2 when Parity Error has occurred in the data available at the top of the FIFO
                            if(rx_parity_bit[0] != Dummy_Receive_parity)
                                LSR[2] = 1;
                            else
                                LSR[2] = 0;

                            top_data_PEI = 1;
                            //Saving the value of parity bit
                            Received_parity_bit.push_back(Dummy_Receive_parity);
                        end
                    //In case parity is disabled
                    else
                        begin
                            Received_parity_bit.push_back(1'bx);    //Pushing the don't care
                            top_data_PEI = 1;
                        end
                end //top_data_PEI end
            
            //For Framing Error Indicator
            if(top_data_FEI == 0)
                begin
                    if(rx_stop_bits[0] == 0)
                        LSR[3] = 1;
                    else
                        LSR[3] = 0;
                    
                    top_data_FEI = 1;   //Will be zero when this transaction will be read in scoreboard
                end //top_data_FEI end

            //For Break Interrupt Indicator
            if(top_data_BII == 0)
                begin
                    if((Receive_FIFO_vector_Dummy == 0) && (rx_parity_bit[0] == 0) && (rx_stop_bits[0] == 0))
                        LSR[4] = 1;
                    else
                        LSR[4] = 0;

                    top_data_BII = 1;
                end //top_data_BII end

            //Setting bit 7 of LSR
            if(LSR[1] == 1 || LSR[2] == 1 || LSR[3] == 1 || LSR[4] == 1)
                LSR[7] = 1;
            else
                LSR[7] = 0;

    endfunction : Calculate_status




    function logic[7:0] get_rx_data();
	    return Receive_FIFO_vector;
    endfunction : get_rx_data



    function logic[7:0] get_tx_data();
	    return tx_data;
    endfunction : get_tx_data

    function logic[7:0] get_Divisor_Latch_MSB();
	    return Divisor_Latch_MSB;
    endfunction : get_Divisor_Latch_MSB

    function logic[7:0] get_Divisor_Latch_LSB();
	    return Divisor_Latch_LSB;
    endfunction : get_Divisor_Latch_LSB

    function logic[7:0] get_LSR();
	    return LSR;
    endfunction : get_LSR
    function logic[7:0] get_IIR();
	    return IIR;
    endfunction : get_IIR
    function logic[7:0] get_IER();
	    return IER;
    endfunction : get_IER



    function logic[7:0] get_LCR();
	    return LCR;
    endfunction : get_LCR


    function logic[7:0] get_FCR();
	    return FCR;
    endfunction : get_FCR


endclass : wb_uart_ref_model
