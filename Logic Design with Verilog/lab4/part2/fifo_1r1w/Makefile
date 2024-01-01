TOP_MODULE += fifo_1r1w
SYNTH_SOURCES += $(TOP_MODULE).sv
SYNTH_SOURCES += ../../part2/elastic_pipe/elastic_pipe.sv
SYNTH_SOURCES += ../../part1/ram_1r1w_sync/ram_1r1w_sync.sv
SYNTH_SOURCES += ../../provided_modules/axis_i2s2.v
SYNTH_SOURCES += ../../provided_modules/inv.sv
SYNTH_SOURCES += ../../provided_modules/dff.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_clock_gen.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_reset_gen.sv
-include ../../simulation.mk
-include ../../fpga.mk

