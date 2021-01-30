
VIVADO_BASE = C:/Xilinx/Vivado/2020.2
VIVADO = $(VIVADO_BASE)/bin/vivado
XVLOG = $(VIVADO_BASE)/bin/xvlog
XELAB = $(VIVADO_BASE)/bin/xelab
GLBL = $(VIVADO_BASE)/data/verilog/src/glbl.v

export VIVADO

.PHONY : help synth_system sim_system firmware clean clean_firmware

help:
	@echo ""
	@echo "Firmware:"
	@echo "    make firmware"
	@echo ""
	@echo "System:"
	@echo "    make synth_system"
	@echo ""

synth_system:
	$(VIVADO) -nojournal -log $@.log -mode batch -source $@.tcl
	-grep -B4 -A10 'Slice LUTs' $@.log
	-grep -B1 -A9 ^Slack $@.log && echo

sim_system:
	@echo "TODO"

firmware:
	./build_docker.sh
	$(MAKE) -C firmware clean

clean_firmware:
	rm firmware.hex

clean:
	rm -rf .Xil/ synth_*.log webtalk.jou synth_system.v 
	rm -rf synth_*.mmi synth_*.bit xsim[._]* xvlog.*
	rm -rf webtalk.log webtalk_*.jou webtalk_*.log xelab.* *.html *.xml


