`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:24 01/03/2016 
// Design Name: 
// Module Name:    SyncHazardUnit 
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
`define NoHazardState	4'b0000
`define LdHazardState	4'b0001
`define JumpState			4'b0010
`define Branch0State		4'b0100
`define Branch1State		4'b1000

module SyncHazardUnit(IF_Write, PC_Write, bubble, addrSel, Jump, Branch, ALUZero, 
						memReadEX, currRs, currRt, prevRt, UseShamt, UseImmed, Clk, Rst);
	output reg IF_Write, PC_Write, bubble;
	output wire [1:0] addrSel;
	input Jump, Branch, ALUZero, memReadEX, Clk, Rst;
	input UseShamt, UseImmed;
	input [4:0] currRs, currRt, prevRt;
	wire LdHazard;
	//wire [1:0] addrSel;
	reg [3:0] currstate =`NoHazardState;
	reg [3:0] nextstate;
	
	assign LdHazard = (((currRs == prevRt) || (currRt == prevRt)) && !UseImmed && !UseShamt && memReadEX) ? 1 : 0;
	
	assign addrSel = (currstate == `JumpState) ? 2'b01 :
						  (currstate == `Branch0State) ? 2'b00 :
						  (currstate == `Branch1State) ? 2'b10 : 2'b00;
						  
	always @(negedge Clk) begin
		if(!Rst)	currstate <= 0;
		else begin 
			currstate <= nextstate;
		end
	end
	
	always @(Jump or Branch or LdHazard or Rst) begin
		case(currstate)
			`NoHazardState : begin
				if(Jump) begin
					nextstate <= `JumpState;
					PC_Write <= 0;
					IF_Write <= 0;
					bubble <= 1;
					//addrSel <= 2'b01;
				end else if(LdHazard) begin
					nextstate <= `LdHazardState;
					PC_Write <= 0;
					IF_Write <= 0;
					bubble <= 1;
					//addrSel <= 2'b00;
				end else if(Branch) begin
					nextstate <= `Branch0State;
					PC_Write <= 1;
					IF_Write <= 1;
					bubble <= 0;
					//addrSel <= 2'b00;
				end else begin
					nextstate <= `NoHazardState;
					PC_Write <= 1;
					IF_Write <= 1;
					bubble <= 0;
					//addrSel <= 2'b00;
				end
			end
			`JumpState : begin
				PC_Write <= 1;
				IF_Write <= 1;
				bubble <= 0;
				//addrSel <= 2'b00;
				nextstate <= `NoHazardState;
			end
			`Branch0State : begin
				if(ALUZero) begin
					PC_Write <= 0;
					IF_Write <= 0;
					bubble <= 1;
					//addrSel <= 2'b10;
					nextstate <= `Branch1State;
				end else begin
					nextstate <= `NoHazardState;
					PC_Write <= 1;
					IF_Write <= 1;
					bubble <= 0;
					//addrSel <= 2'b00;					
				end
			end
			`Branch1State : begin
					nextstate <= `NoHazardState;
					PC_Write <= 1;
					IF_Write <= 1;
					bubble <= 0;
					//addrSel <= 2'b00;			
			end
		endcase		
	end
endmodule
