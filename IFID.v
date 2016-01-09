`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:54 11/10/2015 
// Design Name: 
// Module Name:    IFID 
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
module IFID(PC_4_IFID, PC_4, Data, IFWrite, CLK);
	input CLK, IFWrite;
	input [31:0] PC_4, Data;
	output reg [31:0] PC_4_IFID;

	always @(negedge CLK) begin
		if (IFWrite) begin
			PC_4_IFID = PC_4;
//			Data_IFID = Data; 
		end 	else begin
			PC_4_IFID = PC_4_IFID;
//			Data_IFID = Data_IFID; 
		end
	end
endmodule
