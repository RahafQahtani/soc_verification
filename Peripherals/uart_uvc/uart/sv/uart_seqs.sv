class uart_base_seq extends uvm_sequence #(uart_frames);

    //Component macro
    `uvm_object_utils(uart_base_seq)

    //Class constructor
    function new(string name = "uart_base_seq");
        super.new(name);
    endfunction : new

    //Raising the objection in pre_body task
    task pre_body();
        uvm_phase phase;

        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif

      if(phase != null)
            phase.raise_objection(this, get_type_name());

    endtask : pre_body

    //Dropping the objection in post_body task
    task post_body();

        uvm_phase phase;

        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else
            phase = starting_phase;
        `endif
        
      if(phase != null)
            phase.drop_objection(this, get_type_name());

    endtask : post_body

endclass : uart_base_seq

//Sequence generating the data with the delay between 15 to 45 baud clocks
class delay_seq1 extends uart_base_seq;

    //Object macro
    `uvm_object_utils(delay_seq1)

    //Class constructor
    function new(string name = "delay_seq1");
        super.new(name);
    endfunction : new

    //body task to create the sequence
    virtual task body();
        repeat(5)
            `uvm_do_with(req, {5 < req.frame_delay <= 45; req.baud_rate == 9600;})
    endtask : body

endclass : delay_seq1

//Sequence with baudrate = 9600, parity_enable = even_parity = 0, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0
class frame_BD_9600_parity_0 extends uart_base_seq;

    int baud_delay;
  
    //Object macro 
    `uvm_object_utils(frame_BD_9600_parity_0)

    //Class constructor
    function new(string name = "frame_BD_9600_parity_0");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        $display("About to send the UART Sequence");    
    	repeat(1)
                `uvm_do_with(req, {req.data == 15;req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
            // `uvm_do_with(req, {req.data == 5; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 6; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 7; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 8; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 9; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 10; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 11; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 12; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 13; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 14; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 15; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 16; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 17; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 18; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
            // `uvm_do_with(req, {req.data == 19; req.baud_rate == 9600; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0;})
    
    endtask : body

endclass : frame_BD_9600_parity_0

//Sequence with baudrate = 4800, parity_enable = even_parity = 0, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0
class frame_BD_4800_parity_0 extends uart_base_seq;
    logic [7 : 0] data = 0;
    int baud_delay;
  
    //Object macro 
    `uvm_object_utils(frame_BD_4800_parity_0)

    //Class constructor
    function new(string name = "frame_BD_4800_parity_0");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
            repeat(16)
                `uvm_do_with(req, {req.baud_rate == 4800; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    
    endtask : body

endclass : frame_BD_4800_parity_0

//Sequence with baudrate = 115200, parity_enable = even_parity = 0, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0, data = random
class frame_BD_115200_parity_0 extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_115200_parity_0)

    //Class constructor
    function new(string name = "frame_BD_115200_parity_0");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
            repeat(4)
                `uvm_do_with(req, {req.baud_rate == 115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    
    endtask : body

endclass : frame_BD_115200_parity_0

//Sequence with baudrate = 115200, parity_enable = even_parity = 0, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0, data = directed
class frame_BD_115200_parity_0_Directed_Data extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_115200_parity_0_Directed_Data)

    //Class constructor
    function new(string name = "frame_BD_115200_parity_0_Directed_Data");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.data == 1; req.baud_rate == 115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 2; req.baud_rate == 115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 3; req.baud_rate == 115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 4; req.baud_rate == 115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    endtask : body

endclass : frame_BD_115200_parity_0_Directed_Data

//Sequence with baudrate = 115200, parity_enable = even_parity = 1, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0, parity type = BAD_PARITY
class frame_BD_115200_parity_1_Even_1_P_Type_BAD extends uart_base_seq;

    int baud_delay;
  
    //Object macro 
    `uvm_object_utils(frame_BD_115200_parity_1_Even_1_P_Type_BAD)

    //Class constructor
    function new(string name = "frame_BD_115200_parity_1_Even_1_P_Type_BAD");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
            repeat(2)
                `uvm_do_with(req, {req.baud_rate == 115200; req.parity_enable == 1; req.even_parity_select == 1; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == BAD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    
    endtask : body

endclass : frame_BD_115200_parity_1_Even_1_P_Type_BAD

//Sequence with baudrate = 4800, parity_enable = even_parity = 1, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0, parity type = BAD_PARITY
class frame_BD_4800_parity_1_Even_1_P_Type_BAD extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_4800_parity_1_Even_1_P_Type_BAD)

    //Class constructor
    function new(string name = "frame_BD_4800_parity_1_Even_1_P_Type_BAD");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
            repeat(2)
                `uvm_do_with(req, {req.baud_rate == 4800; req.parity_enable == 1; req.even_parity_select == 1; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == BAD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    
    endtask : body

endclass : frame_BD_4800_parity_1_Even_1_P_Type_BAD

//Sequence with baudrate = 9600, parity_enable = even_parity = 1, char_len = 8, stop bits = 0, stick parity = 0, frame delay = 0, parity type = BAD_PARITY
class frame_BD_9600_parity_1_Even_1_P_Type_BAD extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_9600_parity_1_Even_1_P_Type_BAD)

    //Class constructor
    function new(string name = "frame_BD_9600_parity_1_Even_1_P_Type_BAD");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
            repeat(2)
                `uvm_do_with(req, {req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 1; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == BAD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    
    endtask : body

endclass : frame_BD_9600_parity_1_Even_1_P_Type_BAD


//Sequence to generate the wrong stop bit value
class frame_BD_115200_Stop_Bit_0 extends uart_base_seq;

    //Object macro 
    `uvm_object_utils(frame_BD_115200_Stop_Bit_0)

    //Class constructor
    function new(string name = "frame_BD_115200_Stop_Bit_0");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        repeat(3)
            `uvm_do_with(req, {req.data == 3; req.baud_rate == 1115200; req.parity_enable == 0; req.even_parity_select == 0; req.char_len == 8; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_0;})
    endtask : body

endclass : frame_BD_115200_Stop_Bit_0

//Sequence with baudrate = 9600, parity_enable = even_parity = 0, char_len = 5, stop bits = 0, stick parity = 0, frame delay = 0, data = directed
class frame_BD_9600_parity_0_Directed_Data_Char_Len_5 extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_9600_parity_0_Directed_Data_Char_Len_5)

    //Class constructor
    function new(string name = "frame_BD_9600_parity_0_Directed_Data_Char_Len_5");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.data == 1; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 5; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 2; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 5; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 3; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 5; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 4; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 5; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    endtask : body

endclass : frame_BD_9600_parity_0_Directed_Data_Char_Len_5

//Sequence with baudrate = 9600, parity_enable = even_parity = 0, char_len = 6, stop bits = 0, stick parity = 0, frame delay = 0, data = directed
class frame_BD_9600_parity_0_Directed_Data_Char_Len_6 extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_9600_parity_0_Directed_Data_Char_Len_6)

    //Class constructor
    function new(string name = "frame_BD_9600_parity_0_Directed_Data_Char_Len_6");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.data == 5; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 6; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 6; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 6; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 7; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 6; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 8; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 6; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    endtask : body

endclass : frame_BD_9600_parity_0_Directed_Data_Char_Len_6

//Sequence with baudrate = 9600, parity_enable = even_parity = 0, char_len = 7, stop bits = 0, stick parity = 0, frame delay = 0, data = directed
class frame_BD_9600_parity_0_Directed_Data_Char_Len_7 extends uart_base_seq;
  
    //Object macro 
    `uvm_object_utils(frame_BD_9600_parity_0_Directed_Data_Char_Len_7)

    //Class constructor
    function new(string name = "frame_BD_9600_parity_0_Directed_Data_Char_Len_7");
        super.new(name);
    endfunction : new

    //Body task
    virtual task body();
        `uvm_do_with(req, {req.data == 9; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 7; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 10; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 7; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 11; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 7; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
        `uvm_do_with(req, {req.data == 12; req.baud_rate == 9600; req.parity_enable == 1; req.even_parity_select == 0; req.char_len == 7; req.stop_bits_ctrl == 0; req.stick_parity == 0;  req.frame_delay == 0; req.parity_type == GOOD_PARITY; req.Stop_Bit == Stop_Bit_1;})
    endtask : body

endclass : frame_BD_9600_parity_0_Directed_Data_Char_Len_7
