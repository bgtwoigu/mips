`timescale 1ns / 1ps


`define STRLEN 32
`define HalfClockPeriod 60
`define ClockPeriod `HalfClockPeriod * 2
module PipelinedProcICacheTest;

	task passTest;
		input [31:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: 0x%x should be 0x%x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed: %d of %d passed", passed, numTests);
	endtask

	// Inputs
	reg CLK;
	reg Reset_L;
	reg [31:0] startPC;
	reg [31:0] exceptAddr;
	reg [7:0] passed;


	// Outputs
	wire [31:0] dMemOut;
	wire [31:0] Cause, EPC;

	//book keeping
	reg [31:0] cc_counter;
	
	always@(negedge CLK)
		if(~Reset_L)
			cc_counter <= 0;
		else
			cc_counter <= cc_counter+1;

	initial begin
		CLK= 1'b0;
	end
	
	 /*generate clock signal*/
   always begin
      #`HalfClockPeriod CLK = ~CLK;
      #`HalfClockPeriod CLK = ~CLK;
   end
	
	// Instantiate the Unit Under Test (UUT)
	Processor uut (
		.CLK(CLK), 
		.Reset_L(Reset_L), 
		.startPC(startPC),
      .exceptAddr(exceptAddr),
		.dMemOut(dMemOut),
		.Cause(Cause),
		.EPC(EPC)
	);

	initial begin
		// Initialize Inputs
		Reset_L = 1;
		startPC = 0;
		passed = 0;
		exceptAddr = 32'hF0000000;
		
		// Wait for global reset
		#(1 * `ClockPeriod);

		// Program 1
		#1;
		Reset_L = 0; startPC = 32'h0;
		#(1 * `ClockPeriod);
		Reset_L = 1;
		wait(EPC == 32'h054);
		passTest(dMemOut, 120, "Results of Program 1", passed);
		
		// Program 2
		#(1 * `ClockPeriod);
		Reset_L = 0; startPC = 32'h60;
		#(1 * `ClockPeriod);
		Reset_L = 1;
		wait(EPC == 32'h090);
		passTest(dMemOut, 2, "Results of Program 2", passed);
		
		//Program 6
		#(1 * `ClockPeriod);
		Reset_L = 0; startPC = 32'h500;
		#(1 * `ClockPeriod);
		Reset_L = 1;
		wait( (EPC == 32'h52C) || (cc_counter == 66500)); 
		passTest(dMemOut, 32'h2710, "Result 1 of Program 6", passed);
		$display("Run Time for Program 6: %d",cc_counter);
		
		//Program 7
		#(1 * `ClockPeriod);
		Reset_L = 0; startPC = 32'h400;
		#(1 * `ClockPeriod);
		Reset_L = 1;
		wait( (EPC == 32'h448) || (cc_counter == 665000)); 
		passTest(dMemOut, 32'h9DD, "Result 1 of Program 7", passed);
		$display("Run Time for Program 7: %d",cc_counter);
		// Done
		allPassed(passed, 4);
		$finish;
	end
	
	   
endmodule
