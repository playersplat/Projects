# CSE x25 Lab 2
TOP_MODULE = palindrome
SYNTH_SOURCES += $(TOP_MODULE).sv
SYNTH_SOURCES += ../../part2/ram_1w1r_async/ram_1w1r_async.sv
SYNTH_SOURCES += counter.sv
SYNTH_SOURCES += counter_down.sv
SYNTH_SOURCES += ../../provided_modules/inv.sv
SYNTH_SOURCES += ../../provided_modules/dff.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_clock_gen.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_reset_gen.sv
-include ../../simulation.mk
-include ../../fpga.mk
