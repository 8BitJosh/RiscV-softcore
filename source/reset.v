module startup_reset (
    input       clk,
    output      resetn
);

    reg [5:0] reset_cnt = 0;
	assign resetn = &reset_cnt;

	always @(posedge clk) begin
		reset_cnt <= reset_cnt + {5'd0, !resetn};
	end

endmodule