module MUX_3to1 (din_0, din_1, din_2, sel, out);
input [31:0] din_0, din_1, din_2;
input [1:0] sel;
output reg [31:0] out;
always @(*)
begin
if (sel == 2'b00)
out = din_0;
else if (sel == 2'b01)
out = din_1;
else if (sel == 2'b10)
out = din_2;
else 
out = 31'h00000000;
end
endmodule
