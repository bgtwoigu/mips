`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:06:41 09/22/2015 
// Design Name: 
// Module Name:    JK 
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
// structural implemenation of JK ff
module JK(q, j, k, clk, reset
    );
	 output q;
	 input j, k, clk, reset;
	 
	 // wires for connections btwn gates
	 wire o1, o2, q, qbar, nreset;
	  
	 // reset is negated before connected
	 not(nreset, reset);
	 
	 // nand1 : input j, ~q, clk, output : o1
	 nand #2 n1(o1, j, qbar, clk);
	 // nand2 : input k, q, clk, output : o2
	 nand #2 n2(o2, k, q, clk);
 	 // nand3 : input o1, ~q, output : q
	 nand #2 n3(q, o1, qbar);
 	 // nand4 : input q, o2, ~reset, output : ~q
	 nand #2 n4(qbar, q, o2, nreset);
endmodule
