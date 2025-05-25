module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;
  logic         STx_O;

  //wishbone interface
  wishbone_if wb_if
    (.clock(clock), 
    .reset(reset)
    );

  //UART interface
  uart_if UART_if(clock);

   // clock and reset interface 
  clock_and_reset_if clk_rst_if(
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );


  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  //Adding RTL
  uart_top	UART(.wb_clk_i(clock), 
                // Wishbone signals
	              .wb_rst_i(reset), .wb_adr_i(wb_if.adr_i), .wb_dat_i(wb_if.dat_i), .wb_dat_o(wb_if.dat_o), .wb_we_i(wb_if.we_i), .wb_stb_i(wb_if.stb_i), .wb_cyc_i(wb_if.cyc_i), .wb_ack_o(wb_if.ack_o), .wb_sel_i(wb_if.sel_i),
	              .int_o(wb_if.inta_o), // interrupt request
              	// UART	signals
              	// serial input/output
	              .stx_pad_o(UART_if.STx_O), .srx_pad_i(UART_if.SRx_I),
              	// modem signals
	              .rts_pad_o(), .cts_pad_i(), .dtr_pad_o(), .dsr_pad_i(), .ri_pad_i(), .dcd_pad_i());




endmodule : hw_top
