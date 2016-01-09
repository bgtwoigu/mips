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
module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, clk);
	/* definition input, output pins */
	output [31:0] BusA, BusB;
	input [31:0] BusW;
	input [4:0] RA, RB, RW;
	input RegWr, clk;
	/* 32X32 register definition */
	reg [31:0] regs [31:1];
	/* register is wired */
	wire [31:0] r0;
	wire [31:0] BusA, BusB;

	/* register 0 is always 0 */
	assign r0 = 32'b0;

	/* synchronous with negedge of the clock 
	to write to RegWr address */
	always @(negedge clk) begin
		/* need to be enabled by RegWr and
			R0 is not writable */
		if(RegWr && RW) begin
			/* write to register[address], 
			RW is the address */
			regs[RW] <= BusW;
		end
	end
	
	/* Two Read register is done at the same time 
	   i.e. ADD R1, R2, R3. This operation need 
		two read access simultaneously */
	assign BusA = RA ? regs[RA] : r0;
	assign BusB = RB ? regs[RB] : r0;
endmodule
