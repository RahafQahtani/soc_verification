
//Interface
interface uart_if(input clock);
  
    //import the UVM package
    import uvm_pkg::*;

    //include the UVM macros
    `include "uvm_macros.svh"
  
    //import the uart package
  	import uart_pkg::*;

    //Transmit and receive signals 
    logic SRx_I, STx_O; 

    // assign SRx_I = STx_O;
    
    logic [7 : 0] Dummy_Data;
    logic Dummy_Bit;
    bit clk_dummy;
    //Variable for starting the transaction(for sending the start bit)
    int i = 0;

    //Variables to be used in monitor
    logic [7 : 0] frame_delay_m; 
    logic [3 : 0] char_len_m;
    logic parity_m, stop_bits_m, parity_enable_m, stick_parity_m, even_parity_select_m, stop_bits_ctrl_m;
    //logic data_m[];
    int baud_rate_m;
    //For calculating te parity
    int count_1s = 0;

    //Integer variables for storing the delay values
    int baud_rate_delay;
    int baud_rate_delay_half;
    int baud_rate_delay_1_5;
    int baud_rate_delay_1_5_half;
    int baud_rate_delay_2;
    

    //send_to_dut implementation
    task send_to_dut(input uart_frames m_uart_frames);

      baud_rate_delay = (1000000000/m_uart_frames.baud_rate);
      baud_rate_delay_half = baud_rate_delay/2;
      baud_rate_delay_1_5 = 1.5 * baud_rate_delay;
      baud_rate_delay_1_5_half = baud_rate_delay_1_5 / 2;
      baud_rate_delay_2 = 2 * baud_rate_delay;

      //Assigning values for collect_dut task of monitor
      frame_delay_m = m_uart_frames.frame_delay;
      baud_rate_m = m_uart_frames.baud_rate;
      parity_enable_m = m_uart_frames.parity_enable;
      char_len_m = m_uart_frames.char_len;
      stop_bits_m = m_uart_frames.stop_bits;
      stick_parity_m = m_uart_frames.stick_parity;
      stop_bits_ctrl_m = m_uart_frames.stop_bits_ctrl;
      //data_m = new[m_uart_frames.data.size];
      even_parity_select_m = m_uart_frames.even_parity_select;
      Dummy_Data = m_uart_frames.data;

      //To deliver the packet after the specified delay
      if(m_uart_frames.frame_delay > 0)
        begin
          repeat(m_uart_frames.frame_delay)
            begin
              #(baud_rate_delay);
              clk_dummy = ~clk_dummy;
            end
        end

      if(i == 0)
        begin
          //Transmitting the start bit
          SRx_I = 0;
        end

      //Transmitting rest of the data
      for(i = 0; i < m_uart_frames.char_len; i++)
        begin
          #(baud_rate_delay);
          clk_dummy = ~clk_dummy;
          SRx_I = m_uart_frames.data[i];
          Dummy_Bit = SRx_I;
        end



      //Setting value of i back to 0 for future transactions
        i = 0;
      
      //Calculate the number of 1's in the data being transmitted
        for(int a = 0; a < (m_uart_frames.char_len); a++)
          begin
            if(m_uart_frames.data[a] == 1)
              count_1s = count_1s + 1;
          end
        
      //if BAD_PARITY is enabled and we want to transmit the wrong parity
        if(m_uart_frames.parity_type == BAD_PARITY)
          count_1s = count_1s + 1;        //Calculate the wrong parity

        //Value of delay so that SRx_I retains its value (last data bit transmitted) for specified time
        #(baud_rate_delay);
        clk_dummy = ~clk_dummy;

      //Checking for the parity bits and send bits according to configurations
        if(m_uart_frames.parity_enable == 1)
          begin
            //Check for bits[3] & [4] and on the basis of those send the parity bit
              if(m_uart_frames.stick_parity == 1 && m_uart_frames.even_parity_select == 1)
                begin
                  SRx_I = 0;
                  m_uart_frames.parity = SRx_I;
                  m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                end
              else if(m_uart_frames.stick_parity == 1 && m_uart_frames.even_parity_select == 0)
                begin
                  SRx_I = 1;
                  m_uart_frames.parity = SRx_I;
                  m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                end
              //Send the parity bit so that total number of 1's in the data become odd
              else if(m_uart_frames.stick_parity == 0 && m_uart_frames.even_parity_select == 0)
                begin
                  //Check number of 1's transmitted as being odd or even
                  if(!(count_1s % 2))
                    begin
                      SRx_I = 1;
                      m_uart_frames.parity = SRx_I;
                      m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                    end
                  else
                    begin
                      SRx_I = 0;
                      m_uart_frames.parity = SRx_I;
                      m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                    end
                end
              //Send the parity bit so that total number of 1's in the data become even
              else if(m_uart_frames.stick_parity == 0 && m_uart_frames.even_parity_select == 1)
                begin
                  //Check number of 1's being transmitted as even or odd
                  if(!(count_1s % 2))
                    begin
                      SRx_I = 0;
                      m_uart_frames.parity = SRx_I;
                      m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                    end
                  else
                    begin
                      SRx_I = 1;
                      m_uart_frames.parity = SRx_I;
                      m_uart_frames.data[m_uart_frames.char_len] = SRx_I;
                    end
                end

              //After calculating the parity assigning its value for the monitor
              parity_m = m_uart_frames.parity;

            //Value of delay so that parity bit retains its value for the required time period
              #(baud_rate_delay);
              clk_dummy = ~clk_dummy;

          end

      
      //Now transmitting the stop bit
        if(m_uart_frames.stop_bits_ctrl == 1 && m_uart_frames.char_len == 5)
          begin
            //Transmit the 1.5 stop bits = 1 
            if(m_uart_frames.Stop_Bit == Stop_Bit_1)
              SRx_I = 1;
            else if(m_uart_frames.Stop_Bit == Stop_Bit_0)
              SRx_I = 0;
            #(baud_rate_delay_1_5);
            SRx_I = 1;
            clk_dummy = ~clk_dummy;
          end
        else if(m_uart_frames.stop_bits_ctrl == 1 && m_uart_frames.char_len > 5)
          begin
            //Transmit 2 stop bits = 1
            if(m_uart_frames.Stop_Bit == Stop_Bit_1)
              SRx_I = 1;
            else if(m_uart_frames.Stop_Bit == Stop_Bit_0)
              SRx_I = 0;
            #(baud_rate_delay_2);
            SRx_I = 1;
            clk_dummy = ~clk_dummy;
          end
        else if(m_uart_frames.stop_bits_ctrl == 0)
          begin
            //Transmitting the single bit as a stop bit
            if(m_uart_frames.Stop_Bit == Stop_Bit_1)
              SRx_I = 1;
            else if(m_uart_frames.Stop_Bit == Stop_Bit_0)
              SRx_I = 0;            
            #(baud_rate_delay);
            SRx_I = 1;
            clk_dummy = ~clk_dummy;
          end
        //Reset to default value
        count_1s = 0;

    endtask : send_to_dut


    //Implementation of the task collect_from_dut
    task collect_from_dut_tx_mon(output logic [7 : 0] data, logic [7 : 0] frame_delay, logic parity, int baud_rate, logic [3 : 0] char_len,
                                logic stop_bits, parity_enable, stick_parity, even_parity_select, stop_bits_ctrl);
      logic sample;
      bit flip1;
      int a;

      //Initializing data with default value - 0
      data = 0;
            
      //Waiting for start bit      
      @(negedge SRx_I);



      parity_enable = parity_enable_m;
      char_len = char_len_m;
      stop_bits_ctrl = stop_bits_ctrl_m;
      baud_rate = baud_rate_m;
      baud_rate_delay = 1000000000 / baud_rate;
      baud_rate_delay_half = baud_rate_delay / 2;
      baud_rate_delay_1_5 = 1.5 * baud_rate_delay;
      baud_rate_delay_1_5_half = baud_rate_delay_1_5 / 2;
      baud_rate_delay_2 = 2 * baud_rate_delay;


      //Wait for start bit to de-assert
      flip1 = ~flip1;
      //Wait for 1 clock period required to pass the start bit
      #(baud_rate_delay)
      flip1 = ~flip1;

      //Collecting the data sent to the DUT
      for(int j = 0; j < char_len; j++)
        begin
          #(baud_rate_delay_half);
          data[j] = SRx_I;
          #(baud_rate_delay_half);
          a = a + 1;
          flip1 = ~flip1;
        end

      //Check only if parity is enabled
      if(parity_enable == 1)
        begin
          #(baud_rate_delay_half)   
          parity = SRx_I;
          #(baud_rate_delay_half);
        end

    // fork
    //   begin
      //Now collecting the stop bit
      if(stop_bits_ctrl == 1 && char_len == 5)
        begin
          //Delaying or waiting until the 1.5 stop bits = 1 end 
          #(baud_rate_delay_1_5_half)
          stop_bits = SRx_I;
          #(baud_rate_delay_1_5_half);  //Baud_rate delay of 1.5
        end
      else if(stop_bits_ctrl == 1 && char_len > 5)
        begin
          //Delaying or waiting until the 2 stop bits = 1 end 
          #(baud_rate_delay);
          stop_bits = SRx_I;
          #(baud_rate_delay);
        end
      else if(stop_bits_ctrl == 0)
        begin
          //Transmitting the single bit as a stop bit
          #(baud_rate_delay_half);
          sample = SRx_I;
          stop_bits = SRx_I;
          #(baud_rate_delay_half);         
        end
      // end
    // join_none

    endtask : collect_from_dut_tx_mon


    //Implementation of the task collect_from_dut
    task collect_from_dut_rx_mon(input logic [7 : 0] frame_delay, input int baud_rate, input logic [3 : 0] char_len, input logic stop_bits_ctrl, 
                                  parity_enable, stick_parity, even_parity_select, output logic [7 : 0] data, output logic parity, logic stop_bit);

      bit flip;

      baud_rate_delay = (1000000000 / baud_rate);
      baud_rate_delay_half = baud_rate_delay / 2; 
      baud_rate_delay_1_5 = 1.5 * baud_rate_delay;
      baud_rate_delay_2 = 2 * baud_rate_delay;
      baud_rate_delay_1_5_half = baud_rate_delay_1_5 / 2;
      stop_bit = 1'bx;
      data = 0;

      //Wait for start bit to de-assert
      @(negedge STx_O);
      //Wait for 1 clock period required to pass the start bit
      #(baud_rate_delay)
      flip = ~flip;
	$display("Start bit detected baudrate =%d",baud_rate);
      //Collecting the data sent to the DUT
      for(int i = 0; i < 8; i++)
        begin
              //Oversampling at clock 16x faster
              #(baud_rate_delay_half)
                data[i] = STx_O;
                flip = ~flip;
              #(baud_rate_delay_half);
        end

        //Only if parity is enabled
        if(parity_enable == 1)
          begin
            #(baud_rate_delay_half)
            parity = STx_O;
            #(baud_rate_delay_half);
          end

  fork
    begin
      //Now transmitting the stop bit
      if(stop_bits_ctrl == 1 && char_len == 5)
        begin
          //Delaying or waiting until the 1.5 stop bits = 1 end 
          #(baud_rate_delay_1_5_half);
          stop_bit = STx_O;
          #(baud_rate_delay_1_5_half);
        end
      else if(stop_bits_ctrl == 1 && char_len > 5)
        begin
          //Delaying or waiting until the 2 stop bits = 1 end 
          #(baud_rate_delay);
          stop_bit = STx_O;
          #(baud_rate_delay);
        end
      else if(stop_bits_ctrl == 0)
        begin
          //Delaying or waiting until the 1 stop bit = 1 ends 
          #(baud_rate_delay_half);
          stop_bit = STx_O;
          #(baud_rate_delay_half);
        end
    end
	//$display("UART Received Data = %d",data);
  join_none
	$display("UART Received Data = %d",data);
      //Synthetic for checking the scoreboard
      // data = data + 1;
    endtask : collect_from_dut_rx_mon


endinterface : uart_if
