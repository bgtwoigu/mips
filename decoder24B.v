`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:00:03 09/25/2015 
// Design Name: 
// Module Name:    decoder24B 
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
// 2-to-4 decoder behavioral implementation
module decoder24B(o, i, en);
	output [3:0] o;
	input [1:0] i;
	input en;
	reg [3:0] o;
	
	always @(i or en) begin
		if(en) begin
			case(i)
				2'b00: o <= 4'b0001;
				2'b01: o <= 4'b0010;
				2'b10: o <= 4'b0100;
				2'b11: o <= 4'b1000;
			endcase
		end else begin
			o <= 0;
		end
	end
endmodule
