`timescale 1 ns / 1 ps

/* verilator lint_off PINMISSING */

module system (
	input           clk,
	output [8:0] 	io,

    output          heartbeat_led
);

// 4096 32bit words = 16kB memory
	parameter MEM_SIZE = 4096;

// Firmware file
	parameter HEX_FILE = "firmware.hex";


// Startup reset
    startup_reset RESET(
        .clk        (clk),
        .resetn     (resetn)
    );


// Heartbeat LED
    heartbeat #(
        .DIVIDE(24)
    ) Heart (
        .clk        (clk),
        .resetn     (resetn),

        .trap       (trap),

        .heartbeat_led   (heartbeat_led)
    );


// Mem bus wires
	wire mem_valid;
	wire [31:0] mem_addr;
	wire [31:0] mem_wdata;
	wire [3:0] mem_wstrb;

	wire mem_ready;
	wire [31:0] mem_rdata;


// picorv32 core
	picorv32 picorv32_core (
		.clk         (clk         ),
		.resetn      (resetn      ),
		.trap        (trap        ),

		.mem_valid   (mem_valid   ),	// out - High during transfer
		.mem_ready   (mem_ready   ),	// in  - ack of write or read

		.mem_addr    (mem_addr    ),	// out - 32 bit address
		.mem_wdata   (mem_wdata   ),	// out - 32 bit write data
		.mem_wstrb   (mem_wstrb   ),	// out - 4 bit octal select
		.mem_rdata   (mem_rdata   )		// in  - 32 bit read data
	);


// RAM
	wire ram_ready;
	wire [31:0] ram_rdata;

	wire ram_valid;
	
	ram #(
        .HEX_FILE(HEX_FILE)
    ) RAM (
		.clk			(clk),
		.resetn			(resetn),

		.ram_valid		(ram_valid),

		.ram_addr		(mem_addr),
		.ram_wdata		(mem_wdata),
		.ram_wstrb		(mem_wstrb),

		.ram_ready		(ram_ready),
		.ram_rdata		(ram_rdata)
	);


// IO
	wire io_ready;
	wire [31:0] io_rdata;

	wire io_valid;

	io IO (
		.clk			(clk),
		.resetn			(resetn),

		.io_valid		(io_valid),

		.io_addr		(mem_addr),
		.io_wdata		(mem_wdata),
		.io_wstrb		(mem_wstrb),

		.io_ready		(io_ready),
		.io_rdata		(io_rdata),

		.io_output		(io)
	);


// BUS mux

	// Mux valid, Core -> RAM
    assign ram_valid    = (mem_valid && (mem_addr[31:28] == 4'h0)) ? 1 : 0;
    assign io_valid     = (mem_valid && (mem_addr[31:28] == 4'h1)) ? 1 : 0;
    assign uart_valid   = (mem_valid && (mem_addr[31:28] == 4'h2)) ? 1 : 0;

    // Mux data, RAM -> Core
    assign mem_ready  = (mem_addr[31:28] == 4'h0) ? ram_ready  :
                        (mem_addr[31:28] == 4'h1) ? io_ready   : 1'b0;

    assign mem_rdata  = (mem_addr[31:28] == 4'h0) ? ram_rdata  :
                        (mem_addr[31:28] == 4'h1) ? io_rdata   : 32'b0;


endmodule

