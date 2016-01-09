module MUX_2to1(din_0, din_1, sel, out);
input [4:0] din_0, din_1;
input sel;
output [4:0] out;
assign out = (sel) ? din_1 : din_0; // Check sel and select inputs!
endmodule
