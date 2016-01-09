`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:15:06 09/15/2015 
// Design Name: 
// Module Name:    stimulous 
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
module stimulous(
    );
	reg clk;
	reg reset;
	wire [3:0] q;
	// instantiate the design block
	RCC r1(q, clk, reset);
	 
	// control the clock signal that drives the design block. cycle time = 10
	initial 
		clk = 1'b0;
	always 
		#5 clk = ~clk; // toggle clk every 5 time units
	// control the reset signal that drives the design block
	// reset is asserted from 0 to 20 and from 200 to 220
	initial
	begin
		reset = 1'b1;
		#15 reset = 1'b0;
		#180 reset = 1'b1;
		#10 reset = 1'b0;
		#20 $finish; // terminate the simulation
	end
	// monitor the output
	initial 
		$monitor($time, " clk %b, output q = %d", clk, q);
endmodule
