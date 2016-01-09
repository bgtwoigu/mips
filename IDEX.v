`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:07 11/10/2015 
// Design Name: 
// Module Name:    IDEX 
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
module IDEX(WB_IDEX, M_IDEX, EX_IDEX, PC_4_IDEX, busA_IDEX, busB_IDEX, singExtImm_IDEX,
				currentInstruction_IDEX, ForwardCtrl_IDEX,
				memToReg, memRead, memWrite, regDst, PC_4_IFID,	busA, busB, signExtImm,
				currentInstruction,ForwardCtrl, bubble, CLK);
				
	input memToReg, memRead, memWrite, regDst, bubble;
	input [31:0] PC_4_IFID, signExtImm, busA, busB; // Data
	input CLK;	
	input [25:0] currentInstruction;
	input [5:0] ForwardCtrl;
 
	output reg WB_IDEX, M_IDEX, EX_IDEX;
	output reg [31:0] PC_4_IDEX, busA_IDEX, busB_IDEX, singExtImm_IDEX;
	output reg [25:0] currentInstruction_IDEX;
	output reg [5:0] ForwardCtrl_IDEX;	

	always @(negedge CLK) begin
		WB_IDEX <= memToReg; 
		if(memRead == 1 || memWrite == 1)
			M_IDEX <= 1;
		else M_IDEX <= 0;
		EX_IDEX <= regDst; 
		PC_4_IDEX <= PC_4_IFID;
		busA_IDEX <= busA;
		busB_IDEX <= busB; 
		singExtImm_IDEX <= signExtImm;	
		currentInstruction_IDEX <= currentInstruction; 
		ForwardCtrl_IDEX <= ForwardCtrl; 
		if (bubble) begin
			EX_IDEX <= 1'b0; 
			WB_IDEX <= 1'b0;
			M_IDEX <= 1'b0;
		end
	end	
endmodule				