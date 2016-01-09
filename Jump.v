module Jump(PC4, JumpAddr, PC_Jump);
input [31:0] PC4;
input [25:0] JumpAddr;
output [31:0] PC_Jump;
assign PC_Jump = {PC4[31:28],JumpAddr[25:0],2'b00}; // Target address calculation
endmodule

