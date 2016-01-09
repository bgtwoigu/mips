`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:01 09/23/2015 
// Design Name: 
// Module Name:    dff_tb 
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
module dff_tb(
    );

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
	
	reg d, clk, reset;
	reg [7:0] passed;
	wire q;

	dff DUT(.q(q),
				.d(d),
				.clk(clk),
				.reset(reset)
				);
//	initial begin
//		d = 0;
//		clk = 0;
//		reset = 1;
//	end
//	
//	initial 
//		$monitor("d : %d, q : %d ", d, q);
//
//	always
//		#2 clk = ~clk;
//		
//	initial begin
//		reset = 0;
//		#10 d = 0;
//		#10 d = 1;
//		#10 d = 0;
//		#10 d = 1;
//		#10 d = 1;
//		#10 d = 0;
//		#10 d = 0;
//		$finish;
//	end
	initial begin
		//initialize inputs
		d = 0;
		clk = 0;
		reset = 0;
		passed = 0;
		
		// wait 100ns for global reset to finish
		#10;
		// add stimulus here
		reset = 0;
		#10; d=1; #5; clk = 1; #5; clk = 0;#5;
		passTest(q, 1, "input 1 ", passed);
		#10; clk = 1; 
		passTest(q, 1, "input 1", passed);
		#10; d=0; #5; clk = 0; #5;clk=1; #5
		passTest(q, 0, "input 0" , passed) ;
		#10; clk = 0; d=1; #10; clk=1; #5;	
		passTest(q, 1, "input 1 " , passed) ;
		#10; clk = 0; #5; clk=1; #5;
		passTest(q, 1, "input 1 " , passed) ;
		#10; d = 0;clk = 0; #5; clk=1; #5;
		passTest(q, 0, "input 0 " , passed) ;		
		#10; d=1; clk=0;#5;
		passTest(q, 0, "input 0", passed);
		#10; clk = 1; #5; clk = 0;
		passTest(q, 1, "hold prev", passed);		
		#90; allPassed(passed,8);
	end
endmodule
