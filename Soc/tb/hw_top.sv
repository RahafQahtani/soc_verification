// // // module hw_top;

// // //   logic clock,~reset;
// // //   logic [31:0]  clock_period;
// // //   logic         run_clock;

// // // // logic cs,sclk ; 

// // // // uart_if in_uart(clock) ; 
// // // wb_if in_wb(clock,~reset);
// // // spi_if in_spi1(clock,~reset);
// // // spi_if in_spi2(clock,~reset);

// // // //***************************************************
// // // //   SOC HW
// // // //***************************************************
// // //     wire O_UART_TX_PAD;
// // //      wire I_UART_RX_PAD;
// // //      wire [23:0] gpio_pads; 


// // // top_rv32i_soc DUT (
// // //   .CLK_PAD       (clock),
// // //   .RESET_N_PAD   (~reset),
// // //   .O_UART_TX_PAD (o_uart_tx_pad),
// // //   .I_UART_RX_PAD (i_uart_rx_pad),
// // //   .IO_DATA_PAD   (gpio_pads)
// // //   // .I_TCK_PAD     (i_tck_pad),
// // //   // .I_TMS_PAD     (i_tms_pad),
// // //   // .I_TDI_PAD     (i_tdi_pad),
// // //   // .O_TDO_PAD     (o_tdo_pad)
// // // );








// // // //in_wb signals
// // //   // logic       [31:0]    ADR_O;
// // //   // logic       [7:0]     DAT_I;
// // //   // logic       [7:0]     DAT_O;
// // //   // logic                 WE_O;
// // //   // logic                 STB_O;
// // //   // logic                 ACK_I;
// // //   // logic                 CYC_O;

// // // //rv32i_soc signals 
// // //   // MY_TODO: IO ( wb master signals )
// // //   // the data I in the interface is 32 bits
// // //   logic [31:0] wb_io_adr_i;  // from --> .wb_adr_o
// // //   logic [31:0] wb_io_dat_i;  // from --> .wb_dat_o 
// // //   logic [ 3:0] wb_io_sel_i;  // from --> .wb_sel_o
// // //   logic        wb_io_we_i;  // from --> .wb_we_o
// // //   logic        wb_io_cyc_i;  // from --> .wb_cyc_o
// // //   logic        wb_io_stb_i;  // from --> .wb_stb_o




// // // // always @(*)begin 
// // // //   force DUT.u_rv32i_soc.wb_m2s_spi_adr = in_wb.addr;
// // // //   force DUT.u_rv32i_soc.wb_m2s_spi_dat = in_wb.din;
// // // //   //there is no sel signal in the interface of the wb
// // // //   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
// // // //   force DUT.u_rv32i_soc.wb_m2s_spi_we  = in_wb.we;
// // // //   force DUT.u_rv32i_soc.wb_m2s_spi_stb = in_wb.stb;
// // // //   force DUT.u_rv32i_soc.wb_m2s_spi_cyc = in_wb.cyc;
// // // //    force in_wb.ack = DUT.u_rv32i_soc.wb_s2m_spi_ack;
// // // //    force in_wb.dout =DUT.u_rv32i_soc.spi_rdt_2 ;
 
// // // //  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
// // // //              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
// // // //              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_spi_flash_cyc,
// // // //              DUT.u_rv32i_soc.wb_m2s_io_stb);

// // // // end
// // //  assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
// // //   assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
// // // //   assign in_spi1.cs=DUT.u_rv32i_soc.o_flash_cs_n ;
// // // //  assign in_spi1.sclk=DUT.u_rv32i_soc.o_flash_sclk;
// // //    assign in_spi2.cs=DUT.u_rv32i_soc.o_cs_n ;
// // //  assign in_spi2.sclk=DUT.u_rv32i_soc.o_sclk;
// // // //  assign in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
// // //  assign in_spi2.mosi=DUT.u_rv32i_soc.o_mosi;
// // // // `ifdef SOC
// // // always @(*)begin 
// // //   force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
// // //   force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
// // //   //there is no sel signal in the interface of the wb
// // //   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
// // //   force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
// // //   force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
// // //   force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;
// // //   // force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// // //   force DUT.u_rv32i_soc.i_miso=in_spi2.miso;
// // // //  force sclk=DUT.u_rv32i_soc.o_flash_sclk;
// // // //   force cs=DUT.u_rv32i_soc.o_flash_cs_n;
// // // //     force in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
// // // //     force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// // // //  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
// // // //              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
// // // //              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_io_cyc,
// // // //              DUT.u_rv32i_soc.wb`ifdef PD_BUILD_m2s_io_stb);


// // // end
// // //   assign in_spi1.cs=gpio_pads[11] ;
// // //  assign in_spi1.sclk=gpio_pads[10];
// // // assign in_spi1.mosi=gpio_pads[8];
// // // assign gpio_pads[9]=in_spi1.miso;
// // // // `else
// // // //     assign in_wb.addr =  DUT.u_rv32i_soc.wb_m2s_io_adr;
// // // //    assign in_wb.din =  DUT.u_rv32i_soc.wb_m2s_io_dat;
// // // //   //  assign in_wb.sel =  DUT.u_rv32i_soc.wb_m2s_io_sel;
// // // //    assign in_wb.we =  DUT.u_rv32i_soc.wb_m2s_io_we;
// // // //    assign in_wb.cyc =  DUT.u_rv32i_soc.wb_m2s_io_cyc;
// // // //    assign in_wb.stb =  DUT.u_rv32i_soc.wb_m2s_io_stb;
  
// // // // `endif
// // // // // assign in_spi.cs    = gpio_pads[19]; // or gpio_pads[20], based on which slave
// // // // assign in_spi1.sclk  = gpio_pads[21];
// // // // assign in_spi1.miso  = gpio_pads[22]; // input from slave
// // // // assign gpio_pads[23] = in_spi1.mosi;  // output to slave

// // // // assign gpio_pads[21] = sclk;
// // // // assign gpio_pads[22] = in_spi1.miso; // input from slave (driven by slave)
// // // // assign in_spi1.mosi  = gpio_pads[23]; // output to slave (driven by DUT)
// // // // assign cs    = gpio_pads[19];
// // // // assign sclk = gpio_pads[21];
// // // // assign in_spi1.miso = gpio_pads[22]; 
// // // // assign gpio_pads[23] = in_spi1.mosi; 
// // // // assign cs = gpio_pads[19]; 



// // // clock_and_reset_if clk_rst_if (
// // //     .clock(clock),
// // //     .~reset(~reset),
// // //     .run_clock(run_clock),
// // //     .clock_period(clock_period)
// // // );

// // //   clkgen clkgen (
// // //     .clock(clock ),
// // //     .run_clock(run_clock),
// // //     .clock_period(clock_period)
// // //   );



// // // endmodule
// // module hw_top;

// //    logic [31:0]  clock_period;
// //   logic         run_clock;
// //   logic         clock;
// //   logic         ~reset;
// //   logic         STx_O;

// //     logic o_flash_sCLK_PAD;
// //     logic o_flash_cs_n;
// //     logic o_flash_mosi;
// //     logic i_flash_miso;
// //     logic o_uart_tx;
// //     logic i_uart_rx;
// //     logic pwm_pad_o;

// //     logic tck_i;
// //     logic tdi_i;
// //     logic tms_i;
// //     logic tdo_o;

// //     parameter DMEM_DEPTH = 2048;
// //     parameter IMEM_DEPTH = 16384;
// //     parameter NO_OF_GPIO_PINS = 24;

// //     logic CLK_PAD;  // external clock pad
// //     logic RESET_N_PAD;          // external ~reset (active low)
// //     logic O_FLASH_SCLK_PAD;     // external SPI flash serial clock
// //     logic O_FLASH_CS_N_PAD;     // external SPI flash chip‐select (active low)
// //     logic O_FLASH_MOSI_PAD;     // external SPI flash MOSI
// //     logic I_FLASH_MISO_PAD;     // external SPI flash MISO
// //     logic O_UART_TX_PAD;        // external UART TX
// //     wire I_UART_RX_PAD;       // external UART RX
// //     wire [31:0] IO_DATA_PAD;  // external GPIO pads
// //     logic O_PWM_PAD;
// // // Power ports
// //     logic  VDD_LEFT;                // Power
// //     logic  VDD_RIGHT;                // Ground
// //     logic  VDD_TOP;                // Power
// //     logic  VDD_BOTTOM;                // Ground
// //     logic  VSS_LEFT;                // Power
// //     logic  VSS_RIGHT;                // Ground
// //     logic VSS_TOP;                // Power
// //     logic  VSS_BOTTOM;                // Ground
// //     logic VDDPST_LEFT;             // Power
// //     logic VDDPST_RIGHT;            // Ground
// //     logic VDDPST_TOP;              // Power
// //     logic VDDPST_BOTTOM;           // Ground
// //     logic VSSPST_LEFT;             // Ground
// //     logic VSSPST_RIGHT;            // Power
// //     logic VSSPST_TOP;              // Ground
// //     logic VSSPST_BOTTOM;           // Power

// // //JTAG pad signals
// //     logic I_TCK_PAD; // external JTAG TCK
// //     logic I_TMS_PAD; // external JTAG TMS
// //     logic I_TDI_PAD; // external JTAG TDI
// //     logic O_TDO_PAD; // external JTAG TDO

// //     logic VDD ;
// //     logic VSS ;

// //     assign VDD = 1;
// //     assign VSS = 0;




// //     assign CLK_PAD = clock;
// //     assign RESET_N_PAD = ~reset;

// // // logic cs,sclk ; 

// // // uart_if in_uart(clock) ; 
// // wb_if in_wb(clock,~reset);
// // spi_if in_spi1(clock,~reset);
// // spi_if in_spi2(clock,~reset);

// // //***************************************************
// // //   SOC HW
// // //***************************************************



// // // top_rv32i_soc DUT (
// // //   .CLK_PAD       (clock),
// // //   .RESET_PAD   (~reset),
// // //   .O_UART_TX_PAD (o_uart_tx_pad),
// // //   .I_UART_RX_PAD (i_uart_rx_pad),
// // //   .IO_DATA_PAD   (gpio_pads)
// // //   // .I_TCK_PAD     (i_tck_pad),
// // //   // .I_TMS_PAD     (i_tms_pad),
// // //   // .I_TDI_PAD     (i_tdi_pad),
// // //   // .O_TDO_PAD     (o_tdo_pad)
// // // );

// //   // rv32i_soc #(
// //   //           .IMEM_DEPTH(128),
// //   //           .DMEM_DEPTH(128),
// //   //           .NO_OF_GPIO_PINS(24),
// //   //           .NO_OF_SHARED_PINS (13)
// //   //       )DUT(
// //   //         .clk (clock),
// //   //       .reset_n (~reset)
// //   //   //tracer
// //   //       );

// // top_rv32i_soc DUT (
// //   .*
// // );
// // //uart
// // //  assign UART_if.STx_O=O_UART_TX_PAD;	
// // //  assign I_UART_RX_PAD = UART_if.SRx_I;	
// // //spi 
// // assign  in_spi1.cs=IO_DATA_PAD[11];
// //  assign in_spi1.sclk = IO_DATA_PAD[10];
// //  assign IO_DATA_PAD[9]= in_spi1.miso;
// //  assign in_spi1.mosi = IO_DATA_PAD[8];
// //  assign  in_spi2.cs=IO_DATA_PAD[3];
// //  assign in_spi2.sclk = IO_DATA_PAD[2];
// //  assign IO_DATA_PAD[1]= in_spi2.miso;
// //  assign in_spi2.mosi = IO_DATA_PAD[0];
// // //wb 
// //  assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
// //    assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
// // always @(*)begin 
// //   force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
// //   force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
// //   //there is no sel signal in the interface of the wb
// //   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
// //   force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
// //   force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
// //   force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;
// //   // force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// //   // force DUT.u_rv32i_soc.i_miso=in_spi2.miso;
// // //  force sclk=DUT.u_rv32i_soc.o_flash_sclk;
// // //   force cs=DUT.u_rv32i_soc.o_flash_cs_n;
// // //     force in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
// // //     force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// // //  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
// // //              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
// // //              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_io_cyc,
// // //              DUT.u_rv32i_soc.wb_m2s_io_stb);


// // end


// // // 



// // clock_and_reset_if clk_rst_if (
// //     .clock(clock),
// //     .~reset(~reset),
// //     .run_clock(run_clock),
// //     .clock_period(clock_period)
// // );

// //   clkgen clkgen (
// //     .clock(clock ),
// //     .run_clock(run_clock),
// //     .clock_period(clock_period)
// //   );



// // endmodule

// // module hw_top;

// //   logic clock,~reset;
// //   logic [31:0]  clock_period;
// //   logic         run_clock;

// // // logic cs,sclk ; 

// // // uart_if in_uart(clock) ; 
// // wb_if in_wb(clock,~reset);
// // spi_if in_spi1(clock,~reset);
// // spi_if in_spi2(clock,~reset);

// // //***************************************************
// // //   SOC HW
// // //***************************************************
// //     wire O_UART_TX_PAD;
// //      wire I_UART_RX_PAD;
// //      wire [23:0] gpio_pads; 


// // top_rv32i_soc DUT (
// //   .CLK_PAD       (clock),
// //   .RESET_N_PAD   (~reset),
// //   .O_UART_TX_PAD (o_uart_tx_pad),
// //   .I_UART_RX_PAD (i_uart_rx_pad),
// //   .IO_DATA_PAD   (gpio_pads)
// //   // .I_TCK_PAD     (i_tck_pad),
// //   // .I_TMS_PAD     (i_tms_pad),
// //   // .I_TDI_PAD     (i_tdi_pad),
// //   // .O_TDO_PAD     (o_tdo_pad)
// // );








// // //in_wb signals
// //   // logic       [31:0]    ADR_O;
// //   // logic       [7:0]     DAT_I;
// //   // logic       [7:0]     DAT_O;
// //   // logic                 WE_O;
// //   // logic                 STB_O;
// //   // logic                 ACK_I;
// //   // logic                 CYC_O;

// // //rv32i_soc signals 
// //   // MY_TODO: IO ( wb master signals )
// //   // the data I in the interface is 32 bits
// //   logic [31:0] wb_io_adr_i;  // from --> .wb_adr_o
// //   logic [31:0] wb_io_dat_i;  // from --> .wb_dat_o 
// //   logic [ 3:0] wb_io_sel_i;  // from --> .wb_sel_o
// //   logic        wb_io_we_i;  // from --> .wb_we_o
// //   logic        wb_io_cyc_i;  // from --> .wb_cyc_o
// //   logic        wb_io_stb_i;  // from --> .wb_stb_o




// // // always @(*)begin 
// // //   force DUT.u_rv32i_soc.wb_m2s_spi_adr = in_wb.addr;
// // //   force DUT.u_rv32i_soc.wb_m2s_spi_dat = in_wb.din;
// // //   //there is no sel signal in the interface of the wb
// // //   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
// // //   force DUT.u_rv32i_soc.wb_m2s_spi_we  = in_wb.we;
// // //   force DUT.u_rv32i_soc.wb_m2s_spi_stb = in_wb.stb;
// // //   force DUT.u_rv32i_soc.wb_m2s_spi_cyc = in_wb.cyc;
// // //    force in_wb.ack = DUT.u_rv32i_soc.wb_s2m_spi_ack;
// // //    force in_wb.dout =DUT.u_rv32i_soc.spi_rdt_2 ;
 
// // //  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
// // //              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
// // //              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_spi_flash_cyc,
// // //              DUT.u_rv32i_soc.wb_m2s_io_stb);

// // // end
// //  assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
// //   assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
// // //   assign in_spi1.cs=DUT.u_rv32i_soc.o_flash_cs_n ;
// // //  assign in_spi1.sclk=DUT.u_rv32i_soc.o_flash_sclk;
// //    assign in_spi2.cs=DUT.u_rv32i_soc.o_cs_n ;
// //  assign in_spi2.sclk=DUT.u_rv32i_soc.o_sclk;
// // //  assign in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
// //  assign in_spi2.mosi=DUT.u_rv32i_soc.o_mosi;
// // // `ifdef SOC
// // always @(*)begin 
// //   force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
// //   force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
// //   //there is no sel signal in the interface of the wb
// //   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  
// //   force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
// //   force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
// //   force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;
// //   // force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// //   force DUT.u_rv32i_soc.i_miso=in_spi2.miso;
// // //  force sclk=DUT.u_rv32i_soc.o_flash_sclk;
// // //   force cs=DUT.u_rv32i_soc.o_flash_cs_n;
// // //     force in_spi1.mosi=DUT.u_rv32i_soc.o_flash_mosi;
// // //     force DUT.u_rv32i_soc.i_flash_miso=in_spi1.miso;
// // //  $display("hwtop:[%0t ns] ACK received=%b, for addr = %h, data = %h , cyc=%b,stb=%b", $time,
// // //              DUT.u_rv32i_soc.wb_s2m_io_ack,DUT.u_rv32i_soc.wb_m2s_io_adr,
// // //              DUT.u_rv32i_soc.wb_m2s_io_dat, DUT.u_rv32i_soc.wb_m2s_io_cyc,
// // //              DUT.u_rv32i_soc.wb`ifdef PD_BUILD_m2s_io_stb);


// // end
// //   assign in_spi1.cs=gpio_pads[11] ;
// //  assign in_spi1.sclk=gpio_pads[10];
// // assign in_spi1.mosi=gpio_pads[8];
// // assign gpio_pads[9]=in_spi1.miso;
// // // `else
// // //     assign in_wb.addr =  DUT.u_rv32i_soc.wb_m2s_io_adr;
// // //    assign in_wb.din =  DUT.u_rv32i_soc.wb_m2s_io_dat;
// // //   //  assign in_wb.sel =  DUT.u_rv32i_soc.wb_m2s_io_sel;
// // //    assign in_wb.we =  DUT.u_rv32i_soc.wb_m2s_io_we;
// // //    assign in_wb.cyc =  DUT.u_rv32i_soc.wb_m2s_io_cyc;
// // //    assign in_wb.stb =  DUT.u_rv32i_soc.wb_m2s_io_stb;
  
// // // `endif
// // // // assign in_spi.cs    = gpio_pads[19]; // or gpio_pads[20], based on which slave
// // // assign in_spi1.sclk  = gpio_pads[21];
// // // assign in_spi1.miso  = gpio_pads[22]; // input from slave
// // // assign gpio_pads[23] = in_spi1.mosi;  // output to slave

// // // assign gpio_pads[21] = sclk;
// // // assign gpio_pads[22] = in_spi1.miso; // input from slave (driven by slave)
// // // assign in_spi1.mosi  = gpio_pads[23]; // output to slave (driven by DUT)
// // // assign cs    = gpio_pads[19];
// // // assign sclk = gpio_pads[21];
// // // assign in_spi1.miso = gpio_pads[22]; 
// // // assign gpio_pads[23] = in_spi1.mosi; 
// // // assign cs = gpio_pads[19]; 



// // clock_and_reset_if clk_rst_if (
// //     .clock(clock),
// //     .~reset(~reset),
// //     .run_clock(run_clock),
// //     .clock_period(clock_period)
// // );

// //   clkgen clkgen (
// //     .clock(clock ),
// //     .run_clock(run_clock),
// //     .clock_period(clock_period)
// //   );



// // endmodule
// module hw_top;

//    logic [31:0]  clock_period;
//   logic         run_clock;
//   logic         clock;
//   logic         reset;
//   logic         STx_O;

//     logic o_flash_sCLK_PAD;
//     logic o_flash_cs_n;
//     logic o_flash_mosi;
//     logic i_flash_miso;
//     logic o_uart_tx;
//     logic i_uart_rx;
//     logic pwm_pad_o;

//     logic tck_i;
//     logic tdi_i;
//     logic tms_i;
//     logic tdo_o;

//     parameter DMEM_DEPTH = 2048;
//     parameter IMEM_DEPTH = 16384;
//     parameter NO_OF_GPIO_PINS = 24;

//     logic CLK_PAD;  // external clock pad
//     logic RESET_N_PAD;          // external ~reset (active low)
//     logic O_FLASH_SCLK_PAD;     // external SPI flash serial clock
//     logic O_FLASH_CS_N_PAD;     // external SPI flash chip‐select (active low)
//     logic O_FLASH_MOSI_PAD;     // external SPI flash MOSI
//     logic I_FLASH_MISO_PAD;     // external SPI flash MISO
//     logic O_UART_TX_PAD;        // external UART TX
//     wire I_UART_RX_PAD;       // external UART RX
//     wire [31:0] IO_DATA_PAD;  // external GPIO pads
//     logic O_PWM_PAD;
// // Power ports
//     logic  VDD_LEFT;                // Power
//     logic  VDD_RIGHT;                // Ground
//     logic  VDD_TOP;                // Power
//     logic  VDD_BOTTOM;                // Ground
//     logic  VSS_LEFT;                // Power
//     logic  VSS_RIGHT;                // Ground
//     logic VSS_TOP;                // Power
//     logic  VSS_BOTTOM;                // Ground
//     logic VDDPST_LEFT;             // Power
//     logic VDDPST_RIGHT;            // Ground
//     logic VDDPST_TOP;              // Power
//     logic VDDPST_BOTTOM;           // Ground
//     logic VSSPST_LEFT;             // Ground
//     logic VSSPST_RIGHT;            // Power
//     logic VSSPST_TOP;              // Ground
//     logic VSSPST_BOTTOM;           // Power

// //JTAG pad signals
//     logic I_TCK_PAD; // external JTAG TCK
//     logic I_TMS_PAD; // external JTAG TMS
//     logic I_TDI_PAD; // external JTAG TDI
//     logic O_TDO_PAD; // external JTAG TDO

//     logic VDD ;
//     logic VSS ;

//     assign VDD = 1;
//     assign VSS = 0;




//     assign CLK_PAD = clock;
//     assign RESET_N_PAD = ~reset;

// // logic cs,sclk ; 

// // uart_if in_uart(clock) ; 
// wb_if in_wb(clock,~reset);
// spi_if in_spi1(clock,~reset);
// spi_if in_spi2(clock,~reset);
// i2c_if in_i2c(clock,~reset);
// //***************************************************
// //   SOC HW
// //***************************************************












// top_rv32i_soc DUT (
//   .*
// );

// //SPI 1&2 
// assign  in_spi1.cs=IO_DATA_PAD[11];
//  assign in_spi1.sclk = IO_DATA_PAD[10];
//  assign IO_DATA_PAD[9]= in_spi1.miso;
//  assign in_spi1.mosi = IO_DATA_PAD[8];
//  assign  in_spi2.cs=IO_DATA_PAD[3];
//  assign in_spi2.sclk = IO_DATA_PAD[2];
//  assign IO_DATA_PAD[1]= in_spi2.miso;
//  assign in_spi2.mosi = IO_DATA_PAD[0];
// // I2C
//  logic scl_padoen_oe;
// logic sda_padoen_oe;
// logic scl_pad_o;
// logic sda_pad_o;
// assign in_i2c.scl = scl_padoen_oe ? 1'bz : scl_pad_o;
// assign in_i2c.sda = sda_padoen_oe ? 1'bz : sda_pad_o;
// pullup p1(in_i2c.scl);
// pullup p2(in_i2c.sda);
//     // Drive to I/O pads from SoC
// assign scl_pad_o= IO_DATA_PAD[13] ;
// assign  sda_pad_o=IO_DATA_PAD[14];
//    // Output enables from SoC
// assign scl_padoen_oe = DUT.u_rv32i_soc.o_scl_oen;
// assign sda_padoen_oe = DUT.u_rv32i_soc.o_sda_oen;
//   // Drive inputs into SoC
// assign DUT.u_rv32i_soc.i_scl = in_i2c.scl; //must disable io mux driver for it in soc 
// assign DUT.u_rv32i_soc.i_sda = in_i2c.sda; //must disable io mux driver for it in soc 

// // WB 
//  assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
//    assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
// always @(*)begin 
//   force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
//   force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
//   //there is no sel signal in the interface of the wb
//   force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
//   force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
//   force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
//   force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;

// end




// clock_and_reset_if clk_rst_if (
//     .clock(clock),
//     .reset(reset),
//     .run_clock(run_clock),
//     .clock_period(clock_period)
// );

//   clkgen clkgen (
//     .clock(clock ),
//     .run_clock(run_clock),
//     .clock_period(clock_period)
//   );



// endmodule
module hw_top;

   logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;
  logic         STx_O;

    logic o_flash_sCLK_PAD;
    logic o_flash_cs_n;
    logic o_flash_mosi;
    logic i_flash_miso;
    logic o_uart_tx;
    logic i_uart_rx;
    logic pwm_pad_o;

    logic tck_i;
    logic tdi_i;
    logic tms_i;
    logic tdo_o;

    parameter DMEM_DEPTH = 2048;
    parameter IMEM_DEPTH = 16384;
    parameter NO_OF_GPIO_PINS = 24;

    logic CLK_PAD;  // external clock pad
    logic RESET_N_PAD;          // external ~reset (active low)
    logic O_FLASH_SCLK_PAD;     // external SPI flash serial clock
    logic O_FLASH_CS_N_PAD;     // external SPI flash chip‐select (active low)
    logic O_FLASH_MOSI_PAD;     // external SPI flash MOSI
    logic I_FLASH_MISO_PAD;     // external SPI flash MISO
    logic O_UART_TX_PAD;        // external UART TX
    wire I_UART_RX_PAD;       // external UART RX
    wire [31:0] IO_DATA_PAD;  // external GPIO pads
    logic O_PWM_PAD;
// Power ports
    logic  VDD_LEFT;                // Power
    logic  VDD_RIGHT;                // Ground
    logic  VDD_TOP;                // Power
    logic  VDD_BOTTOM;                // Ground
    logic  VSS_LEFT;                // Power
    logic  VSS_RIGHT;                // Ground
    logic VSS_TOP;                // Power
    logic  VSS_BOTTOM;                // Ground
    logic VDDPST_LEFT;             // Power
    logic VDDPST_RIGHT;            // Ground
    logic VDDPST_TOP;              // Power
    logic VDDPST_BOTTOM;           // Ground
    logic VSSPST_LEFT;             // Ground
    logic VSSPST_RIGHT;            // Power
    logic VSSPST_TOP;              // Ground
    logic VSSPST_BOTTOM;           // Power

//JTAG pad signals
    logic I_TCK_PAD; // external JTAG TCK
    logic I_TMS_PAD; // external JTAG TMS
    logic I_TDI_PAD; // external JTAG TDI
    logic O_TDO_PAD; // external JTAG TDO

    logic VDD ;
    logic VSS ;

    assign VDD = 1;
    assign VSS = 0;

    assign CLK_PAD = clock;
    assign RESET_N_PAD = ~reset;

//interfaces 
uart_if in_uart1(clock) ; 
wb_if in_wb(clock,~reset);
spi_if in_spi1(clock,~reset);
spi_if in_spi2(clock,~reset);
i2c_if in_i2c(clock,~reset);

//soc 
top_rv32i_soc DUT (
  .*
);
 //connections 
//SPI 1&2 
assign  in_spi1.cs=IO_DATA_PAD[11];
 assign in_spi1.sclk = IO_DATA_PAD[10];
 assign IO_DATA_PAD[9]= in_spi1.miso;
 assign in_spi1.mosi = IO_DATA_PAD[8];
 assign  in_spi2.cs=IO_DATA_PAD[3];
 assign in_spi2.sclk = IO_DATA_PAD[2];
 assign IO_DATA_PAD[1]= in_spi2.miso;
 assign in_spi2.mosi = IO_DATA_PAD[0];
// I2C
 logic scl_padoen_oe;
logic sda_padoen_oe;
logic scl_pad_o;
logic sda_pad_o;
assign in_i2c.scl = scl_padoen_oe ? 1'bz : scl_pad_o;
assign in_i2c.sda = sda_padoen_oe ? 1'bz : sda_pad_o;
pullup p1(in_i2c.scl);
pullup p2(in_i2c.sda);
    // Drive to I/O pads from SoC
assign scl_pad_o= IO_DATA_PAD[13] ;
assign  sda_pad_o=IO_DATA_PAD[14];
   // Output enables from SoC
assign scl_padoen_oe = DUT.u_rv32i_soc.o_scl_oen;
assign sda_padoen_oe = DUT.u_rv32i_soc.o_sda_oen;
  // Drive inputs into SoC
assign DUT.u_rv32i_soc.i_scl = in_i2c.scl; //must disable io mux driver for it in soc 
assign DUT.u_rv32i_soc.i_sda = in_i2c.sda; //must disable io mux driver for it in soc 
//uart 
 assign in_uart1.STx_O=O_UART_TX_PAD;	
 assign I_UART_RX_PAD = in_uart1.SRx_I;
// WB 
 assign in_wb.ack = DUT.u_rv32i_soc.wb_s2m_io_ack;
   assign  in_wb.dout =DUT.u_rv32i_soc.wb_s2m_io_dat ;
always @(*)begin 
  force DUT.u_rv32i_soc.wb_m2s_io_adr = in_wb.addr;
  force DUT.u_rv32i_soc.wb_m2s_io_dat = in_wb.din;
  //there is no sel signal in the interface of the wb
  force DUT.u_rv32i_soc.wb_m2s_io_sel = 4'b1111; // assuming all bytes selected
  force DUT.u_rv32i_soc.wb_m2s_io_we  = in_wb.we;
  force DUT.u_rv32i_soc.wb_m2s_io_stb = in_wb.stb;
  force DUT.u_rv32i_soc.wb_m2s_io_cyc = in_wb.cyc;

end




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
