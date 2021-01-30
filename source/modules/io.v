module io #
(
    parameter MEM_SIZE = 4096,
    parameter HEX_FILE = "firmware.hex"
) 
(
	input 			clk,
	input 			resetn,

	input 			io_valid,
	input [31:0] 	io_addr,
	input [31:0]	io_wdata,
	input [3:0]		io_wstrb,

	output reg 			io_ready,
	output reg [31:0]	io_rdata,

    output reg [31:0] io_output
);
  

// RAM operations
	always @(posedge clk) begin
		io_ready <= 0;

		if (resetn && io_valid && !io_ready) begin

			// Read operation
			if(!(|io_wstrb)) begin
				io_rdata <= io_output;
				io_ready <= 1;
			end

			// Write operation
			if(|io_wstrb) begin
				io_output <= io_wdata;
				io_ready <= 1;
			end

		end

	end

endmodule