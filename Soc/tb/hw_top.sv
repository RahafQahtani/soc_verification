module hw_top;

  logic clock,reset;
  logic [31:0]  clock_period;
  logic         run_clock;

// logic cs,sclk ; 

// uart_if in_uart(clock) ; 
wb_if in_wb(clock,reset);
spi_if in_spi1(clock,reset);
spi_if in_spi2(clock,reset);

//***************************************************
//   SOC HW
//***************************************************
    wire O_UART_TX_PAD;
     wire I_UART_RX_PAD;
     wire [23:0] gpio_pads; 


top_rv32i_soc DUT (
  .CLK_PAD       (clock),
  .RESET_N_PAD   (reset),
  .O_UART_TX_PAD (o_uart_tx_pad),
  .I_UART_RX_PAD (i_uart_rx_pad),
  .IO_DATA_PAD   (gpio_pads)
  // .I_TCK_PAD     (i_tck_pad),
  // .I_TMS_PAD     (i_tms_pad),
  // .I_TDI_PAD     (i_tdi_pad),
  // .O_TDO_PAD     (o_tdo_pad)
);








//in_wb signals
  // logic       [31:0]    ADR_O;
  // logic       [7:0]     DAT_I;
  // logic       [7:0]     DAT_O;
  // logic                 WE_O;
  // logic                 STB_O;
  // logic                 ACK_I;
  // logic                 CYC_O;

//rv32i_soc signals 
  // MY_TODO: IO ( wb master signals )
  // the data I in the interface is 32 bits
  logic [31:0] wb_io_adr_i;  // from --> .wb_adr_o
  logic [31:0] wb_io_dat_i;  // from --> .wb_dat_o 
  logic [ 3:0] wb_io_sel_i;  // from --> .wb_sel_o
  logic        wb_io_we_i;  // from --> .wb_we_o
  logic        wb_io_cyc_i;  // from --> .wb_cyc_o
  logic        wb_io_stb_i;  // from --> .wb_stb_o




// always @(*)begin 
//   force DUT.u_rv32i_soc.wb_m2s_spi_adr = in_wb.addr;
//   force DUT.u_rv32i_soc.wb_m2s_spi_dat = in_wb.din;
//   //there is no sel signal in the interface of the wb
//   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
//   force DUT.u_rv32i_soc.wb_m2s_spi_we  = in_wb.we;
//   force DUT.u_rv32i_soc.wb_m2s_spi_stb = in_wb.stb;
//   force DUT.u_rv32i_soc.wb_m2s_spi_cyc = in_wb.cyc;
//    force in_wb.ack = DUT.u_rv32i_soc.wb_s2m_spi_ack;
//    force in_wb.dout =DUT.u_rv32i_soc.spi_rdt_2 ;
 
//  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
//              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
//              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_spi_flash_cyc,
//              DUT.u_rv32i_soc.wb_m2s_io_stb);

// end
 assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
  assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
  assign in_spi1.cs=DUT.u_rv32i_soc.o_flash_cs_n ;
 assign in_spi1.sclk=DUT.u_rv32i_soc.o_flash_sclk;
   assign in_spi2.cs=DUT.u_rv32i_soc.o_cs_n ;
 assign in_spi2.sclk=DUT.u_rv32i_soc.o_sclk;
 assign in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
 assign in_spi2.mosi=DUT.u_rv32i_soc.o_mosi;
`ifndef CORE
always @(*)begin 
  // $display("\n\nCHE\n\n");
  force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
  force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
  //there is no sel signal in the interface of the wb
  force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
  force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
  force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
  force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;
  force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
  force DUT.u_rv32i_soc.i_miso=in_spi2.miso;
//  force sclk=DUT.u_rv32i_soc.o_flash_sclk;
//   force cs=DUT.u_rv32i_soc.o_flash_cs_n;
//     force in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
//     force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
//  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
//              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
//              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_io_cyc,
//              DUT.u_rv32i_soc.wb_m2s_io_stb);


end


`else
    assign in_wb.addr =  DUT.u_rv32i_soc.wb_m2s_io_adr;
   assign in_wb.din =  DUT.u_rv32i_soc.wb_m2s_io_dat;
  //  assign in_wb.sel =  DUT.u_rv32i_soc.wb_m2s_io_sel;
   assign in_wb.we =  DUT.u_rv32i_soc.wb_m2s_io_we;
   assign in_wb.cyc =  DUT.u_rv32i_soc.wb_m2s_io_cyc;
   assign in_wb.stb =  DUT.u_rv32i_soc.wb_m2s_io_stb;
  
`endif
// // assign in_spi.cs    = gpio_pads[19]; // or gpio_pads[20], based on which slave
// assign in_spi1.sclk  = gpio_pads[21];
// assign in_spi1.miso  = gpio_pads[22]; // input from slave
// assign gpio_pads[23] = in_spi1.mosi;  // output to slave

// assign gpio_pads[21] = sclk;
// assign gpio_pads[22] = in_spi1.miso; // input from slave (driven by slave)
// assign in_spi1.mosi  = gpio_pads[23]; // output to slave (driven by DUT)
// assign cs    = gpio_pads[19];
// assign sclk = gpio_pads[21];
// assign in_spi1.miso = gpio_pads[22]; 
// assign gpio_pads[23] = in_spi1.mosi; 
// assign cs = gpio_pads[19]; 



clock_and_reset_if clk_rst_if (
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
);

  clkgen clkgen (
    .clock(clock ),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );



endmodule