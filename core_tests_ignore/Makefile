
# ===== Default Config =====
# override module := spi1                 # For generate_assembly
test ?= spi1_C_toggle_test                           # Compile-time macro

# ===== Toolchain & Utilities =====
CC           = riscv32-unknown-elf-gcc
OBJCOPY      = riscv32-unknown-elf-objcopy
CONVERT_HEX  = python3 scripts/convert_hex.py

# ===== Files & Flags =====
RTL_INT_DIR = ../RivRtos/src/tb/inst_formatted.hex
TB_DIR = ../Soc/tb


SRC_FILES    = main.c spi1/spi1.c
OBJS         = $(SRC_FILES:.c=.o)
INCLUDES     = -Ispi1

CFLAGS  = -march=rv32i -mabi=ilp32 -nostartfiles -nostdlib -Wall -Ispi1
CFLAGS += -O2 -ffunction-sections -fdata-sections -Wno-unused-but-set-variable -Wno-unused-variable
CFLAGS += -D$(test)

LDFLAGS = -nostartfiles -nostdlib -Wl,--entry=main -Wl,--script=/dev/null -Wl,--gc-sections


# ===== Output Files =====
OUT_ELF         = main.elf
OUT_HEX         = main.hex
# TEST_STRIPPED   := $(subst $(space),_,$(strip $(test)))
# INST_HEX        = inst_$(module)_$(TEST_STRIPPED).hex
INST_CONV_HEX   = inst_formatted.hex
# ===== Debug Output AFTER CFLAGS is built =====
# $(info [DEBUG] test = '$(test)')
# $(info [DEBUG] CFLAGS = '$(CFLAGS)')


.PHONY: all clean help  convert_hex init generate_assembly export_test

# ===== Build Sequence =====
all: $(OUT_HEX)  convert_hex generate_assembly export_test
	@echo "Build complete. Hex files generated:"
	@echo "  → $(INST_HEX)"
	@echo "  → $(INST_CONV_HEX)"

# ===== Compile .c to .o =====
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# ===== Link into ELF =====
$(OUT_ELF): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@

# ===== Raw hex file from ELF =====
$(OUT_HEX): $(OUT_ELF)
	$(OBJCOPY) -O verilog --wildcard -j '.text*' --gap-fill=0x00 $< $@


# ===== Copy raw hex to formatted instruction hex =====
# extract_hex: $(OUT_HEX)
# 	cp $(OUT_HEX) $(INST_HEX)

# ===== Convert hex using Python script =====
convert_hex: $(OUT_HEX)
	@echo "Converting instruction hex file..."
	$(CONVERT_HEX) $(OUT_HEX) $(INST_CONV_HEX)

# ===== Generate assembly for specified module =====
# ===== Generate assembly for specified module =====
generate_assembly:
	@echo "Disassembling main.elf..."
	riscv32-unknown-elf-objdump -d main.elf > asm_.asm
	@echo "Saved: asm_.asm"

export_test: 
		cp $(INST_CONV_HEX) $(RTL_INT_DIR)


tb_run:
	$(MAKE) -C $(TB_DIR) all


# ===== Clean all build files =====
clean:
	rm -f *.o spi1/*.o *.hex *.asm *.elf

# ===== Toolchain Check and Install =====
init:
	@echo "Checking for RISC-V toolchain..."
	@which riscv64-unknown-elf-gcc > /dev/null || { \
		echo "Toolchain not found. Installing..."; \
		sudo apt update; \
		sudo apt install -y gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf; \
	}
	@echo "Done. You can now run 'make' or 'make test=...'"

# ===== Help Message =====
help:
	@echo "Usage:"
	@echo "  make                                  - Build using default test ($(test))"
	@echo "  make test=your_macro                  - Build with specific macro (e.g., test1)"
	@echo "  make extract_hex                      - Copy hex to named file for conversion"
	@echo "  make convert_hex                      - Convert hex using Python script"
	@echo "  make generate_assembly                - Disassemble .o to asm_.asm"
	@echo "  make clean                            - Remove object, hex, and asm files"
	@echo "  make init                             - Install RISC-V toolchain"
	@echo "  make help                             - Show this help message"
