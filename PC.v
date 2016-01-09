module PC(Address, CLK, Reset_L, startPC, PCin, PCwrite);
output [31:0] Address;
input CLK, Reset_L, PCwrite;
input [31:0] startPC, PCin;

reg [31:0] Address;

always @(negedge CLK)
	begin
	if(!PCwrite);// if there is a hazard, stall!
	else
	begin
		if (Reset_L) 
			Address = PCin;
		else
			Address = startPC; 
	end
end
endmodule