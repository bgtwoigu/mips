`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:17 10/14/2015 
// Design Name: 
// Module Name:    ALU 
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
// ALU
// input BusA, BusB, ALUCtrol
// output BusW, Zero
module PipelinedALU(BusW, Zero, overflow, BusA, BusB, ALUCtrl );
	output [31:0] BusW;
	output Zero;
	output reg overflow;
	input signed [31:0] BusA, BusB;
	input [3:0] ALUCtrl;
	reg [31:0] BusW;
	reg [32:0] TempBusW;
// reduction OR to determine if output(BusW) is 0
// if BusW is zero, then Zero is 1	
	wire w_zero = ~(|BusW);   
	wire Zero;
// if output(BusW) is 0, then Zero is set to 1	
	assign Zero = w_zero;
	
//	assign overflow = (((BusA[31] == BusB[31]) && (BusW[31] != BusA[31])) ||
//							 ((BusA[31] != BusB[31]) && (BusW[31] !=

	// implement ALU arithmetic operations
	// triggered by ALUCtrl, BusA, BusB signals
	always @(ALUCtrl or BusA or BusB) begin
		case(ALUCtrl)
		`AND: begin
			BusW = BusA & BusB;
			overflow = 0;
		end
		`OR: begin
			BusW = BusA | BusB;
			overflow = 0;
		end
		`ADD: begin
			if((BusA > 0 && BusB > 0) || (BusA < 0 && BusB <0)) begin
				{overflow, BusW[30:0]} = BusA[30:0] + BusB[30:0];
				BusW[31] = BusA[31];
			end else begin
				BusW = BusA + BusB;
				overflow = 0;
			end
		end
		// Shift operations need shamt values
		// BusA is shamt
		`SLL: begin
			BusW = BusB << BusA;  
			overflow = 0;
		end
		`SRL: begin
			BusW = BusB >> BusA;
			overflow = 0;
		end
		`SUB: begin
			if((BusB < 0 && BusA > 0) || (BusA < 0 && BusB > 0)) begin
				{overflow, BusW[30:0]} = BusA[30:0] - BusB[30:0];
				BusW[31] = BusA[31];
			end else begin
				BusW = BusA - BusB;
				overflow = 0;
			end
		end
		// BusA and BusB are signed values
		`SLT: begin
			BusW = (BusA < BusB) ? 1 : 0; 
			overflow = 0;
		end
		`ADDU: begin
			BusW = BusA + BusB;
			overflow = 0;
		end
		`SUBU: begin
			BusW = BusA - BusB;
			overflow = 0;
		end
		`XOR: begin
			BusW = BusA ^ BusB;
			overflow = 0;
		end
		// SLTU do unsigned comparison
		`SLTU: begin
			BusW = ($unsigned(BusA) < $unsigned(BusB)) ? 1 : 0;  
			overflow = 0;
		end
		`NOR: begin	
			BusW = ~(BusA | BusB);
			overflow = 0;
		end
		// BusA is shamt
		`SRA: begin
			BusW = {{31{BusB[31]}},BusB} >> BusA;
			overflow = 0;
		end
		`LUI: begin
			BusW = BusB << 16;
			overflow = 0;
		end
		default: begin
			BusW = 0;
			overflow = 0;
		end
		endcase
	end
endmodule
