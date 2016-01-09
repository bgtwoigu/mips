module PipeReg_IDEX(RegDst, bubble, RegWrite, MemtoReg, MemRead, MemWrite, ALUOp, PC_plus4_IFID, ExtendedAddress, BusA, BusB,
AluOpCtrlA, AluOpCtrlB, DataEX, DataMemory, From_IFID, CLK, RegDst_IDEX, RegWrite_IDEX, MemRead_IDEX, MemWrite_IDEX, MemtoReg_IDEX, ALUOp_IDEX, PC_plus4_IDEX, ExtendedAddress_IDEX, 
AA_IDEX, AB_IDEX, DataEX_IDEX, DataMemory_IDEX, From_IDEX, BusA_IDEX, BusB_IDEX);

output reg [1:0] AA_IDEX, AB_IDEX;
output reg [20:0] From_IDEX;
output reg RegDst_IDEX, MemtoReg_IDEX, RegWrite_IDEX, MemRead_IDEX, MemWrite_IDEX;
output reg DataEX_IDEX, DataMemory_IDEX;
output reg [3:0] ALUOp_IDEX;
output reg [31:0] PC_plus4_IDEX, ExtendedAddress_IDEX, BusA_IDEX, BusB_IDEX;

input RegDst, MemtoReg, RegWrite, MemRead, bubble, MemWrite;
input [3:0] ALUOp; // Control
input [31:0] PC_plus4_IFID, ExtendedAddress, BusA, BusB; // Data
input [1:0] AluOpCtrlA, AluOpCtrlB;	
input DataEX, DataMemory, CLK;	
input [20:0] From_IFID;


always @(negedge CLK) begin
	PC_plus4_IDEX = PC_plus4_IFID; 
	ExtendedAddress_IDEX = ExtendedAddress; 
	BusA_IDEX = BusA; 
	BusB_IDEX = BusB;
	From_IDEX = From_IFID;
	RegDst_IDEX = RegDst; 
	ALUOp_IDEX = ALUOp;
	AA_IDEX = AluOpCtrlA; 
	AB_IDEX = AluOpCtrlB; 
	DataEX_IDEX = DataEX; 
	DataMemory_IDEX = DataMemory;
	MemtoReg_IDEX = MemtoReg;	
	RegWrite_IDEX = RegWrite; 
	MemRead_IDEX = MemRead; 
	MemWrite_IDEX = MemWrite;
	if (bubble) 
		begin
		RegDst_IDEX = 1'b0; 
		MemtoReg_IDEX = 1'b0;
		MemRead_IDEX = 1'b0; 
		MemWrite_IDEX = 1'b0;
		RegWrite_IDEX = 1'b0; 
		AA_IDEX = 2'b00; 
		AB_IDEX = 2'b00;
		DataMemory_IDEX = 1'b0;
		DataEX_IDEX = 1'b0; 
	end
end
endmodule


