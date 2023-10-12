# CSE x25 Lab 2
TOP_MODULE = konami
SYNTH_SOURCES += $(TOP_MODULE).sv
SYNTH_SOURCES += ../../provided_modules/inv.sv
SYNTH_SOURCES += ../../provided_modules/dff.sv
SYNTH_SOURCES += ../../provided_modules/jstk/PmodJSTK.sv
SYNTH_SOURCES += ../../provided_modules/jstk/spiCtrl.v
SYNTH_SOURCES += ../../provided_modules/jstk/ClkDiv_20Hz.sv
SYNTH_SOURCES += ../../provided_modules/jstk/ClkDiv_66_67kHz.sv
SYNTH_SOURCES += ../../provided_modules/jstk/spiMode0.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_clock_gen.sv
NONSYNTH_SOURCES += ../../provided_modules/nonsynth_reset_gen.sv
-include ../../simulation.mk
-include ../../fpga.mk
