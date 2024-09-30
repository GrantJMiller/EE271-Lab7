// 2x DFF module to handle metastability

module doubleDFF (clk, reset, in, out);

input logic clk, reset;
input logic in;
output logic out;

logic out_dff1;

	always_ff @(posedge clk) begin
		out_dff1 <= in;
	end
	
	always_ff @(posedge clk) begin
		out <= out_dff1;
	end
endmodule