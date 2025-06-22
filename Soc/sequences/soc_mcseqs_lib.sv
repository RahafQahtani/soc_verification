class soc_mcseqs_lib extends uvm_sequence;

    int SOC_UART_BASE_ADDRESS;


    `uvm_object_utils(soc_mcseqs_lib)
    `uvm_declare_p_sequencer(soc_mcsequencer)

    //Class constructor
    function new(string name = "soc_mcseqs_lib");
        super.new(name);
    endfunction : new

    //Raising objection in pre body task
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask : pre_body

    //Dropping objection in post body task
    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
        // in UVM1.2, get starting phase from method
        phase = get_starting_phase();
        `else
        phase = starting_phase;
        `endif
        if (phase != null) begin
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask : post_body


endclass : soc_mcseqs_lib

//Sequence to test transmitted data = data in transmit FIFO
class uart_toggle_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(uart_toggle_seq)
    //Class Constructor 
    function new(string name = "uart_toggle_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();

        int value;

        $display("Running uart toggle sequence");
        p_sequencer.set_sub_seq_name("uart_toggle_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : uart_toggle_seq 



//Sequence to test transmitted data = data in transmit FIFO
class uart_tx_seq extends soc_mcseqs_lib;
     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(uart_tx_seq)

    //Class Constructor 
    function new(string name = "uart_tx_seq");
        super.new(name);
	trans = new();

    endfunction : new

    //Body task
    virtual task body();

    	int value;
		
        p_sequencer.set_sub_seq_name("uart_tx_seq");
    
        $display("UART Tx Test Initiated");
        
        if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");


        for (int i =0; i<1;i++)
        begin
            sbd_2_seq_sync_mbx.get(value);		
            value++;
        end
            
        $display("Trigger received from Scoreboard Mailbox");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
 
    endtask : body


endclass : uart_tx_seq 


//Sequence to test transmitted data = data in transmit FIFO
class uart_rx_seq extends soc_mcseqs_lib;
     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(uart_rx_seq)
    frame_BD_9600_parity_0 uart_frame_9600_p_0;
    string peripheral;
    //Class Constructor 
    function new(string name = "uart_rx_seq");
        super.new(name);
	trans = new();

    endfunction : new

    //Body task
    virtual task body();

    	int value=0;
	
        if (!uvm_config_db#(string)::get(p_sequencer, "", "PERIPHERAL", peripheral))
                `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");

        if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");

        $display("I am UART Rx Seq");
        p_sequencer.set_sub_seq_name("uart_rx_seq");


        if(peripheral == "UART1")
                `uvm_do_on(uart_frame_9600_p_0, p_sequencer.m_uart_tx_sequencer)
        else if(peripheral == "UART2")
                `uvm_do_on(uart_frame_9600_p_0, p_sequencer.m_uart2_tx_sequencer)
      
        for (int i =0; i<1;i++)
        begin
                sbd_2_seq_sync_mbx.get(value);		
            value++;
        end

        $display("Trigger received from Scoreboard Mailbox");


        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        $display("Waiting for mailbox data from the wb mon");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
 

    endtask : body


endclass : uart_rx_seq 

//Sequence to test transmitted data = data in transmit FIFO
class spi_toggle_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(spi_toggle_seq)

    //Class Constructor 
    function new(string name = "spi_toggle_seq");
    
        super.new(name);
	trans = new();
    endfunction : new

    //Body task
    virtual task body();

    $display("I am in SPI2 toggle sequence");
	p_sequencer.set_sub_seq_name("spi_toggle_seq");

	if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
			  `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
	sync_mb.get(trans);
	$display("printing sync transaction");
	trans.print();
 

    endtask : body


endclass : spi_toggle_seq 




//Sequence to test transmitted data = data in transmit FIFO
class spi_write_seq extends soc_mcseqs_lib;
     mailbox #(int) sbd_2_seq_sync_mbx;
     mailbox #(wishbone_transaction) sync_mb;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(spi_write_seq)

    SPI_Dummy_Data_For_MISO SPI_Dummy_Data_Seq_For_MISO;
    //Class Constructor 
    function new(string name = "spi_write_seq");
        super.new(name);
	trans = new();

    endfunction : new

    //Body task
    virtual task body();

    	int ret;
	logic val;
	int value;
    string peripheral;
	
	if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
			  `uvm_error("CONFIGDB", "Scoreboard to Seq event not found in config DB");



	if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
			  `uvm_error("CONFIGDB", "Scoreboard to Seq event not found in config DB");

    if (!uvm_config_db#(string)::get(p_sequencer, "", "PERIPHERAL", peripheral))
			  `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");


	$display("I am in WRITE SEQUENCE, About to write it now Peripheral =%s", peripheral);
	p_sequencer.set_sub_seq_name("spi_write_seq");
        repeat(3) begin

            if(peripheral == "SPI1")
                `uvm_do_on(SPI_Dummy_Data_Seq_For_MISO, p_sequencer.m_spi_sequencer) 
            else if(peripheral == "SPI2")
            begin
                    $display("Running Dummy Sequence on SPI 2");
                    `uvm_do_on(SPI_Dummy_Data_Seq_For_MISO, p_sequencer.m_spi2_sequencer) 
            end
        end
	
	$display("I am in WRITE SEQUENCE, Waiting for Ack Now");
	for(int i = 0; i < 6; i++)
	begin
		       sbd_2_seq_sync_mbx.get(value);
		       value++;
	end
		
		

	if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
			  `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
	sync_mb.get(trans);
	$display("printing sync transaction");
	trans.print();
 

    endtask : body


endclass : spi_write_seq 


//Sequence to test transmitted data = data in transmit FIFO
class spi_read_seq extends soc_mcseqs_lib;
     mailbox #(int) sbd_2_seq_sync_mbx;
     mailbox #(wishbone_transaction) sync_mb;
     wishbone_transaction trans;
    //Object macro
    `uvm_object_utils(spi_read_seq)


    SPI_Directed_Data_For_MISO SPI_Directed_Data_Seq_For_MISO;
    //Class Constructor 
    function new(string name = "spi_read_seq");
        super.new(name);
	trans = new();

    endfunction : new

    //Body task
    virtual task body();

    	int ret;
	logic val;
	int value;
    string peripheral;

	if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
			  `uvm_error("CONFIGDB", "Scoreboard to Seq event not found in config DB");

    if (!uvm_config_db#(string)::get(p_sequencer, "", "PERIPHERAL", peripheral))
			  `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");


	p_sequencer.set_sub_seq_name("spi_read_seq");


    if(peripheral == "SPI1")
         `uvm_do_on(SPI_Directed_Data_Seq_For_MISO, p_sequencer.m_spi_sequencer)
    else if(peripheral =="SPI2")
        `uvm_do_on(SPI_Directed_Data_Seq_For_MISO, p_sequencer.m_spi2_sequencer)


	for(int i = 0; i < 8; i++)
	begin
		       sbd_2_seq_sync_mbx.get(value);
		       value++;
	end
		
		

	if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
			  `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
	sync_mb.get(trans);
	$display("printing sync transaction");
	trans.print();
 

    endtask : body


endclass : spi_read_seq 



class i2c_write_read_seq extends soc_mcseqs_lib;

     mailbox #(int) sbd_2_seq_sync_mbx;
     mailbox #(wishbone_transaction) sync_mb;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(i2c_write_read_seq)
    i2c_basic_seq I2C_basic_Seq;

    //Class Constructor 
    function new(string name = "i2c_write_read_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
    	int ret;
        logic val;
        int value;
        string peripheral;

        if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
                `uvm_error("CONFIGDB", "Scoreboard to Seq event not found in config DB");

        if (!uvm_config_db#(string)::get(p_sequencer, "", "PERIPHERAL", peripheral))
                `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");


        $display("I am in WRITE READ SEQUENCE of =%s", peripheral);
        p_sequencer.set_sub_seq_name("i2c_write_seq");
        if(peripheral == "I2C")
            `uvm_do_on(I2C_basic_Seq, p_sequencer.m_i2c_sequencer) 
    
        
        for(int i = 0; i < 4; i++)
            begin
                sbd_2_seq_sync_mbx.get(value);
                value++;
            end
            
        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();

    endtask : body


endclass : i2c_write_read_seq 

class i2c_read_write_seq extends soc_mcseqs_lib;

     mailbox #(int) sbd_2_seq_sync_mbx;
     mailbox #(wishbone_transaction) sync_mb;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(i2c_read_write_seq)
    i2c_basic_seq I2C_basic_Seq;

    //Class Constructor 
    function new(string name = "i2c_read_write_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
    	int ret;
        logic val;
        int value;
        string peripheral;

        if (!uvm_config_db#(mailbox#(int))::get(p_sequencer, "", "sbd_2_seq_sync_mbx", sbd_2_seq_sync_mbx))
                `uvm_error("CONFIGDB", "Scoreboard to Seq event not found in config DB");

        if (!uvm_config_db#(string)::get(p_sequencer, "", "PERIPHERAL", peripheral))
                `uvm_error("CONFIGDB", "Peripheral Name not found in config DB");


        $display("I am in WRITE READ SEQUENCE of =%s", peripheral);
        p_sequencer.set_sub_seq_name("i2c_write_seq");
        if(peripheral == "I2C")
            `uvm_do_on(I2C_basic_Seq, p_sequencer.m_i2c_sequencer) 
    
        
        for(int i = 0; i < 4; i++)
            begin
                sbd_2_seq_sync_mbx.get(value);
                value++;
            end
            
        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();

    endtask : body


endclass : i2c_read_write_seq 

class i2c_toggle_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(i2c_toggle_seq)

    //Class Constructor 
    function new(string name = "i2c_toggle_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running i2c toggle sequence");
        p_sequencer.set_sub_seq_name("i2c_toggle_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : i2c_toggle_seq 

class gpio_toggle_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(gpio_toggle_seq)

    //Class Constructor 
    function new(string name = "gpio_toggle_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running gpio toggle sequence");
        p_sequencer.set_sub_seq_name("gpio_toggle_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : gpio_toggle_seq 

class gpio_write_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;
     uvm_event uvm_2_core_sync_event;

    //Object macro
    `uvm_object_utils(gpio_write_seq)

    //Class Constructor 
    function new(string name = "gpio_write_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running gpio write sequence");
        p_sequencer.set_sub_seq_name("gpio_write_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : gpio_write_seq 

class gpio_read_seq extends soc_mcseqs_lib;

 mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(gpio_read_seq)
    Random_GPIO_Data GPIO_Random_Seq;

    //Class Constructor 
    function new(string name = "gpio_read_seq");
        super.new(name);
	    trans = new();
        // core_2_uvm_sync_mb = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running gpio write sequence");
        p_sequencer.set_sub_seq_name("gpio_read_seq");
        // Get UVM event handle
        if (!uvm_config_db#(mailbox # (int))::get(p_sequencer, "", "uvm_2_core_sync_mb", uvm_2_core_sync_mb))
            `uvm_fatal("CONFIGDB", "Mailbox not found in config DB")
        if (!uvm_config_db#(mailbox #(int))::get(p_sequencer, "", "core_2_uvm_sync_mb", core_2_uvm_sync_mb))
            `uvm_fatal("CONFIGDB", "Mailbox not found in config DB")
        // Wait for core to trigger synchronization
        core_2_uvm_sync_mb.get(value);
        $display("Waiting for uvm event to trigger");
        `uvm_do_on(GPIO_Random_Seq, p_sequencer.m_gpio_pad_sequencer) 
        $display("uvm event triggerred");
        uvm_2_core_sync_mb.put(1);


        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : gpio_read_seq

class ptc_toggle_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(ptc_toggle_seq)

    //Class Constructor 
    function new(string name = "ptc_toggle_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running ptc toggle sequence");
        p_sequencer.set_sub_seq_name("ptc_toggle_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : ptc_toggle_seq 

class ptc_read_seq extends soc_mcseqs_lib;

     mailbox #(wishbone_transaction) sync_mb;
     mailbox #(int) sbd_2_seq_sync_mbx;
     wishbone_transaction trans;

    //Object macro
    `uvm_object_utils(ptc_read_seq)

    //Class Constructor 
    function new(string name = "ptc_read_seq");
        super.new(name);
	    trans = new();
    endfunction : new

    //Body task
    virtual task body();
        int value;
        $display("Running ptc toggle sequence");
        p_sequencer.set_sub_seq_name("ptc_read_seq");

        if (!uvm_config_db#(mailbox#(wishbone_transaction))::get(p_sequencer, "", "sync_mb", sync_mb))
                `uvm_error("CONFIGDB", "Unable to find mailbox in config DB");
        sync_mb.get(trans);
        $display("printing sync transaction");
        trans.print();
    endtask : body


endclass : ptc_read_seq 
