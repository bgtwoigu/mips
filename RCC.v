`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:55:48 09/15/2015 
// Design Name: 
// Module Name:    RCC 
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
module RCC(
    output [3:0] q,
    input clk,
    input reset
    ); 
	T_FF tff0(q[0], clk, reset);
	T_FF tff1(q[1], q[0], reset);
	T_FF tff2(q[2], q[1], reset);
	T_FF tff3(q[3], q[2], reset);
endmodule
