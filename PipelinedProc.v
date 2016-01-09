`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:42:15 04/01/2008 
// Design Name: 
// Module Name:    Pipelined 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define RTYPEOPCODE 		6'b000000
`define LWOPCODE 			6'b100011
`define SWOPCODE 			6'b101011
`define BEQOPCODE 		6'b000100
`define JOPCODE 			6'b000010
`define ORIOPCODE 		6'b001101
`define ADDIOPCODE 		6'b001000
`define ADDIUOPCODE 		6'b001001
`define ANDIOPCODE 		6'b001100
`define LUIOPCODE 		6'b001111
`define SLTIOPCODE 		6'b001010
`define SLTIUOPCODE 		6'b001011
`define XORIOPCODE 		6'b001110	

module PipelinedProc(CLK, Reset_L, startPC, dMemOut);
	input CLK;
	input Reset_L;
	input [31:0] startPC;
	output [31:0] dMemOut;

	//Stage 1
	wire [1:0] addrSel;
	wire	[31:0]	currentPCPlus4;
	wire	[31:0]	nextPC;
	reg	[31:0]	currentPC;
	wire	[31:0]	currentInstruction;
	 
	//Stage 2
	reg	[31:0] IFID_currentPCPlus4, Instruction2;
	wire	[5:0]	opcode;
	wire	[4:0]	rs, rt, rd;
	wire	[15:0]	imm16;
	wire	[4:0]	shamt;
	wire	[5:0]	func;
	wire	[31:0]	busA, busB, signExtImm;
	wire	[31:0]	jumpTarget;
	//Hazard
	wire Bubble;
	wire PCWrite;
	wire IFWrite;
	
	//Stage 2 Control Wires
	wire [1:0] ID_AluOpCtrlA, ID_AluOpCtrlB;
	wire ID_DataMemForwardCtrl_EX, ID_DataMemForwardCtrl_MEM;
	wire	regDst, memToReg, regWrite, memRead, memWrite, branch, jump, signExtend;
	wire	UseShiftField, UseImmed;
	wire	rsUsed, rtUsed;
	wire	[4:0]	rw;
	wire	[3:0]	aluOp;
	wire	[31:0]	ALUBIn;
	wire	[31:0]	ALUAIn;
	wire	[31:0]	branchDst;
// debugging purpose
//	reg	[31:0] Instruction3, Instruction4, Instruction5;
	
	//Stage 3
	reg	[31:0] IDEX_busA, IDEX_busB, signExtImm3;
	reg	[4:0]	rw3, rt3, shamt3;
	wire	[4:0] EX_Rw;
	reg 	IDEX_DataMemForwardCtrl_EX, IDEX_DataMemForwardCtrl_MEM;
	reg	[1:0] IDEX_AluOpCtrlA, IDEX_AluOpCtrlB;
	wire	[5:0]	func3;
	wire	[31:0]	busB3;
	reg	[31:0]	branchDst3;
	wire	[3:0]	aluCtrl;
	wire	aluZero;
	wire	[31:0]	aluOut;
	reg	regWrite3;
	//Stage 3 Control
	reg	regDst3, memToReg3, memRead3, memWrite3;
	reg	[3:0]	aluOp3;
	
	//Stage 4
	reg 	EXMEM_DataMemForwardCtrl_MEM;
	reg	[31:0] EXMEM_busB, aluOut4;
	reg	[4:0]	rw4;
	
	wire	[31:0]	busB4, memOut;
	
	assign dMemOut = memOut;
	
	//Stage 4 Control
	reg memToReg4, regWrite4, memRead4, memWrite4;
	
	//Stage 5
	reg	[31:0]	memOut5, aluOut5;
	reg	[4:0]	rw5;
	wire	[31:0]	regWriteData;
	
	//Stage 5 Control
	reg memToReg5, regWrite5;
	
	
	//Stage 1 state(context)
	/*Below is a special case.  If we are doing a jump, and IFWrite is set to true,
	then we have completed the jump. That means we are not jumping anymore.
	Same is true of a branch that we just took.
	*/
	assign nextPC = (addrSel == 2'b00) ? currentPCPlus4 : (addrSel == 2'b01) ? jumpTarget : branchDst3;

	always @ (negedge CLK) begin
		if(~Reset_L)
			currentPC = startPC;
		else if(PCWrite)
			currentPC = nextPC;
	end
	assign currentPCPlus4 = currentPC + 4;
	InstructionMemory instrMemory(currentInstruction, currentPC);
	
	//Stage 2 state(context)
	/* IFID pipeline register */
	always @(negedge CLK or negedge Reset_L) begin
		if(~Reset_L) Instruction2 <= 32'b0;
		else if(IFWrite) begin
			Instruction2 <= currentInstruction;
			IFID_currentPCPlus4 <= currentPCPlus4;
		end 
	end
	
	assign {opcode, rs, rt, rd, shamt, func} = Instruction2;
	assign imm16 = Instruction2[15:0];
	
	PipelinedControl controller(regDst, memToReg, regWrite, memRead, memWrite, 
										branch, jump, signExtend, aluOp, opcode);
	assign rw = regDst ? rd : rt;
	assign UseShiftField = ((aluOp == 4'b1111) && ((func == 6'b000000) || (func == 6'b000010) || (func == 6'b000011)));
	assign rsUsed = (opcode != 6'b001111/*LUI*/) & ~UseShiftField;
	assign rtUsed = (opcode == 6'b0) || branch || (opcode == 6'b101011/*SW*/);

	assign UseImmed = ((opcode==`LWOPCODE) ||(opcode==`SWOPCODE) ||(opcode==`ORIOPCODE) 
						|| (opcode==`ADDIOPCODE) || (opcode==`ADDIUOPCODE) || (opcode==`ANDIOPCODE)
						|| (opcode==`LUIOPCODE) || (opcode==`SLTIOPCODE) || (opcode==`SLTIUOPCODE)
						|| (opcode==`XORIOPCODE)) ? 1 : 0;
	 
	ForwardingUnit forward(UseShiftField, UseImmed, rs, rt, rw3, rw4, regWrite3, regWrite4,
								ID_AluOpCtrlA, ID_AluOpCtrlB, 
								ID_DataMemForwardCtrl_EX, ID_DataMemForwardCtrl_MEM);
								
	HazardUnit hazard(IFWrite, PCWrite, Bubble, addrSel, jump, branch, aluZero, memRead3,
			rsUsed ? rs : 5'b0,	
			rtUsed ? rt : 5'b0, 
			regWrite ? rt3 : 5'b0,
			UseShiftField, signExtend,	CLK, Reset_L);
			
	PipelinedRegisterFile Registers(busA, busB, regWriteData, rs, rt, rw5, regWrite5, CLK);
	SignExtender immExt(signExtImm, imm16, signExtend);
	assign branchDst = IFID_currentPCPlus4 + {signExtImm[29:0],2'b00};
	assign jumpTarget = {currentPC[31:28], Instruction2[25:0], 2'b00};

	//Stage 3 state(context)
	/* IDEX pipeline register */
	always @ (negedge CLK or negedge Reset_L) begin
		if(~Reset_L) begin
			IDEX_busA <= 0;
			IDEX_busB <= 0;
			signExtImm3 <= 0;
			shamt3 <= 0;
			rw3 <= 0;
			rt3 <= 0;
			regDst3 <= 0;
			memToReg3 <= 0;
			memRead3 <= 0;
			memWrite3 <= 0;
			aluOp3 <= 0;
			IDEX_DataMemForwardCtrl_EX <= 0;
			IDEX_DataMemForwardCtrl_MEM <= 0;
			IDEX_AluOpCtrlA <= 0;
			IDEX_AluOpCtrlB <= 0;
			branchDst3 <= 0;
			regWrite3 <= 0;
//			Instruction3 <= 0;
		end else if(Bubble) begin
			IDEX_busA <= 0;
			IDEX_busB <= 0;
			signExtImm3 <= 0;
			shamt3 <= 0;
			rw3 <= 0;
			rt3 <= 0;
			regDst3 <= 0;
			memToReg3 <= 0;
			memRead3 <= 0;
			memWrite3 <= 0;
			aluOp3 <= 0;
			IDEX_DataMemForwardCtrl_EX <= 0;
			IDEX_DataMemForwardCtrl_MEM <= 0;
			IDEX_AluOpCtrlA <= 0;
			IDEX_AluOpCtrlB <= 0;
			branchDst3 <= 0;
			regWrite3 <= 0;
//			Instruction3 <= 0;
		end else begin
			IDEX_busA <= busA;
			IDEX_busB <= busB;
			signExtImm3 <= signExtImm;
			shamt3 <= shamt;
			rw3 <= rw;
			rt3 <= rt;
			regDst3 <= regDst;
			memToReg3 <= memToReg;
			memRead3 <= memRead;
			memWrite3 <= memWrite;
			aluOp3 <= aluOp;
			IDEX_DataMemForwardCtrl_EX <= ID_DataMemForwardCtrl_EX;
			IDEX_DataMemForwardCtrl_MEM <= ID_DataMemForwardCtrl_MEM;
			IDEX_AluOpCtrlA <= ID_AluOpCtrlA;
			IDEX_AluOpCtrlB <= ID_AluOpCtrlB;
			branchDst3 <= branchDst;
			regWrite3 <= regWrite;
//			Instruction3 <= Instruction2;
		end 
	end
	
	assign ALUAIn = (IDEX_AluOpCtrlA == 2'b00) ? signExtImm3[10:6] :  /*shamt3*/
							 (IDEX_AluOpCtrlA == 2'b01) ? regWriteData :
							 (IDEX_AluOpCtrlA == 2'b10) ? aluOut4 : IDEX_busA;
							 
	assign ALUBIn = (IDEX_AluOpCtrlB == 2'b00) ? signExtImm3 : 
							 (IDEX_AluOpCtrlB == 2'b01) ? regWriteData :
							 (IDEX_AluOpCtrlB == 2'b10) ? aluOut4 : IDEX_busB;
							 
	assign EX_Rw = (regDst3 == 1) ? rw3 : rt3;
	assign busB3 = IDEX_DataMemForwardCtrl_EX ? regWriteData : IDEX_busB;
	assign func3 = signExtImm3[5:0];
	PipelinedALUControl mainALUControl(aluCtrl, aluOp3, func3);
	PipelinedALU mainALU(aluOut, aluZero, ALUAIn, ALUBIn, aluCtrl);

	//Stage 4 state(context)
	// EXMEM pipeline register
	always @ (negedge CLK or negedge Reset_L) begin
		if(~Reset_L) begin
			aluOut4 <= 0;
			EXMEM_busB <= 0;
			EXMEM_DataMemForwardCtrl_MEM <= 0;
			rw4 <= 0;
			memToReg4 <= 0;
			regWrite4 <= 0;
			memRead4 <= 0;
			memWrite4 <= 0;
//			Instruction4 <= 0;
		end
		else begin
			aluOut4 <= aluOut;
			EXMEM_busB <= busB3;
			EXMEM_DataMemForwardCtrl_MEM <= IDEX_DataMemForwardCtrl_MEM;
			rw4 <= EX_Rw;
			memToReg4 <= memToReg3;
			regWrite4 <= regWrite3;
			memRead4 <= memRead3;
			memWrite4 <= memWrite3;
//			Instruction4 <= Instruction3;
		end
	end
	
	assign busB4 = EXMEM_DataMemForwardCtrl_MEM ? regWriteData : EXMEM_busB;
	PipelinedDataMemory dmem(memOut, aluOut4, busB4, memRead4, memWrite4, CLK);
	
	//Stage 5 state(context)
	always @ (negedge CLK or negedge Reset_L) begin
		if(~Reset_L) begin
			memOut5 <= 0;
			aluOut5 <= 0;
			rw5 <= 0;
			memToReg5 <= 0;
			regWrite5 <= 0;
//			Instruction5 <= 0;
		end
		else begin
			memOut5 <= memOut;
			aluOut5 <= aluOut4;
			rw5 <= rw4;
			memToReg5 <= memToReg4;
			regWrite5 <= regWrite4;
//			Instruction5 <= Instruction4;
		end
	end
	assign regWriteData = memToReg5 ? memOut5 : aluOut5;
endmodule
