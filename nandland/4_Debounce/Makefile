# Nandland Goboard binary creation using the icestrom toolchain 
#

TARGET = debounce
TOP_MODULE = Debounce_Project_Top
CONSTRAINTS = constraints.pcf
SOURCES = debounce.v debounce_switch.v

BUILD_DIR = out

SYNTH = yosys
PNR = nextpnr-ice40
PACK = icepack
PROGRAMMER = iceprog

.PHONY: clean flash

default: $(BUILD_DIR)/$(TARGET).bin

$(BUILD_DIR):
	@echo Creating build directory...
	@mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)
	@echo synthesizing netlist...
	@echo
	$(SYNTH) -p "synth_ice40 -top $(TOP_MODULE) -json $(BUILD_DIR)/$(TARGET).json" $(SOURCES)
	@echo
	@echo --------------------------------------------------------------------------------
	@echo place and route...
	@echo
	$(PNR) --hx1k --package vq100 --freq 25 --pcf $(CONSTRAINTS) --asc $(BUILD_DIR)/$(TARGET).asc --json $(BUILD_DIR)/$(TARGET).json
	@echo
	@echo --------------------------------------------------------------------------------
	@echo generating binary image...
	@echo
	$(PACK) $(BUILD_DIR)/$(TARGET).asc $(BUILD_DIR)/$(TARGET).bin 
	@echo
	@echo --------------------------------------------------------------------------------


flash: $(BUILD_DIR)/$(TARGET).bin
	@echo flashing target...
	@echo
	$(PROGRAMMER) $(BUILD_DIR)/$(TARGET).bin

clean:
	@echo Cleaning up...
	rm -rf ./$(BUILD_DIR)
	@echo Done!

