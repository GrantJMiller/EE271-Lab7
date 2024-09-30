// module to make sure ouput of user input is true for only one clock cycle
// when button is pressed

module userInput(out, clk, reset, button);
	
	input logic clk, reset, button;
	output logic out;
	
	enum {on, off} ps, ns;
	
	always_comb begin
		case(ps)
		
			on: if(button) ns = on;
					else ns = off;
				
			off: if(button) ns = on;
					else ns = off;
			
		endcase
	end
	
	assign out = (ns == off & ps == on);
	
	always_ff @(posedge clk) begin
		if(reset) 
			ps <= off;
		else
			ps <= ns;
	end
endmodule


module userInput_testbench();

	logic clk, reset;
	logic button;
	logic out;
	
	userInput dut (.out, .clk, .reset, .button);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk; // forever toggle the clock
	end
	
	initial begin
		reset <= 1;						@(posedge clk);
											@(posedge clk);
		reset <= 0;						@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
		reset <= 1;						@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
		reset <= 0;						@(posedge clk);
		        					      @(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 0; 					@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		button <= 1;					@(posedge clk);
											@(posedge clk);
		button <= 0;					@(posedge clk);
		$stop;
	end
endmodule 