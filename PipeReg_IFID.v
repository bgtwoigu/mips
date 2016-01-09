module PipeReg_IFID(PC_plus4_IFID, Inst_IFID, CLK, PC_plus4, Inst, IFWrite);
output reg [31:0] PC_plus4_IFID, Inst_IFID;
input CLK, IFWrite;
input [31:0] PC_plus4, Inst;

always @(negedge CLK) begin
	if (IFWrite) begin
		PC_plus4_IFID = PC_plus4;
		Inst_IFID = Inst; 
	end else begin
		PC_plus4_IFID = PC_plus4_IFID;
		Inst_IFID = Inst_IFID; 
	end
end

endmodule


