`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:08 01/12/2016 
// Design Name: 
// Module Name:    detectException 
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
module detectException(exception, cause, epc, pcPlus4, exceptionInst, exceptionALUCtrl, exceptionOverflow );
	input exceptionInst, exceptionALUCtrl, exceptionOverflow;
	input [31:0] pcPlus4;
	output wire [31:0] cause, epc;
	output wire exception;
	
	assign exception = (exceptionInst || exceptionALUCtrl || exceptionOverflow) ? 1 : 0;
	assign cause = (exceptionInst | exceptionALUCtrl << 1 | exceptionOverflow << 2);
	assign epc = exception ? pcPlus4 - 4 : 32'hFFFFFFFF;

endmodule
