module ALUMUX_2to1 (din_0, din_1, sel, out); // MUX for 32-bit input & output
input [31:0] din_0, din_1;
input sel;
output reg [31:0] out;
always @(*)
begin
if (!sel)
out = din_0;
else if (sel)
out = din_1;
else
out = 31'h00000000;
end
endmodule
