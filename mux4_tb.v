`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:35:45 09/15/2015 
// Design Name: 
// Module Name:    mux4_tb 
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
module mux4_tb(
    );
	wire o;
	reg [1:0] s;
	reg [3:0] d;
	integer i;
	
	mux4 DUT(o, s, d);
	
	initial
	begin
		#1 $monitor($time, " d = %b", d, " | select = ", s, " | out = ", o);
		for(i=0 ; i<=15 ; i = i+1)
		begin
			d = i;
			s = 0;
			#1;
			s = 1;
			#1;
			s = 2;
			#1;
			s = 3;
			#1;
			$display("-------------------------");
		end
		$finish;
	end
endmodule
