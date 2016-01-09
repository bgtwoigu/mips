`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:34:06 11/10/2015 
// Design Name: 
// Module Name:    MEMWB 
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
module MEMWB(WB_MEMWB, Data_MEMWB, address_MEMWB, rw_MEMWB, 
					WB_EXMEM, memOut, address_EXMEM, rw_EXMEM, CLK);
	output reg WB_MEMWB; 
	output reg [31:0] Data_MEMWB;
	output reg [5:0] address_MEMWB;
	output reg [4:0] rw_MEMWB;
	
	input WB_EXMEM, CLK;
	input [31:0] memOut;
	input [5:0] address_EXMEM;
	input [4:0] rw_EXMEM;
	
	always @(negedge CLK) begin
		WB_MEMWB <= WB_EXMEM;
		Data_MEMWB <= memOut;
		address_MEMWB <= address_EXMEM;
		rw_MEMWB <= rw_EXMEM;
	end	
endmodule