`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:21 09/23/2015 
// Design Name: 
// Module Name:    twotofour_tb 
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
module twotofour_tb();
	
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
				$display ("All tests passed");
			else
				$display ("some tests failed");
		endtask
		
		//Inputs
		reg [1:0] in;
		reg en;
		reg [7:0] passed;
	
		//outputs
		wire [3:0] out;
		
		//Instantiate the Unit Under Test (UUT)
		twotofourdecoder uut(	
					.o(out),
					.a(in),
					.en(en)			
		);
//		decoder24B uut(	
//					.o(out),
//					.i(in),
//					.en(en)			
//		);		
		initial begin
		//Initialize Inputs
			in=0;
			en=0;
			passed=0;
			//Add stimulus here		
			#90; en=1; in=0; #10; 			
			passTest(out, 1, "Input 0", passed);
			#90; en=1; in=1; #10; 			
			passTest(out, 2, "Input 1", passed);
			#90; en=1; in=2; #10; 			
			passTest(out, 4, "Input 2", passed);
			#90; en=1; in=3; #10; 			
			passTest(out, 8, "Input 3", passed);
		
			allPassed(passed, 4);	
		end
		

endmodule

