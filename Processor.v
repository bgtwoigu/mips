`timescale 1ns/1ps
`default_nettype none

module Processor(CLK, Reset_L, startPC, exceptAddr, dMemOut, Cause, EPC);
	input wire CLK;
	input wire Reset_L;
	input wire [31:0] startPC;
	input wire [31:0] exceptAddr;
	output wire [31:0] dMemOut;
	wire [31:0] PC;
	output wire [31:0] Cause;
	output wire [31:0] EPC;

	/* intermediate interconnections */
	wire [31:0] Instruction;
	wire CacheHit;
	wire DataValid, ROMread;
	wire [31:0] ROMdata, ROMaddr;

	/* instantiate instruction cache */
	InstructionCache instrCache (
		.MemRead(ROMread),
		.MemReadAddr(ROMaddr),
		.Instruction (Instruction),
		.Hit(CacheHit),
		.InstrAddr(PC),
		.DataValid(DataValid),
		.DataIn(ROMdata),
		.CLK(CLK),
		.Reset_L(Reset_L)
	);
	/* instantiate ROM controller */
	ROMCtrl ROMcontroller(
		.DataValid(DataValid),
		.DataOut(ROMdata),
		.MemRead(ROMread),
		.MemAddr(ROMaddr),
		.CLK(CLK),
		.Reset_L(Reset_L)
	);
	/* instantiate MIPS processor core */
	MipsCoreProc core0(
		.currentPC(PC),
		.Cause(Cause),
		.EPC(EPC),
		.dMemOut(dMemOut),
		.startPC(startPC),
		.CacheMiss(~CacheHit),
		.exceptAddr(exceptAddr),
		.currentInstruction(Instruction),
		.CLK(CLK),
		.Reset_L(Reset_L)
	);
endmodule
