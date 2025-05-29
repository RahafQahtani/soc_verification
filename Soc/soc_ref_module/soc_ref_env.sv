// class soc_ref_env extends uvm_env;
// `uvm_component_utils(soc_ref_env)

//     function new(string name = "soc_ref_env",uvm_component parent);
//     super.new(name, parent);
//     `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

//     endfunction //new()



// wb_ref_model wb_ref;
 
//   wb_x_spi_module spiref_model1;
//   wb_x_spi_module spiref_model2;
//   wb_x_i2c_ref_model i2cref_model;
//   wb_uart_ref_model  uartref_model;
// soc_scb scb ; 
// string peripheral_name;

//    function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
// scb = soc_scb::type_id::create("scb", this);

// wb_ref = wb_ref_model::type_id::create("wb_ref", this) ; 
// spiref_model1 = wb_x_spi_module::type_id::create("spiref_model1", this);
// spiref_model2 = wb_x_spi_module::type_id::create("spiref_model2", this);
// i2cref_model= wb_x_i2c_ref_model::type_id::create("i2cref_model", this);
// uartref_model=wb_uart_ref_model::type_id::create("uartref_model", this);
// if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", peripheral_name))
//       `uvm_warning("SCOREBOARD", "Could not retrieve PERIPHERAL from config DB");
     
     
// endfunction


//  function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
// //TODO: psuedo code
// if(peripheral_name=="SPI1")
//   scb.spi_ref_model = spiref_model1; 
//   if(peripheral_name=="SPI2")begin 
//     scb.spi_ref_model = spiref_model2; end 

// scb.i2c_ref_model=i2cref_model;
// scb.uart_ref_model=uartref_model;
// //connect wb_ref to scb
// wb_ref.wb2scb_port.connect(scb.wb_in);


// //connect wb_ref to spiref_model1
// wb_ref.wb2spi1ref_port.connect(spiref_model1.wb_in);
// wb_ref.wb2spi2ref_port.connect(spiref_model2.wb_in);

// //i2c to sc 
// wb_ref.wb2i2cref_port.connect(i2cref_model.wb_imp);

// //uart to sc 
// wb_ref.wb2uartref_port.connect(uartref_model.wb_analysis_imp);


// endfunction


// endclass //router_module_env extends uvm_env


class soc_ref_env extends uvm_env;
`uvm_component_utils(soc_ref_env)

    function new(string name = "soc_ref_env",uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

    endfunction //new()



wb_ref_model wb_ref;
 
  wb_x_spi_module spiref_model1;
  wb_x_spi_module spiref_model2;
  wb_x_i2c_ref_model i2cref_model;
  wb_uart_ref_model uartref_model;
  soc_scb scb ; 
string peripheral_name;

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
scb = soc_scb::type_id::create("scb", this);

wb_ref = wb_ref_model::type_id::create("wb_ref", this) ; 
spiref_model1 = wb_x_spi_module::type_id::create("spiref_model1", this);
spiref_model2 = wb_x_spi_module::type_id::create("spiref_model2", this);
i2cref_model= wb_x_i2c_ref_model::type_id::create("i2cref_model", this);
uartref_model=wb_uart_ref_model::type_id::create("uartref_model", this);
if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", peripheral_name))
      `uvm_warning("SCOREBOARD", "Could not retrieve PERIPHERAL from config DB");
     
     
endfunction


 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
 // refrence models to scb 
 //spi 
if(peripheral_name=="SPI1")
  scb.spi_ref_model = spiref_model1; 
  if(peripheral_name=="SPI2")begin 
    scb.spi_ref_model = spiref_model2; end 
//i2c
scb.i2c_ref_model=i2cref_model;
//uart 
scb.uart_ref_model=uartref_model;

//connect wb_ref to scb
wb_ref.wb2scb_port.connect(scb.wb_in);


//connect wb_ref to spiref_model1
wb_ref.wb2spi1ref_port.connect(spiref_model1.wb_in);
wb_ref.wb2spi2ref_port.connect(spiref_model2.wb_in);

//i2c to sc 
wb_ref.wb2i2cref_port.connect(i2cref_model.wb_imp);
 
//uart to sc 
wb_ref.wb2uart1ref_port.connect(uartref_model.wb_analysis_imp);

endfunction


endclass //router_module_env extends uvm_env