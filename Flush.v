`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:43:40 01/10/2016 
// Design Name: 
// Module Name:    Flush 
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
module Flush(flush, exception, branch3, prediction3, aluZero);
	output wire flush;
	input [1:0] branch3;
	input prediction3, aluZero, exception;

	assign flush = ((branch3 == 2'b01 && prediction3 != aluZero) || 
						(branch3 == 2'b11 && prediction3 == aluZero ) || exception) ? 1 : 0;
endmodule
