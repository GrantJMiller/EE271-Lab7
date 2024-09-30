
// module to control who wins the tug-o-war game
// Counter increments by 1 until 7 points is reached

module winner (nextRound, HEX5, HEX0, clk, reset, L, R, LED9, LED1);
	input logic clk, reset, L, R, LED9, LED1;
	output logic [6:0] HEX5, HEX0;
	output logic nextRound;
	
	logic [2:0] P1count;
	logic [2:0] P2count;
	
	enum {off, player1, player2} ps, ns;
	
	always_comb begin
		case(ps)
			off: if(L & ~R & LED9) ns = player2;
				  else if(~L & R & LED1) ns = player1;
				  else ns = off;
							
			player1: ns = player1; 
			player2: ns = player2; 
			
		endcase
		
		// Logic to display the player scores
		
				if(P1count == 3'b000) 		
					HEX0 = 7'b1000000;
				else if(P1count == 3'b001)	
					HEX0 = 7'b1111001;
				else if(P1count == 3'b010)		
					HEX0 = 7'b0100100;
				else if(P1count == 3'b011)		
					HEX0 = 7'b0110000;
				else if(P1count == 3'b100)	
					HEX0 = 7'b0011001;
				else if(P1count == 3'b101)	
					HEX0 = 7'b0010010;
				else if(P1count == 3'b110)		
					HEX0 = 7'b0000010;
				else 									
					HEX0 = 7'b1111000;
		
				if(P2count == 3'b000) 		
					HEX5 = 7'b1000000;
				else if(P2count == 3'b001)		
					HEX5 = 7'b1111001;
				else if(P2count == 3'b010)		
					HEX5 = 7'b0100100;
				else if(P2count == 3'b011)		
					HEX5 = 7'b0110000;
				else if(P2count == 3'b100)		
					HEX5 = 7'b0011001;
				else if(P2count == 3'b101)		
					HEX5 = 7'b0010010;
				else if(P2count == 3'b110)		
					HEX5 = 7'b0000010;
				else 								
					HEX5 = 7'b1111000;
	end
	
	always_ff @(posedge clk) begin
		if(ps == off & ns == player1) begin
			P1count <= P1count + 1;
		end
		else if(ps == off & ns == player2) begin
			P2count <= P2count + 1;
		end
		else begin
			P1count <= P1count;
			P2count <= P2count;
		end
		
		if(reset) begin
			ps <= off;
			nextRound <= 0;
			P1count <= 3'b000;
			P2count <= 3'b000;
		end
		else if(nextRound) begin
				nextRound <= 0;
				ps <= off;
		end
		else
			ps <= ns;
			
		if(ps != off)
			nextRound <= 1;
		else
			nextRound <= 0;
	end
	
endmodule

module winner_testbench();
	logic clk, reset, L, R, LED9, LED1;
	logic [6:0] HEX5, HEX0;
	logic nextRound;
	
	winner dut (.nextRound, .HEX5(HEX5), .HEX0(HEX0), .clk, .reset, .L, .R, .LED9, .LED1);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) clk <= ~clk; // forever toggle the clock
	end
	
	initial begin
		reset <= 1;										@(posedge clk);
															@(posedge clk);
		reset <= 0;										@(posedge clk);
															@(posedge clk);
		LED9 <= 1; LED1 <= 0; L <= 1; R <= 0;	@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 1;						@(posedge clk);
															@(posedge clk);
		LED9 <= 1; LED1 <= 1;						@(posedge clk);
															@(posedge clk);
					  LED1 <= 0; 			R <= 1;  @(posedge clk);
															@(posedge clk);
		reset <= 1;		       L <= 0;				@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 1; 						@(posedge clk);
															@(posedge clk);
		reset <= 0;										@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 1; L <= 1; R <= 0;	@(posedge clk);
															@(posedge clk);
		LED9 <= 1;				 						@(posedge clk);
															@(posedge clk);
		LED9 <= 0; LED1 <= 0; L <= 0;	R <= 1;	@(posedge clk);
															@(posedge clk);
		LED9 <= 1; 										@(posedge clk);
															@(posedge clk);
		LED9 <= 0;										@(posedge clk);
		$stop;
	end
endmodule