`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:36 03/19/2013 
// Design Name: 
// Module Name:    clockdiv 
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
module clockdiv(
	input wire clk,		//master clock: 50MHz
	input wire clr,		//asynchronous reset
	output wire dclk,		//pixel clock: 25MHz
	output wire segclk	//7-segment clock: 381.47Hz
	);

// 17-bit counter variable
//reg [16:0] q;

// 2-bit counter variable
reg [1:0] q;
parameter counter_25Mhz = 3;


always @(posedge clk or posedge clr)
begin
	if (clr == 1 || q == counter_25Mhz)
		q <= 0;
	// increment counter by one
	else
		q <= q + 1;	//QUESTION: what happens when q reaches max value? 
end

// 50Mhz  2^17 = 381.47Hz
//assign segclk = q[16];	//NOTE: not using seven seg

// 50Mhz  2^1 = 25MHz
//assign dclk = q[0];		//NOTE: our master clock is 100MHz

//assign dclk to true if q counter reaches 2'b11
assign dclk = (q[1] && q[0])? 1'b1: 1'b0;

endmodule
