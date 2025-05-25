# Filelist for VCS simulation

# Compilation Flags
-timescale=1ns/10ps
-sverilog
+define+DMEM_DEPTH=2048
+define+DMEM_DEPTH=8192


#+define+PD_BUILD
#+define+SG
#+define+BOOT
+define+VCS_SIM   
+define+USE_SRAM
+define+tracer
#+define+pqc

# lib that many module accesses should be compiled first
../../RivRtos/src/soc/core/lib.sv
../../RivRtos/src/soc/debug/debug_pkg.sv

# Core files
../../RivRtos/src/soc/core/alignment_units.sv
../../RivRtos/src/soc/core/alu_control.sv
../../RivRtos/src/soc/core/mul_unit.sv
../../RivRtos/src/soc/core/div_unit.sv
../../RivRtos/src/soc/core/branch_controller.sv
../../RivRtos/src/soc/core/csr_file.sv
../../RivRtos/src/soc/core/imm_gen.sv
../../RivRtos/src/soc/core/decode_control.sv
../../RivRtos/src/soc/core/reg_file.sv
../../RivRtos/src/soc/core/rom.sv
../../RivRtos/src/soc/core/forwarding_unit.sv
../../RivRtos/src/soc/core/hazard_controller.sv
../../RivRtos/src/soc/core/pipeline_controller.sv
../../RivRtos/src/soc/core/decompressor.sv
../../RivRtos/src/soc/core/iadu.sv
../../RivRtos/src/soc/core/atomic_access_controller.sv
../../RivRtos/src/soc/core/exception_encoder.sv
../../RivRtos/src/soc/core/alu.sv

../../RivRtos/src/soc/core/data_path.sv
../../RivRtos/src/soc/core/control_unit.sv
../../RivRtos/src/soc/core/core_dbg_fsm.sv
../../RivRtos/src/soc/core/rv32i_top.sv

# Wishbone interconnect files
../../RivRtos/src/soc/WishboneInterconnect/wb_intercon_1.2.2-r1/wb_mux.v
../../RivRtos/src/soc/WishboneInterconnect/wb_intercon.sv
../../RivRtos/src/soc/WishboneInterconnect/wishbone_controller.sv

# Peripheral files
../../RivRtos/src/soc/uncore/gpio/gpio_defines.v
../../RivRtos/src/soc/uncore/gpio/bidirec.sv
../../RivRtos/src/soc/uncore/gpio/gpio_top.sv
../../RivRtos/src/soc/uncore/spi/fifo4.v
../../RivRtos/src/soc/uncore/spi/simple_spi.sv
../../RivRtos/src/soc/uncore/uart/uart_defines.v
../../RivRtos/src/soc/uncore/uart/raminfr.v
../../RivRtos/src/soc/uncore/uart/uart_receiver.v
../../RivRtos/src/soc/uncore/uart/uart_regs.v
../../RivRtos/src/soc/uncore/uart/uart_rfifo.v
../../RivRtos/src/soc/uncore/uart/uart_sync_flops.v
../../RivRtos/src/soc/uncore/uart/uart_tfifo.v
../../RivRtos/src/soc/uncore/uart/uart_top.v
../../RivRtos/src/soc/uncore/uart/uart_transmitter.v
../../RivRtos/src/soc/uncore/uart/uart_wb.v
../../RivRtos/src/soc/uncore/clint/clint_wb.sv
../../RivRtos/src/soc/uncore/clint/clint_top.sv
../../RivRtos/src/soc/uncore/ptc/ptc_defines.v
../../RivRtos/src/soc/uncore/ptc/ptc_top.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_defines.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_bit_ctrl.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_byte_ctrl.v
../../RivRtos/src/soc/uncore/i2c/rtl/i2c_master_top.v
../../RivRtos/src/soc/uncore/plic/plic_pkg.sv
../../RivRtos/src/soc/uncore/plic/plic_gateway.sv
../../RivRtos/src/soc/uncore/plic/plic_core.sv
../../RivRtos/src/soc/uncore/plic/plic_top.sv


# Debug Unit 
../../RivRtos/src/soc/debug/dtm.sv
../../RivRtos/src/soc/debug/dm.sv
../../RivRtos/src/soc/debug/debug_top.sv

# sram 
# verilog model for simulation
../../RivRtos/src/soc/core/sram_32k_wrapper.sv

# rom

# system verilog models for prototyping
../../RivRtos/src/soc/core/data_mem.sv


# rv32i soc top
../../RivRtos/src/soc/io_mux.sv
../../RivRtos/src/soc/rv32i_soc.sv

# pad library and top module file 
#../../RivRtos/src/pads/tpz018nv_270a/tpz018nv.v
../../RivRtos/src/pads/top_rv32i_soc.sv

# Testbench files





# Optionally, include any other files you want for the simulation.
