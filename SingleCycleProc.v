`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:29:56 10/21/2015 
// Design Name: 
// Module Name:    SingleCycleProc 
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
// MIPS processor main block
// inputs are CLK, Reset_L, startPC
// output is dMemOut from data memory
module SingleCycleProc(CLK, Reset_L, startPC, dMemOut);
	input CLK;
	input Reset_L;
	input [31:0] startPC;
	output wire [31:0] dMemOut;
	reg [31:0] PC;

// wire to instruction from instruction memory
	wire [31:0] inst;
// mux for two inputs to ALU
	wire [31:0] ALUMux1, ALUMux2;
// wires to connect each modules
	wire [31:0] BusA, BusB, BusW, ReadData, ALUO, SignExtender;
	wire [4:0] RW, RA, RB, RWINST, SHMTINST;
	wire Zero, BranchCtrlO;
	wire RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite;
	wire MemRead, MemWrite, Branch, Jump, SignExtend;
	wire [3:0] ALUOp, ALUCtrl;
	wire [31:0] SHMT, JumpIn1;
	wire [5:0] Opcode, FuncCode;
	wire [15:0] SignExtenderInst;
	wire [31:0] BranchIn0, BranchIn1, BranchO;
	
// Instruction Memory module instantiation	
	InstructionMemory IM(inst, PC);
// wire connections between modules	
	assign Opcode = inst[31:26];
	assign RA = inst[25:21];
	assign RB = inst[20:16];
	assign RWINST = inst[15:11];
	assign SHMTINST = inst[10:6];
	assign SignExtenderInst = inst[15:0];
	assign SHMT = {27'b0, SHMTINST};
	assign FuncCode = inst[5:0];
// output wire connection from data memory	
	assign dMemOut = ReadData;

// SingleCycleController instantiation	
	SingleCycleControl scctrl(RegDst, ALUSrc1,ALUSrc2, MemToReg, RegWrite,
//									MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode);
								MemRead, MemWrite, Branch, Jump, SignExtend, ALUOp, Opcode, FuncCode);
	 
// RegisterFile instatiation	
	RegisterFile rf(BusA, BusB, BusW, RA, RB, RW, RegWrite, CLK);
// ALU instantiation	
	ALU alu(ALUO, Zero, ALUMux1, ALUMux2, ALUCtrl);
// Datamemory instantiation
//	DataMemory dm(ReadData, ALUO, BusB, MemRead, MemWrite, CLK);
	DataMemory_w dm(ReadData, ALUO, BusB, MemRead, MemWrite, CLK);
// ALU controller instantiation
	ALUControl aluctrl(ALUCtrl, ALUOp, FuncCode);
	
	// muxer before regfile triggered by RegDst
	assign RW = RegDst == 0 ? RB : RWINST;
	// muxer before ALU tirggered by ALUSrc1
	assign ALUMux1 = ALUSrc1 == 0 ? BusA : SHMT;
	// muxer before ALU tirggered by ALUSrc2
	assign ALUMux2 = ALUSrc2 == 0 ? BusB : SignExtender;
	// writeback muxer
	assign BusW = MemToReg == 0 ? ALUO : ReadData;
	
	// increment by 4 or reset PC
	always @(negedge CLK or negedge Reset_L) begin
		if(Reset_L == 0) begin
		// if reset signal is asserted, reset PC to startPC
			PC <= startPC;
		end else begin
		// PC could be increment by 4 or branch address or jump address
			PC <= Jump == 0 ? BranchO : JumpIn1;
		end
	end
	
	// branch ctrl
	// connect sign extender wire
	assign SignExtender = SignExtend == 1 ? {{16{SignExtenderInst[15]}}, SignExtenderInst} : {16'b0, SignExtenderInst};
	// generate branchctrol out signal 
	and BranchAnd(BranchCtrlO, Branch, Zero);
	// two branch In signal to the muxer
	assign BranchIn1 = (SignExtender<<2) + (PC+4);
	assign BranchIn0 = PC+4;
	// connect jump wire to jump address
	assign JumpIn1 = {PC[31:28],{inst[25:0]},2'b0};
	assign BranchO = BranchCtrlO == 0 ? BranchIn0 : BranchIn1;

endmodule
