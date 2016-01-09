`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:21:49 12/19/2015 
// Design Name: 
// Module Name:    PipelinedForwardingUnit 
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
module ForwardingUnit(UseShamt, UseImmed, ID_Rs, ID_Rt, EX_Rw, MEM_Rw, EX_RegWrite, MEM_RegWrite,
										AluOpCtrlA_IDEX, AluOpCtrlB_IDEX, 
										DataMemForwardCtrl_EX_IDEX, DataMemForwardCtrl_MEM_IDEX );
	input UseShamt, UseImmed;
	input [4:0] ID_Rs, ID_Rt, EX_Rw, MEM_Rw;
	input EX_RegWrite, MEM_RegWrite;
	output wire[1:0] AluOpCtrlA_IDEX, AluOpCtrlB_IDEX;
	output wire DataMemForwardCtrl_EX_IDEX, DataMemForwardCtrl_MEM_IDEX;
	
	assign AluOpCtrlA_IDEX = UseShamt ? 2'b00 : 
									(ID_Rs != 5'b00000 && (ID_Rs == EX_Rw) && EX_RegWrite) ? 2'b10 :
									(ID_Rs != 5'b00000 && (ID_Rs == MEM_Rw) && MEM_RegWrite) ? 2'b01 : 
									2'b11;
	assign AluOpCtrlB_IDEX = UseImmed ? 2'b00 :
									 ((ID_Rt == EX_Rw) && EX_RegWrite) ? 2'b10 :
									 ((ID_Rt == MEM_Rw) && MEM_RegWrite) ? 2'b01 : 
									 2'b11;
	// need 2 step previous(previous previous) to forward RegWriteData to EX stage								 
	assign DataMemForwardCtrl_EX_IDEX = (ID_Rt == MEM_Rw) ? 1 : 0;
	// need 1 step previous(just before) to forward RegWriteData to MEM stage
	assign DataMemForwardCtrl_MEM_IDEX = (ID_Rt == EX_Rw) ? 1 : 0;

endmodule
