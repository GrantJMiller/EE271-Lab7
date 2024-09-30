
// Module that returns true if A is greater than B and false otherwise

module comparator (out, clk, reset, A, B);
	output logic out;
	input logic clk, reset;
	input logic [9:0] A, B;
	
	logic [10:0] subtract; // Increased width to capture possible carry out
   logic true_or_false;

   always_comb begin
      subtract = {1'b0, A} - {1'b0, B};
      true_or_false = ~subtract[10]; // Check MSB of the 11-bit result (0 if A > B, 1 if A <= B)
   end
	 
	always_ff @(posedge clk) begin
		out <= true_or_false;
	end
endmodule 


module comparator_testbench();
	logic [9:0] A, B;
	logic clk, reset;
	logic out;
	
	comparator dut (.out, .clk, .reset, .A, .B);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk; // forever toggle the clock
	end
	
	initial begin
	
																			@(posedge clk);
		A = 10'b1001000100; B = 10'b0000011011;				@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
		A = 10'b0000001110;   										@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
								  B = 10'b0000000011;			   @(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);
																			@(posedge clk);																	
		$stop;
	end
endmodule
	
	