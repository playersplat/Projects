# CSE x25 Lab 1, Part 1
# If you have iverilog or verilator installed in a non-standard path,
# you can override these to specify the path to the executable.
IVERILOG ?= iverilog
VERILATOR ?= verilator

## DO NOT MODIFY ANYTHING BELOW THIS LINE

# We will always provide these six targets:
help:
	@echo "make [help|lint|test|all]"
	@echo "  help: Print this message."
	@echo "  lint: Run the Verilator linter on all source files."
	@echo "  test: Run all testbenches and generate the simulation log files."
	@echo "  all: Run the lint target, and if it passes, run the test target."
	@echo "  clean: Remove all compiler outputs."
	@echo "  extraclean: Remove all generated files (runs clean)."
	@echo ""
	@echo "  Optional Variables:"
	@echo "    IVERILOG: Override this variable on the CLI to set the location of your Icarus Verilog executable."
	@echo "    VERILATOR: Override this variable on the CLI to set the location of your Verilator  executable."


# lint runs the Verilator linter on your code. 
lint:
	$(VERILATOR) --lint-only -sv --timing testbench-verilator.sv
	$(VERILATOR) --lint-only -sv --timing testbench-iverilog.sv

# test runs the simulation logs that you will check into git
test: verilator.log iverilog.log

# all runs the lint target, and if it passes, the test target
all: lint test


# Verilator Commands: 
VSIM_EXE := verilator-tb
VSIM_LOG := verilator.log
VSIM_WAV := verilator.fst
VSIM_OPTS = --binary -sv --timing --trace-fst
obj_dir/$(VSIM_EXE): testbench-verilator.sv
	$(VERILATOR) -o $(VSIM_EXE) $(VSIM_OPTS) testbench-verilator.sv

$(VSIM_LOG): ./obj_dir/$(VSIM_EXE)
	./obj_dir/$(VSIM_EXE) | tee verilator.log

# Icarus Verilog (iverilog) Commands: 
ISIM_EXE := iverilog-tb
ISIM_LOG := iverilog.log
ISIM_WAV := iverilog.vcd
$(ISIM_EXE): testbench-iverilog.sv
	$(IVERILOG) -g2005-sv -o $(ISIM_EXE) testbench-iverilog.sv 

$(ISIM_LOG): $(ISIM_EXE)
	./$(ISIM_EXE) | tee iverilog.log
	echo "Current System Time is: $(shell date +%X--%x)" >> iverilog.log

# Remove all compiler outputs
clean:
	rm -f $(ISIM_EXE)
	rm -rf obj_dir

# Remove all generated files
extraclean: clean
	rm -f $(ISIM_LOG)
	rm -f $(VSIM_LOG)
	rm -f $(ISIM_WAV)
	rm -f $(VSIM_WAV)

.PHONY: $(ISIM_LOG) $(VSIM_LOG) help lint test all clean extraclean
