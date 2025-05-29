// `include "uvm_macros.svh"
// import uvm_pkg::*;

class soc_tb extends uvm_env;
        `uvm_component_utils(soc_tb)


wb_env wbenv ; 
clock_and_reset_env clk_rst_env ; 
soc_ref_env soc_refenv; 
spi_env spienv1;
spi_env spienv2;
i2c_env i2cenv;
uart_env uartenv;
soc_mcsequencer mcseqr ; 


    function new(string name = "soc_tb",uvm_component parent);
            super.new(name, parent);
           `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
    endfunction //new()

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   uvm_config_int::set(this, "*wbenv*", "num_masters", 1);
    uvm_config_int::set(this, "*wbenv*", "num_slaves", 0);
    uvm_config_int::set(this, "*spienv*", "enable_master", 0);
    uvm_config_int::set(this, "*spienv*", "enable_slave", 1);
     uvm_config_int::set(this,"*i2cenv*", "num_masters", 0);
    uvm_config_int::set(this,"*i2cenv*", "num_slaves", 1);

    uartenv = uart_env::type_id::create("uartenv", this);
    spienv1 = spi_env::type_id::create("spienv1", this);
  spienv2 = spi_env::type_id::create("spienv2", this);
    wbenv = wb_env::type_id::create("wbenv", this);
    clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);
    i2cenv= i2c_env::type_id::create("i2cenv", this);
    soc_refenv = soc_ref_env::type_id::create("soc_refenv", this); 
    mcseqr = soc_mcsequencer::type_id::create("mcseqr", this); 

    endfunction



 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //sequencers connection to mc_seqr
     mcseqr.wb_seqr = wbenv.masters[0].sequencer;  
     mcseqr.spi1_seqr = spienv1.slave_agent.seqr;
     mcseqr.spi2_seqr = spienv2.slave_agent.seqr;
      mcseqr.i2c_seqr = i2cenv.slaves[0].sequencer;
      mcseqr.uart_tx_seqr = uartenv.m_uart_tx_agent.m_uart_tx_sequencer;
    //wb to soc_ref
    wbenv.masters[0].monitor.item_collected_port.connect(soc_refenv.wb_ref.wb_in);
    // TLM connections between spi and Scoreboard
    spienv1.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in1); 
    spienv2.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in2); 
    // TLM connections between i2c and Scoreboard
     i2cenv.slaves[0].monitor.i2c_analysis_port.connect(soc_refenv.scb.i2c_in); 
   // TLM connections between uart and scoreborad 
      uartenv.m_uart_tx_agent.m_uart_tx_monitor.uart_tx_analysis_port.connect(soc_refenv.scb.uart1_tx_in);
      uartenv.m_uart_rx_agent.m_uart_rx_monitor.uart_rx_analysis_port.connect(soc_refenv.scb.uart1_rx_in);
    endfunction


  //--------------------------------------------------------
  //start_of_simulation_phase
  //--------------------------------------------------------
function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
endfunction



endclass
// `include "uvm_macros.svh"
// import uvm_pkg::*;

// class soc_tb extends uvm_env;
//     `uvm_component_utils(soc_tb)

//     // Component handles
//     uart_env uartenv;
//     wb_env wbenv;
//     clock_and_reset_env clk_rst_env;
//     soc_ref_env soc_refenv;
//     spi_env spienv1;
//     spi_env spienv2;
//     soc_mcsequencer mcseqr;

//     function new(string name = "soc_tb", uvm_component parent);
//         super.new(name, parent);
//         `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
//     endfunction

//     //============================================================
//     // Build Phase
//     //============================================================
//     function void build_phase(uvm_phase phase);
//         super.build_phase(phase);

//         // Config settings
//         uvm_config_int::set(this, "*wbenv*", "num_masters", 1);
//         uvm_config_int::set(this, "*wbenv*", "num_slaves", 0);
//         uvm_config_int::set(this, "*spienv*", "enable_master", 0);
//         uvm_config_int::set(this, "*spienv*", "enable_slave", 1);

//         // Create components
//         uartenv     = uart_env::type_id::create("uartenv", this);
//         spienv1     = spi_env::type_id::create("spienv1", this);
//         spienv2     = spi_env::type_id::create("spienv2", this);
//         wbenv       = wb_env::type_id::create("wbenv", this);
//         clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);
//         soc_refenv  = soc_ref_env::type_id::create("soc_refenv", this);
//         mcseqr      = soc_mcsequencer::type_id::create("mcseqr", this);
//     endfunction

//     //============================================================
//     // Connect Phase
//     //============================================================
//     function void connect_phase(uvm_phase phase);
//         super.connect_phase(phase);

//         // Connect sequencers to virtual sequencer
//         mcseqr.wb_seqr      = wbenv.masters[0].sequencer;
//         mcseqr.spi1_seqr    = spienv1.slave_agent.seqr;
//         mcseqr.spi2_seqr    = spienv2.slave_agent.seqr;
//         // mcseqr.uart_tx_seqr = uartenv.uart_tx_agent.m_uart_tx_sequencer;
//         // mcseqr.uart_rx_seqr = uartenv.uart_rx_agent.m_uart_rx_sequencer;

//         // Monitor connections to reference models and scoreboard
//         wbenv.masters[0].monitor.item_collected_port.connect(soc_refenv.wb_ref.wb_in);
//         spienv1.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in1);
//         spienv2.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in2);
//         // uartenv.uart_tx_agent.m_uart_tx_monitor.uart_tx_analysis_port.connect(soc_refenv.scb.uart_tx_analysis_imp);
//         // uartenv.uart_rx_agent.m_uart_rx_monitor.uart_rx_analysis_port.connect(soc_refenv.scb.uart_rx_analysis_imp);
//     endfunction

//     //============================================================
//     // Start of Simulation Phase
//     //============================================================
//     function void start_of_simulation_phase(uvm_phase phase);
//         `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
//     endfunction

// endclass
