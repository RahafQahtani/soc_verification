+UVM_VERBOSITY=UVM_FULL 
+ntb_random_seed_automatic

//+UVM_TESTNAME=wbxspi1_flags_test
//+UVM_TESTNAME=wbxspi2_flags_test
//+UVM_TESTNAME=wbxspi1_write_test
//+UVM_TESTNAME=wbxspi2_write_test
//+UVM_TESTNAME=wbxspi1_read_test
//+UVM_TESTNAME=wbxspi2_read_test
//+UVM_TESTNAME=wb_read_byte_on_i2c
+UVM_TESTNAME=wb_write_byte_on_i2c
//vcs -full64 -ntb_opts uvm -sverilog -debug_all -kdb -timescale=1ns/1ns -f filelist.f -o simv
