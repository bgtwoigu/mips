`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:02 10/15/2015 
// Design Name: 
// Module Name:    ccc_tb 
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
module ccc_tb();
	// inputs/outputs to test module
	reg throttle, set, accel, coast, cancel, resume, brake, clk, rst;
	wire [6:0] spd;
	
	// instantiate test module
	ccc dut(.spd(spd),
				.throttle(throttle),
				.set(set),
				.accel(accel),
				.coast(coast),
				.cancel(cancel),
				.resume(resume),
				.brake(brake),
				.clk(clk),
				.rst(rst) );
		
	// initialize the pins
	initial begin
		throttle = 0;
		set = 0;
		accel = 0;
		coast = 0;
		cancel = 0;
		resume = 0;
		brake = 0;
		clk = 0;
		rst = 0;
	end

	// generate clock with cycle 10ns, duration 5ns
	always
		#5 clk = ~clk;
		
	initial begin
		// reset outputs - vehicle speed, cruise speed
		rst = 1;
		#10;
		rst = 0;
		#100;
		// increase vehicle speed to 30mph
		throttle = 1;
		#300;
		// try to set cruise speed to 30mph - this fails
		set = 1;
		#5;
		set = 0;		
		#45;
		// throttle off until speed goes down to 20mph
		throttle = 0;
		#160;
		// throttle on when speed is 20mph
		throttle = 1;
		// throttle keeps on until speed is 50mph
		#300
		set = 1;
		#5
		set = 0;
		// speed continue to increase to 60mph
		#95;
		// release throttle 
		throttle = 0;
		// speed goes down to cruise speed, 50mph
		#100;
		// stay cruise speed for 5 clock cycle
		#50;
		// press brake
		brake = 1;
		// keep pressing brake untile speed 30mph
		#100;
		brake = 0;
		// resume the cruise and speed up to 50mph 
		// and stay for 5clocks
		resume = 1;
		#250;
		// give 5 accel pulse to speed up to 55mph
		accel = 1; #5;	accel = 0; #5;
		accel = 1; #5;	accel = 0; #5;
		accel = 1; #5;	accel = 0; #5;
		accel = 1; #5;	accel = 0; #5;
		accel = 1; #5;	accel = 0; #5;
		// stay 55mph for 5 clock cycles
		#40;
		// give 5 coast pulse to speed down to 50mph
		coast = 1; #5; coast = 0; #5;
		coast = 1; #5; coast = 0; #5;
		coast = 1; #5; coast = 0; #5;
		coast = 1; #5; coast = 0; #5;
		coast = 1; #5; coast = 0; #5;
		// stay 50mph for 5 clock cycles
		#40;
		// cancel cruise and speed decrease by 1mph
		// and it reaches to 0mph
		cancel = 1;
		#500;
		#100;
		$finish;
	end
endmodule
