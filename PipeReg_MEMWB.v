module PipeReg_MEMWB(MemToReg_MEMWB, RegWrite_MEMWB, MEMout_MEMWB, ALUOut_MEMWB, Reg_in, MemtoReg_EXMEM, RegWrite_EXMEM, MEMout, ALUOut, MEM_RW, CLK);

output reg [31:0] MEMout_MEMWB, ALUOut_MEMWB;
output reg [4:0] Reg_in;
output reg MemToReg_MEMWB, RegWrite_MEMWB;

input [4:0] MEM_RW;
input [31:0] MEMout, ALUOut; //Data
input MemtoReg_EXMEM, RegWrite_EXMEM, CLK; //Control 

always @(negedge CLK) begin
	MemToReg_MEMWB = MemtoReg_EXMEM;
	RegWrite_MEMWB = RegWrite_EXMEM;
	MEMout_MEMWB = MEMout;
	ALUOut_MEMWB = ALUOut;
	Reg_in = MEM_RW;	
end

endmodule

