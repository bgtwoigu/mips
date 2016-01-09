`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:04:59 09/15/2015 
// Design Name: 
// Module Name:    mux2 
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
module mux2(o, s, d);
	output o;
	input s;
	input [1:0] d;
	
	reg o;
	wire s;
	wire [1:0] d;
	
	always @(s or d)
	begin
		if(s == 0) o <= d[0];
		if(s == 1) o <= d[1];
	end

endmodule
