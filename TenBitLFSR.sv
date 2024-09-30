// 10 bit LFSR to create semi-random numbers

module TenBitLFSR (Q, clk, reset); 
	output reg [9:0] Q;
	input logic clk, reset;
	wire feedback;

	assign feedback = (Q[3] ~^ Q[0]);

	always_ff @(posedge clk) begin

		if (reset)
			Q <= 10'b0000000000;

		else
			Q <= {feedback, Q[9:1]};
	end
endmodule

module TenBitLFSR_testbench();
	logic [10:1] Q;
	logic clk, reset, xnor_bits;
	
	TenBitLFSR dut(.Q, .clk, .reset);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk; // forever toggle the clock
	end
	
	initial begin
	
												@(posedge clk);
		reset <= 1; 						@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		reset <= 0;							@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		$stop;
	end
endmodule

												

