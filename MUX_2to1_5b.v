module MUX_2to1_5b(din_0, din_1, sel, out);
// MUX for 5-bit input & output
input [4:0] din_0, din_1;
input sel;
output [4:0] out;
assign out = (sel) ? din_1 : din_0;
endmodule

