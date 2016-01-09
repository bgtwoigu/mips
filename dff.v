`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:40 09/23/2015 
// Design Name: 
// Module Name:    dff 
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
// behavioral D flipflop
module dff(q, d, clk, reset );
	 output q;
    input d, clk, reset;
	reg q;
	
	// output is from input when clk goes high
	always @(posedge reset or posedge clk)
		// if reset, output is 0
		if(reset)
			q = 1'b0;
		// else output is from input when clock goes high
		else q = d;
endmodule
