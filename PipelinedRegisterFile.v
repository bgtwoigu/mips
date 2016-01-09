`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:03:05 09/29/2015 
// Design Name: 
// Module Name:    RegisterFile 
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
// 32x32 Register
// BusA, BusB : 32bit-wide asynchronous read ports
// RA, RB : 5bit-wide read port address
// BusW : 32bit-wide synchronous write port
// RW : 5bit-wide write port address
// RegWr : Write enable
// Clk : clock for synchronous write at negedge
module PipelinedRegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, clk);
	/* definition input, output pins */
	output wire [31:0] BusA, BusB;
	input [31:0] BusW;
	input [4:0] RA, RB, RW;
	input RegWr, clk;
	/* 32X32 register definition */
	reg [31:0] regs [31:1];
	/* register is wired */
	//wire [31:0] r0;
	//wire [31:0] BusA, BusB;

	/* synchronous with posedge of the clock 
	to write to RegWr address */
	always @(posedge clk) begin
		/* need to be enabled by RegWr and
			R0 is not writable */
		if(RegWr && RW) begin
			/* write to register[address], 
			RW is the address */
			regs[RW] <= BusW;
		end
	end
	
	assign BusA = (RA > 0) ? regs[RA] : 32'b0;
	assign BusB = (RB > 0) ? regs[RB] : 32'b0;
/*	always @(negedge clk) begin
		if(RA > 0) BusA <= regs[RA];
		else if(RA == 0)  BusA <= 32'b0;
		if(RB > 0) BusB <= regs[RB];
		else if(RB == 0) BusB <= 32'b0;
	end
*/	
endmodule
