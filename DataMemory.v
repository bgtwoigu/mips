module DataMemory(ReadData,Address,WriteData,MemoryRead,MemoryWrite,Clock);
input [5:0] Address; // 32-bits wide write bus and address
input [31:0] WriteData; // 32-bits wide write bus and address
input MemoryWrite, MemoryRead, Clock; // Enable signals and clock

output [31:0] ReadData; 
reg [31:0] ReadData; // 32-bits wide read bus
reg [31:0] mem [63:0];  // Memory holds 256 bytes(32bits= 4bytes, 64*4bytes=256)

always @(posedge Clock) // Read on rising edge
	begin
		 if (MemoryRead == 1) // When enable signal is on
			begin
				ReadData <= mem[Address]; 
			end
	end

always @(negedge Clock) // Write on falling edge
	begin
    if (MemoryWrite == 1) // When enable signal is on
		 begin
			mem[Address] <= WriteData;
		 end
	end	
endmodule
