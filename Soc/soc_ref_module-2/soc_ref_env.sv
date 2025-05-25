class soc_ref_env extends uvm_env;
`uvm_component_utils(soc_ref_env)

    function new(string name = "soc_ref_env",uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

    endfunction //new()



wb_ref_model wb_ref;
 
  wb_x_spi_module spiref_model1;
  wb_x_spi_module spiref_model2;
soc_scb scb ; 
string peripheral_name;

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
scb = soc_scb::type_id::create("scb", this);

wb_ref = wb_ref_model::type_id::create("wb_ref", this) ; 
spiref_model1 = wb_x_spi_module::type_id::create("spiref_model1", this);
spiref_model2 = wb_x_spi_module::type_id::create("spiref_model2", this);
if (!uvm_config_db#(string)::get(this, "", "PERIPHERAL", peripheral_name))
      `uvm_warning("SCOREBOARD", "Could not retrieve PERIPHERAL from config DB");
     
     
endfunction


 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
//TODO: psuedo code
if(peripheral_name=="SPI1")
  scb.spi_ref_model = spiref_model1; 
  if(peripheral_name=="SPI2")begin 
    scb.spi_ref_model = spiref_model2; end 

//connect wb_ref to scb
wb_ref.wb2scb_port.connect(scb.wb_in);


//connect wb_ref to spiref_model1
wb_ref.wb2spi1ref_port.connect(spiref_model1.wb_in);
wb_ref.wb2spi2ref_port.connect(spiref_model2.wb_in);




endfunction


endclass //router_module_env extends uvm_env