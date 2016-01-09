`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:12 09/22/2015 
// Design Name: 
// Module Name:    JKstructural 
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
 `define STRLEN 15
module JKstructural;
	task passTest;
		input actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
		if(actualOut == expectedOut)
		begin
			$display("%s passed", testType);
			passed = passed + 1;
		end
		else
			$display("%s failed : %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		if(passed == numTests) 
			$display("All tests passed");
		else 
			$display("Some tests failed");
	endtask
	
	//inputs
	reg j;
	reg k;
	reg clk;
	reg reset;
	reg [7:0] passed;
	// outputs
	wire q;
//	JK uut(
//		.q(q),
//		.j(j),
//		.k(k),
//		.clk(clk),
//		.reset(reset)
//		);
		
	JKB uut(
		.q(q),
		.j(j),
		.k(k),
		.clk(clk),
		.reset(reset)
		);	
		
	initial begin
		//initialize inputs
		j=0;
		k = 0;
		clk = 0;
		reset = 1;
		passed = 0;
		
		// wait 100ns for global reset to finish
		#100;
		
		// add stimulus here
		reset = 0;
		#90; j=1; k=0; #7; clk = 1;#3 ; clk=0; #90;
		passTest(q, 1, "Set", passed);
		#90; j=1;k=1; #7; clk = 1;
		#3; clk = 0 ; #90;
		passTest(q, 0, "Toggle1", passed);
		#90; j=0; k=0; #7; clk = 1;
		#3; clk = 0 ; #90;
		passTest(q, 0, "Hold1" , passed) ;
		#90; j = 1;k = 1;#7;clk = 1;
		#3;clk = 0;	#90;
		passTest(q, 1, "Toggle2" , passed);
		#90; j=0; k=0; #7; clk = 1;
		#3; clk = 0 ; #90;
		passTest(q, 1, "Hold2" , passed);
		#90; j=0; k=1; #7; clk = 1;
		#3; clk = 0; #90;
		passTest(q ,0 , "Reset" , passed);
		#90; allPassed(passed,6);
	end
endmodule
