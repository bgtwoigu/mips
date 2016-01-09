module Adder(Y,A);
output reg [31:0] Y;
input [31:0] A;
always @(A)
	begin
	Y = A + 4; //PC+4
	end
endmodule
