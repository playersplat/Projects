# CSE x25
# If you have iverilog or verilator installed in a non-standard path,
# you can override these to specify the path to the executable.
IVERILOG ?= iverilog
VERILATOR ?= verilator

VERILATOR_ROOT=/opt/homebrew/Cellar/verilator/5.002/share/verilator/

## DO NOT MODIFY ANYTHING BELOW THIS LINE

# We will always provide these six targets:

help: targets-intro-help targets-help vars-intro-help vars-help

targets-help: sim-help
vars-help: sim-vars-help

targets-intro-help:
	@echo "make <target-name>"

sim-help:
	@echo "  help: Print this message."
	@echo "  lint: Run the Verilator linter on all source files."
	@echo "  test: Run all testbenches and generate the simulation log files."
	@echo "  all: Run the lint target, and if it passes, run the test target."
	@echo "  clean: Remove all compiler outputs."
	@echo "  extraclean: Remove all generated files (runs clean)."

vars-intro-help:
	@echo ""
	@echo "  Optional Environment Variables:"

sim-vars-help:
	@echo "    IVERILOG: Override this variable to set the location of your Icarus Verilog executable."
	@echo "    VERILATOR: Override this variable to set the location of your Verilator executable."


# lint runs the Verilator linter on your code.
lint:
	$(foreach s,$(SYNTH_SOURCES),$(VERILATOR) --lint-only -I../../provided_modules  $(VSIM_OPTS) -Wall $(s);)

# test runs the simulation logs that you will check into git
test: verilator.log

# all runs the lint target, and if it passes, the test target
all: lint test


# Verilator Commands:
VSIM_EXE := verilator-tb
VSIM_LOG := verilator.log
VSIM_OPTS = -sv --timing --trace-fst -timescale-override 1ns/1ps

INCLUDES += -I../../provided_modules/dpi
INCLUDES += -I$(VERILATOR_ROOT)/include
INCLUDES += -I$(VERILATOR_ROOT)/include/vltstd
INCLUDES += -Iobj_dir

VSIM_WAV := verilator.fst

obj_dir/Vtestbench.mk: testbench.sv $(NONSYNTH_SOURCES) $(SYNTH_SOURCES) 
	$(VERILATOR) --cc $(VSIM_OPTS) --top-module testbench testbench.sv $(NONSYNTH_SOURCES) $(SYNTH_SOURCES) $(CFLAGS) $(CXXSOURCES) -Wno-fatal -Wno-lint -Wno-multidriven

%__ALL.a: %.mk
	$(MAKE) -j -C $(dir $@) -f $(notdir $<) default

%.o: $(VERILATOR_ROOT)/include/%.cpp
	g++ -MMD -I$(VERILATOR_ROOT)/include -I$(VERILATOR_ROOT)/include/vltstd -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -std=c++11 -c -o $@ $^

%.o: ../../provided_modules/dpi/%.cpp
	g++ -MMD -I$(VERILATOR_ROOT)/include $(INCLUDES) -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -std=c++11 -c -o $@ $<

main.o: main.cpp obj_dir/Vtestbench__ALL.a
	g++ -MMD -I$(VERILATOR_ROOT)/include $(INCLUDES) -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -std=c++11 -c -o $@ $<

main: verilated.o verilated_dpi.o main.o verilated_fst_c.o obj_dir/Vtestbench__ALL.a nonsynth_dpi_clock_gen.o
	g++ -std=c++11 $^ -o $@ -lz

$(VSIM_LOG): main
	./main | tee verilator.log

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

.PHONY: $(ISIM_LOG) $(VSIM_LOG) help intro-targets-help targets-help sim-help intro-vars-help vars-help sim-vars-help lint test all clean extraclean
