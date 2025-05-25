typedef enum bit {BAD_PARITY, GOOD_PARITY} parity_t;
typedef enum bit {Stop_Bit_0, Stop_Bit_1} stop_t;

class uart_frames extends uvm_sequence_item;
  
  //Properties associated with the transaction being sent and received
  rand int baud_rate;
  rand logic [3 : 0] char_len; 
  logic stop_bits;
  rand logic parity_enable;
  rand logic even_parity_select;
  rand logic stick_parity;
  rand logic stop_bits_ctrl;

  //Control knob
  rand parity_t parity_type;
  rand stop_t Stop_Bit;


  //data transmitted or received by the UART
  rand logic [7 : 0] data;
  //Delay between the frams transmitted to the receiver pin
  rand logic [7 : 0] frame_delay;
  //interrupt signal to determine whether it asserts after the desired number of transactions on the receiver FIFO
  logic int_o;
  //Parity bit 
  logic parity;
  
  //Macros for built-in automation
  `uvm_object_utils_begin(uart_frames)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(frame_delay, UVM_ALL_ON)
    `uvm_field_int(int_o, UVM_ALL_ON)
    `uvm_field_int(parity, UVM_ALL_ON)
    `uvm_field_int(baud_rate, UVM_ALL_ON)
    `uvm_field_int(char_len, UVM_ALL_ON)
    `uvm_field_int(stop_bits, UVM_ALL_ON)
    `uvm_field_int(parity_enable, UVM_ALL_ON)
    `uvm_field_int(stick_parity, UVM_ALL_ON)
    `uvm_field_int(even_parity_select, UVM_ALL_ON)
    `uvm_field_int(stop_bits_ctrl, UVM_ALL_ON)
    `uvm_field_enum(parity_t, parity_type, UVM_ALL_ON)
    `uvm_field_enum(stop_t, Stop_Bit, UVM_ALL_ON)
  `uvm_object_utils_end 


  //Class constructor
  function new(string name = "uart_frames");
    super.new(name);
    char_len = 8;
    baud_rate = 9600;
    parity_enable = 0;
    stop_bits_ctrl = 0;
    Stop_Bit = Stop_Bit_1;
  endfunction : new

  //contraints on frame delays
  // constraint frame_transmission {frame_delay > 0;}
  //constraints on character length
  constraint character_length {5 <= char_len; char_len <= 8;}
  //constraint to determine the size of the data being received
  // constraint data_width {
  //   if(parity_enable == 1)
  //       data.size == char_len;
  //   else
  //       data.size == char_len;
  // }
 
endclass : uart_frames
