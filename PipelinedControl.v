`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:58 10/20/2015 
// Design Name: 
// Module Name:    SingleCycleControl 
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
`define RTYPEOPCODE 		6'b000000
`define LWOPCODE 			6'b100011
`define SWOPCODE 			6'b101011
`define BEQOPCODE 		6'b000100
`define BNEOPCODE			6'b000101
`define JOPCODE 			6'b000010
`define JALOPCODE			6'b000011
`define ORIOPCODE 		6'b001101
`define ADDIOPCODE 		6'b001000
`define ADDIUOPCODE 		6'b001001
`define ANDIOPCODE 		6'b001100
`define LUIOPCODE 		6'b001111
`define SLTIOPCODE 		6'b001010
`define SLTIUOPCODE 		6'b001011
`define XORIOPCODE 		6'b001110

//
`define AND     4'b0000
`define OR      4'b0001
`define ADD     4'b0010
`define SLL     4'b0011
`define SRL     4'b0100
`define SUB     4'b0110
`define SLT     4'b0111
`define ADDU    4'b1000
`define SUBU    4'b1001
`define XOR     4'b1010
`define SLTU    4'b1011
`define NOR     4'b1100
`define SRA     4'b1101
`define LUI     4'b1110
`define RTYP	 4'b1111
//
`define SLLFunc  	6'b000000
`define SRLFunc  	6'b000010
`define SRAFunc  	6'b000011
`define JRFunc		6'b001000

// SingleCycleControl module
module PipelinedControl(RegDst, MemToReg, RegWrite, MemRead, MemWrite, Branch, 
								Jump, Jal, Jr, SignExtend, ALUOp, OpInstError, Opcode, FuncCode);
// declaration of input, output signals								
	input [5:0] Opcode, FuncCode;
	output reg [1:0] RegDst;
	output reg OpInstError;
	output reg MemToReg;
	output reg RegWrite;
	output reg MemRead;
	output reg MemWrite;
	output reg [1:0] Branch ;
	output reg Jump, Jal, Jr;
	output reg SignExtend;
	output reg [3:0] ALUOp;
	
	always @(*) begin
		if(Opcode == `RTYPEOPCODE) begin
				RegDst = 2'b01;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				if(FuncCode == `JRFunc) Jr = 1'b1;
				else Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `RTYP;
				OpInstError = 0;
		end else if(Opcode == `LWOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b1;
				RegWrite = 1'b1;
				MemRead = 1'b1;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;
				OpInstError = 0;
		end else if(Opcode == `SWOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b1;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;
				OpInstError = 0;
		end else if(Opcode == `BEQOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b01;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SUB;	
				OpInstError = 0;
		end else if(Opcode == `BNEOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b11;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SUB;				
				OpInstError = 0;
		end else if(Opcode == `JOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b1;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = 4'b0;	
				OpInstError = 0;
		end else if(Opcode == `JALOPCODE) begin
				RegDst = 2'b10;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b1;
				Jal = 1'b1;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = 4'b0;	
				OpInstError = 0;
		end else if(Opcode == `ORIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `OR;				
				OpInstError = 0;
		end else if(Opcode == `ADDIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `ADD;				
				OpInstError = 0;
		end else if(Opcode == `ADDIUOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `ADDU;		
				OpInstError = 0;
		end else if(Opcode == `ANDIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `AND;		
				OpInstError = 0;
		end else if(Opcode == `LUIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `LUI;			
				OpInstError = 0;
		end else if(Opcode == `SLTIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SLT;			
				OpInstError = 0;
		end else if(Opcode == `SLTIUOPCODE) begin 
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b1;
				ALUOp = `SLTU;	
				OpInstError = 0;
		end else if(Opcode == `XORIOPCODE) begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b1;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `XOR;	
				OpInstError = 0;
		end else begin
				RegDst = 2'b00;
				MemToReg = 1'b0;
				RegWrite = 1'b0;
				MemRead = 1'b0;
				MemWrite = 1'b0;
				Branch = 2'b00;
				Jump = 1'b0;
				Jal = 1'b0;
				Jr = 1'b0;
				SignExtend = 1'b0;
				ALUOp = `ADD;
				OpInstError = 1;
		end
	end
endmodule

