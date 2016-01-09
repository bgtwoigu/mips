`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:32:52 11/10/2015 
// Design Name: 
// Module Name:    EXMEM 
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
module EXMEM(WB_EXMEM, M_EXMEM, Address_EXMEM, Data_EXMEM, rw_EXMEM, ForwardCtrl_EXMEM,
					WB_IDEX, M_IDEX, Address_IDEX, busB3, rw3, ForwardCtrl_IDEX, CLK);
	output reg WB_EXMEM, M_EXMEM, ForwardCtrl_EXMEM;
	output reg [5:0] Address_EXMEM;
	output reg [31:0] Data_EXMEM;
	output reg [4:0] rw_EXMEM;
	input WB_IDEX, M_IDEX, ForwardCtrl_IDEX, CLK;
	input [31:0] Address_IDEX, busB3;
	input [4:0] rw3;
 	
	always @(negedge CLK) begin
		WB_EXMEM <= WB_IDEX;
		M_EXMEM <= M_IDEX;
		Address_EXMEM <= Address_IDEX;
		Data_EXMEM <= busB3;
		rw_EXMEM <= rw3;
		ForwardCtrl_EXMEM <= ForwardCtrl_IDEX;
	end
endmodule					