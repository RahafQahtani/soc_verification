class base_test extends uvm_test;

    //SoC testbench
    soc_tb  m_soc_tb;
    uvm_event_pool sbd_2_seq_event_pool;

    mailbox #(wishbone_transaction) sync_mb;  // Global or passed via config_db
    //SPI Configuration agent
    spi_config m_spi_config;
    uart_config cfg;

    string peripheral;


    `uvm_component_utils(base_test)
    string m_tb_name;
    //Class constructor
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         m_spi_config = spi_config::type_id::create("m_spi_config", this);
        m_spi_config.Clock_Phase_Pol = 2'b00;
        // Set the config object into the config DB
        uvm_config_db #(spi_config)::set(this, "*", "spi_config", m_spi_config);


        cfg = uart_config::type_id::create("cfg", this);
        cfg.char_len = 8;
        cfg.baud_rate = 9600;
        cfg.parity_enable = 0;
        cfg.stop_bits_ctrl = 0;
        cfg.Stop_Bit = Stop_Bit_1;
        cfg.even_parity_select = 0;
        cfg.stick_parity = 0;
        uvm_config_db #(uart_config)::set(this, "*", "uart_config", cfg);

        // uvm_objection obj = phase.get_objection();
        // obj.set_drain_time(this, 12000000000/9600);
        // uvm_objection.set_drain_time(this, 12000000000/9600);
        //Default sequence of wishbone master sequencer
        // uvm_config_wrapper::set(this, "m_soc_tb.m_wb_env.m_wb_agent.m_wb_sequencer.run_phase",
        //                         "default_sequence", basic_seq::get_type());
        // //Default sequence for wishbone slave sequencer
        // uvm_config_wrapper::set(this, "m_soc_tb.m_wb_env.m_wb_slave_agent.m_wb_slave_sequencer.run_phase",
        //                         "default_sequence", basic_slave_seq::get_type());
        //Creating the instance of wishbone testbench
    	m_tb_name = "m_soc_tb";
        m_soc_tb = soc_tb ::type_id::create(m_tb_name, this);
        `uvm_info(get_type_name(), "Inside build phase of base_test (test library class)", UVM_HIGH)
	    sync_mb = new();
        sbd_2_seq_event_pool = new("sbd_2_seq_event_pool");       
        uvm_config_db#(uvm_event_pool)::set(null, "*", "sbd_2_seq_event_pool",sbd_2_seq_event_pool);       
	    uvm_config_db#(mailbox#(wishbone_transaction))::set(null, "*", "sync_mb", sync_mb);       
        uvm_config_db#(string)::set(null, "*", "m_tb_name",m_tb_name);       
        
    // Read +PERIPHERAL from command line
        if (!uvm_cmdline_processor::get_inst().get_arg_value("+PERIPHERAL=", peripheral)) begin
            `uvm_fatal("CMDLINE", "Missing +PERIPHERAL=... argument")
        end
        $display("Peripheral = %s", peripheral);
        uvm_config_db#(string)::set(null, "*", "PERIPHERAL",peripheral);
        if(peripheral == "UART1") begin
            uvm_config_db#(int)::set(null, "*", "SOC_UART_BASE_ADDRESS",`SOC_UART1_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_UART_END_ADDRESS",`SOC_UART1_END_ADDRESS);
            // `define SOC_UART_BASE_ADDRESS `SOC_UART1_BASE_ADDRESS
            // `define SOC_UART_END_ADDRESS `SOC_UART1_END_ADDRESS
        end
        else if (peripheral == "UART2") begin
            $display("UART2 Selected");
            uvm_config_db#(int)::set(null, "*", "SOC_UART_BASE_ADDRESS",`SOC_UART2_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_UART_END_ADDRESS",`SOC_UART2_END_ADDRESS);
            
            // `define SOC_UART_BASE_ADDRESS `SOC_UART2_BASE_ADDRESS
            // `define SOC_UART_END_ADDRESS `SOC_UART2_END_ADDRESS
        end
        else if (peripheral == "SPI1") begin
            uvm_config_db#(int)::set(null, "*", "SOC_SPI_BASE_ADDRESS",`SOC_SPI1_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_SPI_END_ADDRESS",`SOC_SPI1_END_ADDRESS);
           
            // `define SOC_SPI_BASE_ADDRESS `SOC_SPI1_BASE_ADDRESS
            // `define SOC_SPI_END_ADDRESS `SOC_SPI1_END_ADDRESS
        end
        else if (peripheral == "SPI2") begin
           $display("SPI2 Peripheral selected");
            uvm_config_db#(int)::set(null, "*", "SOC_SPI_BASE_ADDRESS",`SOC_SPI2_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_SPI_END_ADDRESS",`SOC_SPI2_END_ADDRESS);
           
             // `define SOC_SPI_BASE_ADDRESS `SOC_SPI2_BASE_ADDRESS
            // `define SOC_SPI_END_ADDRESS `SOC_SPI2_END_ADDRESS
        end        
        else if (peripheral == "I2C") begin
           $display("I2C Peripheral selected");
            uvm_config_db#(int)::set(null, "*", "SOC_I2C_BASE_ADDRESS",`SOC_I2C_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_I2C_END_ADDRESS",`SOC_I2C_END_ADDRESS);
           
             // `define SOC_SPI_BASE_ADDRESS `SOC_I2C_BASE_ADDRESS
            // `define SOC_SPI_END_ADDRESS `SOC_I2C_END_ADDRESS
        end  
        else if (peripheral == "GPIO") begin
                    $display("GPIO Peripheral selected");
                    uvm_config_db#(int)::set(null, "*", "SOC_GPIO_BASE_ADDRESS",`SOC_GPIO_BASE_ADDRESS);
                    uvm_config_db#(int)::set(null, "*", "SOC_GPIO_END_ADDRESS",`SOC_GPIO_END_ADDRESS);
                
                    // `define SOC_SPI_BASE_ADDRESS `SOC_I2C_BASE_ADDRESS
                    // `define SOC_SPI_END_ADDRESS `SOC_I2C_END_ADDRESS
        end 
        else if (peripheral == "PTC") begin
            $display("PTC Peripheral selected");
            uvm_config_db#(int)::set(null, "*", "SOC_PTC_BASE_ADDRESS",`SOC_PTC_BASE_ADDRESS);
            uvm_config_db#(int)::set(null, "*", "SOC_PTC_END_ADDRESS",`SOC_PTC_END_ADDRESS);
        
            // `define SOC_SPI_BASE_ADDRESS `SOC_I2C_BASE_ADDRESS
            // `define SOC_SPI_END_ADDRESS `SOC_I2C_END_ADDRESS
        end 
    endfunction : build_phase

    //End of elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
      	 uvm_root uvm_top = uvm_root::get();
         uvm_top.print_topology();
    endfunction : end_of_elaboration_phase
    //End of elaboration phase
    function void start_of_simulation_phase(uvm_phase phase);
	   uvm_objection obj = phase.get_objection();
         obj.set_drain_time(this, 2*1200000000/115200);
     // phase.set_drain_time(this,500ns);
    endfunction : start_of_simulation_phase


endclass : base_test


//simple test for mcsequencer
class mcsequencer_simple_test extends base_test;

    `uvm_component_utils(mcsequencer_simple_test)

    //Class contructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", soc_mcseqs_lib::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
    endfunction: build_phase

endclass : mcsequencer_simple_test

//Test for checking 
class uart_toggle_test extends base_test;
   
    //UVM Event
    uart_config cfg;

    //Component macro
    `uvm_component_utils(uart_toggle_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        cfg = uart_config::type_id::create("cfg", this);
        cfg.char_len = 8;
        cfg.baud_rate = 9600;
        cfg.parity_enable = 0;
        cfg.stop_bits_ctrl = 0;
        cfg.Stop_Bit = Stop_Bit_1;
        cfg.even_parity_select = 0;
        cfg.stick_parity = 0;
        uvm_config_db #(uart_config)::set(this, "*", "uart_config", cfg);


        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", uart_toggle_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","uart_toggle_seq");      
             

	
	endfunction: build_phase
endclass : uart_toggle_test
//Test for checking 
class uart_tx_test extends base_test;
   
    //UVM Event
    uart_config cfg;

    //Component macro
    `uvm_component_utils(uart_tx_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       
       cfg = uart_config::type_id::create("cfg", this);
        cfg.char_len = 8;
        cfg.baud_rate = 9600;
        cfg.parity_enable = 0;
        cfg.stop_bits_ctrl = 0;
        cfg.Stop_Bit = Stop_Bit_1;
        cfg.even_parity_select = 0;
        cfg.stick_parity = 0;
        uvm_config_db #(uart_config)::set(this, "*", "uart_config", cfg);

       
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", uart_tx_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","uart_tx_seq");      
        
	   
   	endfunction: build_phase
endclass : uart_tx_test

class uart_rx_test extends base_test;
   
    //UVM Event
    uart_config cfg;    

    //Component macro
    `uvm_component_utils(uart_rx_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        cfg = uart_config::type_id::create("cfg", this);
        cfg.char_len = 8;
        cfg.baud_rate = 9600;
        cfg.parity_enable = 0;
        cfg.stop_bits_ctrl = 0;
        cfg.Stop_Bit = Stop_Bit_1;
        cfg.even_parity_select = 0;
        cfg.stick_parity = 0;
        uvm_config_db #(uart_config)::set(this, "*", "uart_config", cfg);

        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", uart_rx_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","uart_rx_seq");      
        
        
        
	    $display("UART Rx Test is going to be performed");   
   	endfunction: build_phase
endclass : uart_rx_test

//Test for checking 
class spi_toggle_test extends base_test;
   
    //UVM Event
    

    //Component macro
    `uvm_component_utils(spi_toggle_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        $display("I am in spi toogle test");

        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", spi_toggle_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","spi_toggle_seq");      
	
	endfunction: build_phase
endclass : spi_toggle_test

//Test for checking 
class spi_write_test extends base_test;
   
    //UVM Event
    

    //Component macro
    `uvm_component_utils(spi_write_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", spi_write_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","spi_write_seq");      
       // uvm_config_db#(string)::set(null, "*", "PERIPHERAL","SPI1");      
	
	endfunction: build_phase
endclass : spi_write_test
//Test for checking 
class spi_read_test extends base_test;

    //Component macro
    `uvm_component_utils(spi_read_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", spi_read_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","spi_read_seq");      
     //   uvm_config_db#(string)::set(null, "*", "PERIPHERAL","SPI1");      
	
	endfunction: build_phase
endclass : spi_read_test

class i2c_write_read_test extends base_test;

    //Component macro
    `uvm_component_utils(i2c_write_read_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", i2c_write_read_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","i2c_write_read_seq");      
     //   uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase
endclass : i2c_write_read_test

class i2c_read_write_test extends base_test;

    //Component macro
    `uvm_component_utils(i2c_read_write_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", i2c_read_write_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","i2c_write_read_seq");      
     //   uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : i2c_read_write_test

class i2c_toggle_test extends base_test;

    //Component macro
    `uvm_component_utils(i2c_toggle_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", i2c_toggle_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","i2c_toggle_seq");      
     //   uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : i2c_toggle_test

class gpio_toggle_test extends base_test;

    //Component macro
    `uvm_component_utils(gpio_toggle_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", gpio_toggle_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","gpio_toggle_seq");      
    //    uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : gpio_toggle_test

class gpio_write_test extends base_test;

    //Component macro
    `uvm_component_utils(gpio_write_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", gpio_write_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","gpio_write_seq");      
    //    uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : gpio_write_test


class gpio_read_test extends base_test;

    //Component macro
    `uvm_component_utils(gpio_read_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", gpio_read_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","gpio_read_seq");      
    //    uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : gpio_read_test

class ptc_toggle_test extends base_test;

    //Component macro
    `uvm_component_utils(ptc_toggle_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", ptc_toggle_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","ptc_toggle_seq");      
    //    uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : ptc_toggle_test

class ptc_read_test extends base_test;

    //Component macro
    `uvm_component_utils(ptc_read_test)

    //Class Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        //Default sequence of clock and reset sequencer
        uvm_config_wrapper::set(this, "m_soc_tb.m_clock_and_reset_env.agent.sequencer.run_phase",
                                "default_sequence", clk10_rst5_seq::get_type());
        uvm_config_wrapper::set(this, "m_soc_tb.mcsequencer.run_phase",
                                "default_sequence", ptc_read_seq::get_type());
        uvm_config_db#(string)::set(null, "*", "CUR_TEST_NAME", get_type_name());       
        uvm_config_db#(string)::set(null, "*", "CUR_SEQ_NAME","ptc_read_seq");      
    //    uvm_config_db#(string)::set(null, "*", "PERIPHERAL","I2C");      
	
	endfunction: build_phase

endclass : ptc_read_test

