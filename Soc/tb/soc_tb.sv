// `include "uvm_macros.svh"
// import uvm_pkg::*;

class soc_tb extends uvm_env;
        `uvm_component_utils(soc_tb)


// uart_env uartenv ; 
wb_env wbenv ; 
clock_and_reset_env clk_rst_env ; 
soc_ref_env soc_refenv; 
spi_env spienv1;
spi_env spienv2;
soc_mcsequencer mcseqr ; 
  // spi_module spiref;





    function new(string name = "soc_tb",uvm_component parent);
            super.new(name, parent);
           `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
    endfunction //new()

mailbox #(int) comp_mbox;
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   uvm_config_int::set(this, "*wbenv*", "num_masters", 1);
    uvm_config_int::set(this, "*wbenv*", "num_slaves", 0);
    uvm_config_int::set(this, "*spienv*", "enable_master", 0);
    uvm_config_int::set(this, "*spienv*", "enable_slave", 1);

    // uartenv = uart_env::type_id::create("uartenv", this);
    spienv1 = spi_env::type_id::create("spienv1", this);
  spienv2 = spi_env::type_id::create("spienv2", this);
    wbenv = wb_env::type_id::create("wbenv", this);
    clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);
    soc_refenv = soc_ref_env::type_id::create("soc_refenv", this); 
    mcseqr = soc_mcsequencer::type_id::create("mcseqr", this); 


comp_mbox = new;
uvm_config_db#(mailbox#(int))::set(null, "*", "comp_mbox", comp_mbox);



    endfunction

// mailbox#(int) test_mbox;


 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //sequencers connection to mc_seqr
     mcseqr.wb_seqr = wbenv.masters[0].sequencer;  
     mcseqr.spi1_seqr = spienv1.slave_agent.seqr;
     mcseqr.spi2_seqr = spienv2.slave_agent.seqr;

    //wb to soc_ref
    wbenv.masters[0].monitor.item_collected_port.connect(soc_refenv.wb_ref.wb_in);
    // TLM connections between spi and Scoreboard
    spienv1.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in1); 
    spienv2.slave_agent.mon.spi_out.connect(soc_refenv.scb.spi_in2); 
   // TLM connections between Refrence model and scoreborad 
    // soc_refenv.sref_model.ref_analysis_port.connect(soc_refenv.scb.ref_in);

    endfunction


  //--------------------------------------------------------
  //start_of_simulation_phase
  //--------------------------------------------------------
function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
endfunction



endclass