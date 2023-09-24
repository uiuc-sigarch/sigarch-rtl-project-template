# Makefile -- the most interesting target to run is probably `run`, which runs
# the UVM testbench.
SHELL = /bin/bash -o pipefail
RTL_SRCS := $(shell find $(PWD)/rtl -name '*.sv')
PKG_SRCS := $(shell find $(PWD) -name '*pkg.sv')
VERIF_SRCS := $(shell find $(PWD)/verif ! -name '*pkg.sv' -name '*.sv' -o -name '*.v')
SRCS := $(PKG_SRCS) $(RTL_SRCS) $(VERIF_SRCS)
UVM_HOME := ${UVM_HOME}
SYNTH_TCL := $(CURDIR)/synthesis.tcl
MSG_CONFIG := $(CURDIR)/vcs_msg_config
VCS_FLAGS= -full64 -sverilog -msg_config=$(MSG_CONFIG) -debug_acc+all -notice -kdb +vcs+dumpvars+dump.vcd -l compile.log  +incdir+../verif -top packet_processor_tb

sim/simv: $(SRCS) $(MSG_CONFIG)
	mkdir -p sim
	cd sim && vcs $(SRCS) $(VCS_FLAGS)

run: sim/simv
	cd sim && ./simv -l simulation.log

synth: $(SRCS) $(SYNTH_TCL)
	mkdir -p synth/reports
	cd synth && dc_shell -f $(SYNTH_TCL)  2>&1 | tee synthesis.log
	echo "Reports are in synth/reports/"

clean:
	rm -rf sim synth

.PHONY: clean
.PHONY: run
