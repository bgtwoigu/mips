`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:53:16 09/29/2015 
// Design Name: 
// Module Name:    DataMemory 
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
module DataMemory_w(ReadData, Address, WriteData, MemoryRead, MemoryWrite, Clock);
	output [31:0] ReadData;
	input [5:0] Address; // word address
	input [31:0] WriteData;
	input MemoryRead, MemoryWrite, Clock;
	
	reg [31:0] Mem[0:63];
	reg [31:0] ReadData;
	
	// read
	always @(posedge Clock) begin
		if(MemoryRead) begin
			ReadData <= Mem[Address];
		end
	end
	
	//write
	always @(negedge Clock) begin
		if(MemoryWrite) begin
			Mem[Address] <= WriteData;
		end
	end
endmodule
