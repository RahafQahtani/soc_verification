.PHONY: clean-submodules add-submodules update-submodules all help

clean-submodules:
	@echo "Removing submodules..."
	-git submodule deinit -f RV32_SoC
	-git rm -rf RV32_SoC
	-rm -rf .git/modules/RV32_SoC

	-git submodule deinit -f Peripherals/uart_uvc
	-git rm -rf Peripherals/uart_uvc
	-rm -rf .git/modules/Peripherals/uart_uvc

	-git submodule deinit -f Peripherals/gpio_uvc
	-git rm -rf Peripherals/gpio_uvc
	-rm -rf .git/modules/Peripherals/gpio_uvc

	-git submodule deinit -f Peripherals/spi_uvc
	-git rm -rf Peripherals/spi_uvc
	-rm -rf .git/modules/Peripherals/spi_uvc

	-git submodule deinit -f Peripherals/i2c_uvc
	-git rm -rf Peripherals/i2c_uvc
	-rm -rf .git/modules/Peripherals/i2c_uvc

add-submodules:
	@echo "Adding submodules..."
	git submodule add https://github.com/Nehal-2/RV32_SoC.git RV32_SoC
	git submodule add https://github.com/RedaM4/uart_wb_uvcs.git Peripherals/uart_uvc
	git submodule add https://github.com/Mashael29/GPIO.git Peripherals/gpio_uvc
	git submodule add https://github.com/RahafQahtani/SPI-UVM-.git Peripherals/spi_uvc
	git submodule add https://github.com/yaserc33/Wishbone_x_I2C.git Peripherals/i2c_uvc

	git submodule update --init

update-submodules:
	@echo "Updating all submodules (git pull inside each)..."
	@git -C RV32_SoC pull origin master || true
	@git -C Peripherals/uart_uvc pull origin main || true
	@git -C Peripherals/gpio_uvc pull origin main || true
	@git -C Peripherals/spi_uvc pull origin main || true
	@git -C Peripherals/i2c_uvc pull origin main || true

all: clean-submodules add-submodules

help:
	@echo ""
	@echo "Usage:"
	@echo "  make all                 Clean + add all submodules"
	@echo "  make clean-submodules    Remove all submodules"
	@echo "  make add-submodules      Add submodules only"
	@echo "  make update-submodules   Pull latest code inside each submodule"
	@echo "  make help                Show this message"
