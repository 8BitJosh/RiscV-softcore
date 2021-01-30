module ram #
(
    parameter MEM_SIZE = 4096,
    parameter HEX_FILE = "firmware.hex"
) 
(
	input 			clk,
	input 			resetn,

	input 			ram_valid,
	input [31:0] 	ram_addr,
	input [31:0]	ram_wdata,
	input [3:0]		ram_wstrb,

	output reg 			ram_ready,
	output reg [31:0]	ram_rdata
);
  
// RAM block
	reg [31:0] memory [0:MEM_SIZE-1];
	initial $readmemh(HEX_FILE, memory);

// RAM operations
	always @(posedge clk) begin
		ram_ready <= 0;

		if (resetn && ram_valid && !ram_ready) begin

			// Read operation
			if(!(|ram_wstrb) && (ram_addr >> 2) < MEM_SIZE) begin
				ram_rdata <= memory[ram_addr >> 2];
				ram_ready <= 1;
			end

			// Write operation
			if( |ram_wstrb && (ram_addr >> 2) < MEM_SIZE) begin
				if (ram_wstrb[0]) memory[ram_addr >> 2][ 7: 0] <= ram_wdata[ 7: 0];
				if (ram_wstrb[1]) memory[ram_addr >> 2][15: 8] <= ram_wdata[15: 8];
				if (ram_wstrb[2]) memory[ram_addr >> 2][23:16] <= ram_wdata[23:16];
				if (ram_wstrb[3]) memory[ram_addr >> 2][31:24] <= ram_wdata[31:24];
				ram_ready <= 1;
			end

		end

	end

endmodule
