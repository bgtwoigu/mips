`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:15 09/15/2015 
// Design Name: 
// Module Name:    mux4 
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
module mux4(o, s, d);
	output o;
	input [1:0] s;
	input [3:0] d;
	
	wire o;
	wire [1:0] s;
	wire [3:0] d;
	wire [1:0] q;
	
	mux2 m1(q[0], s[0], d[1:0]);
	mux2 m2(q[1], s[0], d[3:2]);
	mux2 m3(o, s[1], q[1:0]);
endmodule
