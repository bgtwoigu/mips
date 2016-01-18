`timescale 1ns / 1ps
`default_nettype none
/*simulate 8-bit bus*/
`define ROM_wait 4

module ROMCtrl(DataValid, DataOut, MemRead, MemAddr, CLK, Reset_L);
    input wire Reset_L;
    input wire CLK;
    input wire MemRead;
    input wire [31:0] MemAddr;
    output reg DataValid;
    output reg [31:0] DataOut;

	/*intermediate signals*/
	wire [31:0] DataRead;
	reg [31:0] AddrReg;
	reg [3:0] counter;
	reg latchAddr, latchData, RstCount;

	/*instantiate instruction ROM*/
	InstructionMemory instrROM(DataRead, AddrReg);

	reg ctrl_state, nxt_state;

	parameter Idle_state = 1'b0,//no data transfer
				 Process_state = 1'b1;//data transfer
//		
//	always @(negedge Reset_L) begin
//		if(~Reset_L) begin
//			ctrl_state <= Idle_state;
//			DataValid <= 0;
//			DataOut <= 0;
//		end
//	end
	/*control state logic*/
	always@(posedge CLK) begin
		if(Reset_L == 0)
			ctrl_state <= Idle_state;
		else
			ctrl_state <= nxt_state;
	end
	/*next state and output logic*/
	always@(*) begin
		if(~Reset_L) begin
			ctrl_state = Idle_state;
			DataValid = 0;
			DataOut = 0;		
			counter = 0;
		end else begin
		case(ctrl_state)
			Idle_state: begin
					/*if read has been initiated*/
				if(MemRead) begin
					nxt_state = Process_state;
					latchAddr = 1;
				end else begin
					nxt_state = Idle_state;
					latchAddr = 0;
				end
				DataValid = 1;
				RstCount = 1;
				latchData = 0;
			end
			Process_state: begin
					/*if transfer is complete*/
				if(counter != `ROM_wait) begin
					nxt_state = Process_state;
					latchAddr = 0;
					latchData = 0;
				end else begin
					nxt_state = Idle_state;
					latchAddr = 0;
					latchData = 1;
				end
				DataValid = 0;
				RstCount = 0;
			end
		endcase
		end
	end
	
	/* create Data latch */	
	always@(posedge CLK) begin
		if(latchData)
			DataOut <= DataRead;
	end		
	/* create Address latch */		
	always@(posedge CLK) begin
		if(latchAddr)
			AddrReg <= MemAddr;
	end		
	/* create delay counter */		
	always@(posedge CLK) begin
		if(RstCount)
			counter <=0;
		else
			counter <= counter + 1;
	end
endmodule 