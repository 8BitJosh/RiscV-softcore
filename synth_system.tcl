# Add Main modules
read_verilog source/system.v
read_verilog source/picorv32.v
read_verilog source/heartbeat.v
read_verilog source/reset.v
read_verilog source/ram.v

# Add Extra bus modules
read_verilog source/modules/io.v

# Read constraints
read_xdc synth_system.xdc

# Synth design
synth_design -part xc7s25-csga225-1 -top system
opt_design
place_design
route_design

# Create reports
report_utilization
report_timing

# Output bit file
write_verilog -force synth_system.v
write_bitstream -force synth_system.bit
