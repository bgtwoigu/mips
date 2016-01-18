`timescale 1ns/1ps
`default_nettype none

`define NoMissState 			2'b00
`define ReqWordState 		2'b01
`define LoadWordState		2'b10

module InstructionCache(MemRead, MemReadAddr, Instruction, Hit,
								InstrAddr, DataValid, DataIn, CLK, Reset_L);
	input wire CLK;
	input wire Reset_L;
	/* Interface to Core */
	input wire [31:0] InstrAddr;
	output wire [31:0] Instruction;
	output wire Hit;
	/* Interface to Memory Controller */
	input wire DataValid;
	input wire [31:0] DataIn; // 32 bit data bus from memory controller
	output reg MemRead;
	output reg [31:0] MemReadAddr;
	
	reg [1:0] CurrState = 2'b00;
	reg [1:0] NextState = 2'b00;
	wire [22:0] Tag;  /* tagwidth = 28-5 = 23 */
	wire [4:0] Index; /* index width = log2(index height) = log2(32) = 5 */
	wire [1:0] Offset; /* 1 cache block = 4 word */
	reg TagWrEn = 0, DataWrEn = 0;
	reg [2:0] LdIndex = 0;
	
	reg [31:0] DataBlockRam [127:0];
	reg [24:0] TagRam[31:0];
	reg [31:0] Valid = 32'b0;

	/* initialize memory */
	integer k;
	initial begin
		for (k = 0; k < 32; k = k + 1) begin
			TagRam[k] = 25'b0;
		end
		for (k = 0; k < 128; k = k + 1) begin
			DataBlockRam[k] = 32'b0;
		end
	end	

	assign {Tag, Index, Offset} = InstrAddr[31:2];
	assign Hit = ((TagRam[Index] == Tag) && Valid[Index]) ? 1 : 0;
	assign Instruction = (Hit == 1) ? DataBlockRam[Index*4+Offset] : 0;
//	assign DataBlockRam[Index*4+LdIndex] = (DataWrEn==1) ? DataIn : DataBlockRam[Index*4+LdIndex];
//	assign TagRam[Index*4+LdIndex] = (TagWrEn==1) ? Tag : TagRam[Index*4+LdIndex];
	
//	always @(negedge Reset_L) begin
//		if(~Reset_L) begin
//			MemRead <= 0;
//			MemReadAddr <= 0;
//			Valid <= 0;
//			LdIndex <= 0;
//			DataWrEn <= 0;
//			TagWrEn <= 0;
//			CurrState <= `NoMissState;
//			NextState <= `NoMissState;
//		end
//	end

	always @(posedge CLK) begin
		CurrState <= NextState;			
		if(DataWrEn == 1) begin
			DataBlockRam[Index*4+LdIndex] <= DataIn;
			LdIndex <= LdIndex + 1;
			Valid[Index] <= 0;
		end else if(LdIndex == 3'b100) begin
			LdIndex <= 3'b000;
			Valid[Index] <= 1;
		end
		if(TagWrEn) begin
			TagRam[Index*4+LdIndex] <= Tag;
		end
	end
	
	always @(*) begin
		if(~Reset_L) begin
			MemRead = 0;
			MemReadAddr = 0;
			Valid = 0;
			LdIndex = 0;
			DataWrEn = 0;
			TagWrEn = 0;
			CurrState = `NoMissState;
			NextState = `NoMissState;		
		end else begin
		if(CurrState == `NoMissState) begin
			if(~Hit) begin
				NextState = `ReqWordState;
				MemRead = 1;
				MemReadAddr = {InstrAddr[31:4], LdIndex[1:0], 2'b00};
				DataWrEn = 0;
				TagWrEn = 0;
			end else begin
				NextState = `NoMissState;
				DataWrEn = 0;
				TagWrEn = 0;
				MemRead = 0;
				MemReadAddr = 0;
			end
		end else if(CurrState == `ReqWordState) begin
			if(~DataValid) begin
				NextState = `ReqWordState;
				MemRead = 1;
				MemReadAddr = {InstrAddr[31:4], LdIndex[1:0], 2'b00};
				DataWrEn = 0;
				TagWrEn = 0;
			end else begin
				NextState = `LoadWordState;
				MemRead = 0;
				MemReadAddr = 0;
				DataWrEn = 1;
				if(LdIndex == 3'b011) TagWrEn = 1;
				else TagWrEn = 0;
			end
		end else if(CurrState == `LoadWordState) begin
			if(LdIndex == 3'b100) begin
				NextState = `NoMissState;
				DataWrEn = 0;
				TagWrEn = 0;
				MemRead = 0;
				MemReadAddr = 0;			
			end else begin
				NextState = `ReqWordState;
				DataWrEn = 0;
				TagWrEn = 0;
				MemRead = 1;
				MemReadAddr = {InstrAddr[31:4], LdIndex[1:0], 2'b00};
			end
		end
		end
	end
endmodule
