`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    11:20:30 02/07/2019
// Design Name:
// Module Name:    clocks
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
module clocks(
	clk_cl,
	clk_500hz_cl,
	clk_1hz_cl,
	clk_5hz_cl
    );

	input clk_cl;
	output wire clk_500hz_cl;
	output wire clk_1hz_cl;
	output wire clk_5hz_cl;

	reg [15:0] m_buffer = 0;
	reg [26:0] one_buffer = 0;
	reg [24:0] five_buffer = 0;

	reg clk_500hz_reg = 0;
	reg clk_1hz_reg = 0;
	reg clk_5hz_reg = 0;

	//100x faster for tb
	parameter refresh = 2000;
	parameter one = 1000000;
	parameter five = 200000;

	/*
	parameter refresh = 200000;
	parameter one = 100000000;
	parameter five = 20000000;
	*/
	////////////////
	always @(posedge clk_cl) begin

		//for clk_m
		if(m_buffer == refresh - 1) begin
			m_buffer <= 15'd0;
			clk_500hz_reg <= ~clk_500hz_cl;
		end
		else begin
			m_buffer <= m_buffer + 15'b1;
			clk_500hz_reg <= clk_500hz_cl;
		end

		//for clk_one
		if(one_buffer == one - 1) begin
			one_buffer <= 27'd0;
			clk_1hz_reg <= ~clk_1hz_cl;
		end
		else begin
			one_buffer <= one_buffer + 27'b1;
			clk_1hz_reg <= clk_1hz_cl;
		end

		//for clk_five
		if(five_buffer == five - 1) begin
			five_buffer <= 25'd0;
			clk_5hz_reg <= ~clk_5hz_cl;
		end
		else begin
			five_buffer <= five_buffer + 25'b1;
			clk_5hz_reg <= clk_5hz_cl;
		end

	end

	////////////////
/*
	always @(posedge clk_i) begin
		m_buffer <= m_buffer+1;
		one_buffer <= one_buffer +1;
		five_buffer <= five_buffer+1;

		//clk_i: 100,000,000 hz

		//200,000
		if(m_buffer == 28'd200_000) begin
		//if(m_buffer == 21'd250) begin
		//if(m_buffer == 21'd8_000_000) begin
			m_buffer <= 16'd0;
			clk_m_reg <= ~clk_m_reg;
		end
		//100,000,000
		if(one_buffer == 27'd100_000_000)begin
		//if(one_buffer ==  30'd100000) begin
		//if(one_buffer == 30'd4_000_000_000) begin
			one_buffer <= 27'd0;
			clk_one_reg <= ~clk_one_reg;
		end
		//20,000,000
		if(five_buffer == 25'd20_000_000) begin
		//if(five_buffer == 32'd400000) begin
		//if(five_buffer == 32'd16_000_000_000) begin
			five_buffer <= 25'd0;
			clk_five_reg <= ~clk_five_reg;
		end
	end
	*/
	assign clk_500hz_cl = clk_500hz_reg;
	assign clk_1hz_cl = clk_1hz_reg;
	assign clk_5hz_cl = clk_5hz_reg;

endmodule
