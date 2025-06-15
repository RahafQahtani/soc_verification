.PHONY: clean-submodules add-submodules

clean-submodules:
	@echo "Removing submodules..."

	-git submodule deinit -f RV32_SoC
	-git rm -rf RV32_SoC
	-rm -rf .git/modules/RV32_SoC

	-git submodule deinit -f Peripherals/uart_uvc
	-git rm -rf Peripherals/uart_uvc
	-rm -rf .git/modules/Peripherals/uart_uvc

	-git submodule deinit -f Peripherals/uart_uvc/core-verification
	-git rm -rf Peripherals/uart_uvc/core-verification
	-rm -rf .git/modules/Peripherals/uart_uvc/core-verification

	-git submodule deinit -f Peripherals/gpio_uvc
	-git rm -rf Peripherals/gpio_uvc
	-rm -rf .git/modules/Peripherals/gpio_uvc


# ➕ Re-add all submodules with correct URLs
add-submodules:
	@echo "Adding submodules..."
	git submodule add https://github.com/Nehal-2/RV32_SoC.git RV32_SoC
	git submodule add https://github.com/RedaM4/uart_wb_uvcs.git Peripherals/uart_uvc
	# git submodule add https://github.com/google/riscv-dv.git Peripherals/uart_uvc/core-verification ← 🔴 remove this line
	git submodule add https://github.com/Mashael29/GPIO.git Peripherals/gpio_uvc
	git submodule update --init --recursive
