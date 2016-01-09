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
module PipelinedALU(BusW, Zero, BusA, BusB, ALUCtrl );
	output [31:0] BusW;
	output Zero;
	input signed [31:0] BusA, BusB;
	input [3:0] ALUCtrl;
	reg [31:0] BusW;
// reduction OR to determine if output(BusW) is 0
// if BusW is zero, then Zero is 1	
	wire w_zero = ~(|BusW);   
	wire Zero;
// if output(BusW) is 0, then Zero is set to 1	
	assign Zero = w_zero;

	// implement ALU arithmetic operations
	// triggered by ALUCtrl, BusA, BusB signals
	always @(ALUCtrl or BusA or BusB) begin
		case(ALUCtrl)
		`AND:BusW <= BusA & BusB;
		`OR:BusW <= BusA | BusB;
		`ADD:BusW <= BusA + BusB;
		// Shift operations need shamt values
		// BusA is shamt
		`SLL:BusW <= BusB << BusA;  
		`SRL:BusW <= BusB >> BusA;
		`SUB:BusW <= BusA - BusB;
		// BusA and BusB are signed values
		`SLT:BusW <= (BusA < BusB) ? 1 : 0; 
		`ADDU:BusW <= BusA + BusB;
		`SUBU:BusW <= BusA - BusB;
		`XOR:BusW <= BusA ^ BusB;
		// SLTU do unsigned comparison
		`SLTU:BusW <= ($unsigned(BusA) < $unsigned(BusB)) ? 1 : 0;  
		`NOR:BusW <= ~(BusA | BusB);
		// BusA is shamt
		`SRA:BusW <= {{31{BusB[31]}},BusB} >> BusA;
		`LUI:BusW <= BusB << 16;
		default: BusW <= 0;
		endcase
	end
endmodule
