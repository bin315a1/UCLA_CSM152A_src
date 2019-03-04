`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:59:22 02/19/2019
// Design Name:   stopwatch_main
// Module Name:   C:/Users/152/Desktop/group11lab6/stopwatch_main_tb.v
// Project Name:  group11lab6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: stopwatch_main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module stopwatch_main_tb;

	// Inputs
	reg clk;
	reg btns;
	reg btnu;
	reg [7:0] sw;

	// Outputs
	wire [7:0] seg;
	wire [3:0] an;

	// Instantiate the Unit Under Test (UUT)
	stopwatch_main uut (
		.clk(clk), 
		.btns(btns), 
		.btnu(btnu), 
		.sw(sw), 
		.seg(seg), 
		.an(an)
	);
	
	always begin
		#1
		clk = ~clk;
	end

	initial begin
		// Initialize Inputs
		clk = 0;
		btns = 0;
		btnu = 0;
		sw = 0;

		// Wait 100 ns for global reset to finish
		#100;
      
		// Add stimulus here

	end
      
endmodule

