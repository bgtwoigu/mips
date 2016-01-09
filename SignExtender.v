`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:46:52 11/10/2015 
// Design Name: 
// Module Name:    SignExtender 
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
module SignExtender(signExtImm, signAdd, SignExtend);
	input [15:0] signAdd;
	input SignExtend;
	output [31:0] signExtImm;
	// Check the sign extension control signal and extend offset value
	assign signExtImm = (SignExtend) ? {{16{signAdd[15]}},signAdd[15:0]} : {16'h0000,signAdd[15:0]};
endmodule
