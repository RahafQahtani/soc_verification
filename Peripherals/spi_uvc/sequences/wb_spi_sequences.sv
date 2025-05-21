`ifndef SOC
class wb_base_seq extends uvm_sequence #(wb_transaction);

  `uvm_object_utils(wb_base_seq)

  string phase_name;
  uvm_phase phaseh;

  function new(string name = "wb_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : wb_base_seq
`endif

class enable_spi_core extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(enable_spi_core)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b00110000;
      })

  endtask : body
endclass : enable_spi_core

class enable_spi2_core extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(enable_spi2_core)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b00110000;
      })

  endtask : body
endclass : enable_spi2_core

class wb_write_spi1_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_write_spi1_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b0000001;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 2;
        din == 8'b0000101;
        rest_rf == 0;
      })

    #160;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b0000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 2;
        rest_rf == 0;
      })

  endtask : body
endclass : wb_write_spi1_seq

class wb_write_spi2_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_write_spi2_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000001;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 2;
        din == 8'b00011111;
        rest_rf == 1;
      })

    #160;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 2;
        rest_rf == 0;
      })

  endtask : body
endclass : wb_write_spi2_seq

class wb_read_spi1_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_read_spi1_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000001;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 2;
        din == 8'h00;
        rest_rf == 0;
      })

    #160;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 2;
        rest_rf == 1;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 1;
        rest_rf == 0;
      })

  endtask : body
endclass : wb_read_spi1_seq



class wb_read_spi2_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_read_spi2_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b0000001;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 2;
        din == 8'b000000;
        rest_rf == 0;
      })

    #160;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b0000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 2;
        rest_rf == 1;
      })
  endtask : body
endclass : wb_read_spi2_seq

class wb_flags_spi1_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_flags_spi1_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 32'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000001;
        rest_rf == 0;
      })

    for (int i=1; i<=5;i++) begin
      `uvm_do_with(req,
        { op_type == wb_write;
          addr == `SPI1_BASE_ADDRESS + `OFFSET * 2;
          din == 8'h00 + i;
          rest_rf == 0;
        })
    end

    #80;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 1;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b00110000;
        rest_rf == 1;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI1_BASE_ADDRESS + `OFFSET * 1;
        rest_rf == 1;
      })
  endtask : body
endclass : wb_flags_spi1_seq

class wb_flags_spi2_seq extends wb_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(wb_flags_spi2_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 32'b01110000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000001;
        rest_rf == 0;
      })

    for (int i=1; i<=5;i++) begin
      `uvm_do_with(req,
        { op_type == wb_write;
          addr == `SPI2_BASE_ADDRESS + `OFFSET * 2;
          din == 8'h00 + i;
          rest_rf == 0;
        })
    end

    #80;

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 4;
        din == 8'b00000000;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 1;
        rest_rf == 0;
      })

    `uvm_do_with(req,
      { op_type == wb_write;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 0;
        din == 8'b00110000;
        rest_rf == 1;
      })

    `uvm_do_with(req,
      { op_type == wb_read;
        addr == `SPI2_BASE_ADDRESS + `OFFSET * 1;
        rest_rf == 1;
      })
  endtask : body
endclass : wb_flags_spi2_seq