module Sign_extend(D_out,D_in,SignExtend);
output [31:0] D_out;
input	 [15:0] D_in;
input SignExtend;
assign D_out = (SignExtend) ? {{16{D_in[15]}},D_in[15:0]} : {16'h0000,D_in[15:0]};
endmodule
