`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:59:12 12/19/2015 
// Design Name: 
// Module Name:    HazardUnit 
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
`define NoHazardState	3'b000
`define LdHazardState	3'b001
`define JumpState			3'b010
`define JrState			3'b011
`define Branch0State		3'b100
`define Branch1State		3'b101

module HazardUnitCacheMiss(PC_Write, IF_Write, IF_Flush, bubble, addrSel, 
						CacheMiss, exception, taken, needFlush, Jump, Jr, Branch, 
						ALUZero,	memReadEX, currRs, currRt, prevRt, 
						rwRegW3_rwRegW4, UseShamt, UseImmed, Clk, Rst);
	output reg IF_Write, IF_Flush, PC_Write, bubble;
	output reg [1:0] addrSel;
	input CacheMiss, taken, needFlush, Jump, Jr, ALUZero, memReadEX, Clk, Rst;
	input exception, UseShamt, UseImmed;
	input [1:0] Branch;
	input [4:0] currRs, currRt, prevRt;
	input [11:0] rwRegW3_rwRegW4;
	wire needFlush, LdHazard, regW3, regW4;
	wire [4:0] rw3, rw4;
	reg [2:0] currstate =`NoHazardState;
	reg [2:0] nextstate;
	
	assign {rw3, regW3, rw4, regW4} = rwRegW3_rwRegW4;
	assign LdHazard = (((currRs == prevRt) || (currRt == prevRt)) && !UseImmed && !UseShamt && memReadEX) ? 1 : 0;
	
	always @(negedge Clk) begin
		if(!Rst)	currstate <= 0;
		else begin 
			currstate <= nextstate;
		end
	end

	always @(*) begin
		case(currstate)
			`NoHazardState : begin
				if(CacheMiss) begin
					nextstate = `NoHazardState;
					PC_Write = 0;
					IF_Write = 1;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b00;
				end else if(exception) begin
					nextstate = `NoHazardState;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 1;
					bubble = 1;
					addrSel = 2'b11;				
				end else if(Jump) begin
					nextstate = `JumpState;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b01;
				end else if(Jr) begin
					if(regW3 && currRs == rw3) begin
						nextstate = `JrState;
						PC_Write = 0;
						IF_Write = 0;
						IF_Flush = 0;
						bubble= 1;
						addrSel = 2'b01;
					end else if(regW4 && currRs == rw4) begin
						nextstate = `JrState;
						PC_Write = 0;
						IF_Write = 0;
						IF_Flush = 0;
						bubble= 1;
						addrSel = 2'b01;
					end else begin
						nextstate = `JumpState;
						PC_Write = 1;
						IF_Write = 0;
						IF_Flush = 0;
						bubble = 1;
						addrSel = 2'b01;
					end
				end else if(LdHazard) begin
					nextstate = `LdHazardState;
					PC_Write = 0;
					IF_Write = 0;
					IF_Flush = 0;
					bubble = 1;
					addrSel = 2'b00;
				end else if(Branch[0]) begin
					if(taken) begin
						nextstate = `Branch0State;
						PC_Write = 1;
						IF_Write = 0;
						IF_Flush = 1;
						bubble = 0;
						addrSel = 2'b10;
					end else begin
						nextstate = `Branch0State;
						PC_Write = 1;
						IF_Write = 1;
						IF_Flush = 0;
						bubble = 0;
					addrSel = 2'b00;					
					end
				end else begin
					nextstate = `NoHazardState;
					PC_Write = 1;
					IF_Write = 1;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b00;
				end
			end
			`Branch0State : begin
				if(Jump && !needFlush) begin
					nextstate = `JumpState;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b01;
				end else if(needFlush) begin
					nextstate = `Branch1State;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 1;
					bubble = 1;
					addrSel = 2'b11;					
				end else begin
					nextstate = `NoHazardState;
					PC_Write = 1;
					IF_Write = 1;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b00;					
				end			
			end
			`Branch1State : begin
				if(Jump) begin
					nextstate = `JumpState;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b01;
				end else begin
					nextstate = `NoHazardState;
					PC_Write = 1;
					IF_Write = 1;
					IF_Flush = 0;
					bubble = 0;
					addrSel = 2'b00;						
				end
			end
			`JumpState : begin
				nextstate = `NoHazardState;
				PC_Write = 1;
				IF_Write = 1;
				IF_Flush = 0;
				bubble = 0;
				addrSel = 2'b00;				
			end
			`JrState : begin
				if(regW4 && currRs == rw4) begin
					nextstate = `JrState;
					PC_Write = 0;
					IF_Write = 0;
					IF_Flush = 0;
					bubble= 1;
					addrSel = 2'b01;
				end else begin
					nextstate = `JumpState;
					PC_Write = 1;
					IF_Write = 0;
					IF_Flush = 0;
					bubble = 1;
					addrSel = 2'b01;							
				end
			end
			`LdHazardState : begin
				nextstate = `NoHazardState;
				PC_Write = 1;
				IF_Write = 1;
				IF_Flush = 0;
				bubble = 0;
				addrSel = 2'b00;					
			end
			default : begin
				nextstate = `NoHazardState;
				PC_Write = 1;
				IF_Write = 1;
				IF_Flush = 0;
				bubble = 0;
				addrSel = 2'b00;
			end
		endcase		
	end	
endmodule
