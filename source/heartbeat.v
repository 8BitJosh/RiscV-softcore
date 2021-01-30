module heartbeat #(
    parameter DIVIDE = 24
)
(
    input clk,
    input resetn,

    input trap,

    output heartbeat_led
);

reg [DIVIDE-1:0] counter;

always @(posedge clk) begin
    if(!resetn)
        counter = 0;
    else
        counter = counter + 1;
end

assign heartbeat_led = trap ? 1'b0 : counter[DIVIDE-1];

endmodule