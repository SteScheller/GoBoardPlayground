# Nandland Goboard binary creation and simulation using the IceStrom toolchain,
# Icarus Verilog, Verilator, GTKWave
#

PROJECT_NAME = UART
SOURCES = uart_top.v uart_rx.v uart_tx.v seven_segment_decoder.v

BUILD_DIR = out

SYNTH = yosys
PNR = nextpnr-ice40
PACK = icepack
PROGRAMMER = iceprog
VERILOG_SIMULATOR = iverilog
WAVEFORM_VIEWER = gtkwave
VERILOG_CPP_COMPILER = verilator

NAME = $(PROJECT_NAME)
OUT = $(BUILD_DIR)

.PHONY: clean flash verilog_sim

default: $(OUT)/$(NAME).bin

$(OUT):
	@echo Creating build directory...
	@mkdir -p $(OUT)

$(OUT)/$(NAME).bin: $(OUT) $(SOURCES)
	@echo synthesizing netlist...
	@echo
	$(SYNTH) -p "synth_ice40 -top $(NAME)_TLM -json $(OUT)/$(NAME).json" $(SOURCES)
	@echo
	@echo --------------------------------------------------------------------------------
	@echo place and route...
	@echo
	$(PNR) --hx1k --package vq100 --freq 25 --pcf constraints.pcf --asc $(OUT)/$(NAME).asc --json $(OUT)/$(NAME).json
	@echo
	@echo --------------------------------------------------------------------------------
	@echo generating binary image...
	@echo
	$(PACK) $(OUT)/$(NAME).asc $(OUT)/$(NAME).bin 
	@echo
	@echo --------------------------------------------------------------------------------


flash: $(OUT)/$(NAME).bin
	@echo flashing target...
	@echo
	$(PROGRAMMER) $(OUT)/$(NAME).bin

$(OUT)/$(NAME).out: $(NAME)_tb.v $(SOURCES)
	@echo translating verilog source...
	@echo
	$(VERILOG_SIMULATOR) $(NAME)_tb.v $(SOURCES) -o $(OUT)/$(NAME).out

verilog_sim: $(OUT)/$(NAME).out
	@echo simulating verilog testbench...
	@echo
	(cd $(OUT) && ./$(NAME).out && $(WAVEFORM_VIEWER) dump.vcd)

cpp_sim:
	@echo simulating verilog testbench...
	@echo
	@echo tbd...

clean:
	@echo Cleaning up...
	rm -rf ./$(OUT)
	@echo Done!

