`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:04 09/22/2015 
// Design Name: 
// Module Name:    JKB 
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
// JK FF : behavioral implementation
module JKB(q, j, k, clk, reset
    );
	 output q;
	 input j, k, clk, reset;
	 
	 reg q, qbar;
	 reg [1:0] jk;
	 wire nreset;
	 
	 not(nreset, reset);
	 
	 // behavioral implementation of JK flip flop
	 always @(posedge clk) begin
		jk = {j, k};
		// if reset is not asserted
		if(nreset) begin
			case(jk)
				// when input is j=0, k=1, output is reset
				2'd1 : q <= 1'b0;
				// when input is j=1, k=0, output is set
				2'd2 : q <= 1'b1;
				// when input is j=1, k=1, output is toggled
				2'd3 : q <= ~q;
			endcase
				// the other output qbar is from ~q
			qbar <= ~q;
		// if reset is asserted, the output q is 0, qbar is 1
		end else begin
			q <= 1'b0;
			qbar <= ~q;
		end
	 end
endmodule
