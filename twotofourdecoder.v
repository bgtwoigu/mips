`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:52:35 09/23/2015 
// Design Name: 
// Module Name:    twotofourdecoder 
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
// 2-to-4 decoder data flow implementation
module twotofourdecoder(o, a, en
    );
	output [3:0] o;
	input [1:0] a;
	input en;

	// if en then connect ~a[0]&&~a[1] to o[0]
	assign o[0] = en?~a[0]&&~a[1]:0;
	// if en then connect a[0]&&~a[1] to o[1]
	assign o[1] = en?a[0]&&~a[1]:0;
	// if en then connect ~a[0]&&a[1] to o[2]
	assign o[2] = en?~a[0]&&a[1]:0;
	// if en then connect a[0]&&a[1] to o[3]
	assign o[3] = en?a[0]&&a[1]:0;
endmodule
