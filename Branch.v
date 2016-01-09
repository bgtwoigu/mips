module Branch(PC4, Address, PC_Branch);
input [31:0] PC4;
input [31:0] Address;  
output [31:0] PC_Branch;
assign PC_Branch = ((PC4) + (Address <<2)); // Target address calculation
endmodule

