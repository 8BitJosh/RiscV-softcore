
VIVADO_BASE = C:/Xilinx/Vivado/2020.2
VIVADO = $(VIVADO_BASE)/bin/vivado

export VIVADO

.PHONY : help synth_system firmware clean

synth_system:
	$(VIVADO) -nojournal -log $@.log -mode batch -source $@.tcl
	-grep -B4 -A10 'Slice LUTs' $@.log
	-grep -B1 -A9 ^Slack $@.log && echo

firmware:
	./build_docker.sh
	$(MAKE) -C firmware clean

clean:
	rm firmware.hex
	rm -rf .Xil/ synth_*.log webtalk.jou synth_system.v 
	rm -rf synth_*.mmi synth_*.bit xsim[._]* xvlog.*
	rm -rf webtalk.log webtalk_*.jou webtalk_*.log xelab.* *.html *.xml


