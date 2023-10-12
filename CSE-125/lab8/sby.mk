.PHONY: check check-help check-clean check-vars-help

check: 
	sby -f $(TOP_MODULE).sby

check-help:
	@echo "  check-good: Run the formal verification toolchain on the verilog on the known-good solution"
	@echo "  check-bad: Run the formal verification toolchain on the verilog on the known-bad solution"

check-vars-help:
	@echo "    SBY: Override this variable to set the location of your yosys executable."

check-clean:
	rm -rf *.yslog
	rm -rf $(TOP_MODULE)
	rm -rf $(TOP_MODULE)_synth

clean: check-clean
targets-help: check-help
vars-help: check-vars-help


