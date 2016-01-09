module PipeReg_EXMEM(MemtoReg_EXMEM, RegWrite_EXMEM, MemRead_EXMEM, MemWrite_EXMEM, DataMemory_EXMEM, ALUOut_EXMEM, MEM_data_EXMEM, MEM_Rw,
MemtoReg_IDEX, RegWrite_IDEX, MemRead_IDEX, MemWrite_IDEX, DataMemory_IDEX, CLK, ALUOut, MEM_data, EX_Rw);

output reg [4:0] MEM_Rw;
output reg [31:0] ALUOut_EXMEM, MEM_data_EXMEM;
output reg MemtoReg_EXMEM, RegWrite_EXMEM, MemRead_EXMEM, MemWrite_EXMEM, DataMemory_EXMEM;

input [31:0] ALUOut, MEM_data;  //Data
input [4:0] EX_Rw;
input MemtoReg_IDEX, RegWrite_IDEX, MemRead_IDEX, MemWrite_IDEX, DataMemory_IDEX, CLK; //Control signals

always @(negedge CLK) begin
	ALUOut_EXMEM = ALUOut; 
	MEM_data_EXMEM = MEM_data;
	MEM_Rw = EX_Rw;
	MemRead_EXMEM = MemRead_IDEX; 
	MemWrite_EXMEM = MemWrite_IDEX;
	MemtoReg_EXMEM = MemtoReg_IDEX; 
	RegWrite_EXMEM = RegWrite_IDEX; 
	DataMemory_EXMEM = DataMemory_IDEX;
end
endmodule
