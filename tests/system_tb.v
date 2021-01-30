`timescale 1 ns / 1 ps

module system_tb;
	reg clk = 1;
	always #5 clk = ~clk;

	reg resetn = 0;
	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end

	wire [7:0] io;

	system uut (
		.clk        (clk  ),
		.io         (io   )
	);

endmodule
