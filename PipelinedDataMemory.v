`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:28:17 01/08/2016 
// Design Name: 
// Module Name:    PipelinedDataMemory 
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
module PipelinedDataMemory(ReadData, Address, WriteData, MemoryRead, MemoryWrite, Clock);
	input [31:0] Address; // 32-bits wide write bus and address
	input [31:0] WriteData; // 32-bits wide write bus and address
	input MemoryWrite, MemoryRead, Clock; // Enable signals and clock
	
	output reg [31:0] ReadData;// 32-bits wide read bus
	reg [31:0] mem [63:0];  // Memory holds 256 bytes(32bits= 4bytes, 64*4bytes=256)
	wire [5:0] wordAddr;

	assign wordAddr = Address[7:2];
	
	always @(posedge Clock) // Read on rising edge
		begin
			 if (MemoryRead == 1) // When enable signal is on
				begin
					ReadData <= mem[wordAddr]; 
				end
		end

	always @(negedge Clock) // Write on falling edge
		begin
		 if (MemoryWrite == 1) // When enable signal is on
			 begin
				mem[wordAddr] <= WriteData;
			 end
		end	
endmodule
