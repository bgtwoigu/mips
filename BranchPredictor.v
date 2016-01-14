`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:00 01/10/2016 
// Design Name: 
// Module Name:    BranchPredictor 
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
module BranchPredictor(taken, PredictAddr, Branch_EX, UpdateAddr, Outcome, Clk);
	input [4:0] PredictAddr; 	// PC+4 from Fetch stage for prediction
	input [4:0] UpdateAddr; 	// PC+4 from EX stage (i.e. PC+4 for branch)
	input Branch_EX; 				// branch in Ex stage
	input Outcome; 				// based on aluZero, active for Taken, otherwise Not Taken
	input Clk;
	output wire taken;
	
	reg [1:0] bht[31:0];
	
	integer k;
	initial begin
		for (k = 0; k < 32; k = k + 1) begin
			bht[k] = 0;
		end
	end	
	
	assign taken = (bht[PredictAddr] == 2'b11 || bht[PredictAddr] == 2'b10) ? 1 : 0;
	
	always @(negedge Clk) begin
//		if(bht[PredictAddr] == 2'b11 || bht[PredictAddr] == 2'b10) begin
//			taken <= 1;
//		end else begin
//			taken <= 0;
//		end
		
		if(Branch_EX) begin
			if(Outcome) begin
				if(bht[UpdateAddr] == 2'b10 || bht[UpdateAddr] == 2'b01) begin
					bht[UpdateAddr] <= 2'b11;
				end else if(bht[UpdateAddr] == 2'b00) begin
					bht[UpdateAddr] <= 2'b01;
				end else bht[UpdateAddr] <= 2'b11;
			end else begin
				if(bht[UpdateAddr] == 2'b01 || bht[UpdateAddr] == 2'b10) begin
					bht[UpdateAddr] <= 2'b00;
				end else if(bht[UpdateAddr] == 2'b11) begin
					bht[UpdateAddr] <= 2'b10;
				end else bht[UpdateAddr] <= 2'b00;
			end
		end
	end
endmodule
