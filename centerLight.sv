
// module to control the behavior of the center light

module centerLight (lightOn, clk, reset, L, R, NL, NR, nextRound);
	
	input logic clk, reset, L, R, NL, NR, nextRound;
	output logic lightOn;
	
	enum {on, off} ps, ns;
	
	// next state logic
	always_comb begin 
		case(ps)
			on:	if((L & ~R) | (~L & R)) ns = off;
					else ns = on; 
				 
			off: 	if((NR & L & ~R) | (NL & ~L & R)) ns = on;
					else ns = off; 
		endcase
	end
	
	//	output logic for lightOn
	assign lightOn = (ps == on);
	
	always_ff @(posedge clk) begin
		if(reset | nextRound) 
			ps <= on;
		else
			ps <= ns;
	end
endmodule


module centerLight_testbench();
	logic L, R, NL, NR, nextRound;
	logic lightOn;
	logic clk, reset; 
	
	centerLight dut (.lightOn, .clk, .reset, .L, .R, .NL, .NR, .nextRound);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk; // forever toggle the clock
	end
	
	//Set up the inputs to the design, each line is a clock cycle
	initial begin
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
		reset <= 0;									@(posedge clk)
														@(posedge clk)
		L <= 1; R <= 0; NL <= 0; NR <= 1;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
							 NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; 							@(posedge clk)
														@(posedge clk)
														@(posedge clk)
							 NL <= 0; NR <= 1; 	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
														@(posedge clk)
							 NL <= 1; NR <= 0;	@(posedge clk)
		L <= 1; 										@(posedge clk)
				  R <= 0;							@(posedge clk)
														@(posedge clk)
		reset <= 1;									@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 1; R <= 0; NL <= 0; NR <= 0;	@(posedge clk)
														@(posedge clk)
														@(posedge clk)
		L <= 0; R <= 1; NL <= 0; NR <= 0;	@(posedge clk)
														@(posedge clk)
		reset <= 0;									@(posedge clk)
														@(posedge clk)
		L <= 1; R <= 0; NL <= 1; NR <= 1;	@(posedge clk)
														@(posedge clk)
							 NL <= 0; NR <= 1;	@(posedge clk)
														@(posedge clk)
							 NL <= 1; NR <= 0;	@(posedge clk)
														@(posedge clk)
		$stop; 
	end 
endmodule 