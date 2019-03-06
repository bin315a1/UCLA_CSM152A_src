`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:50 03/05/2019 
// Design Name: 
// Module Name:    clockDivider 
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
module clockDivider(
    input clk_cd,					//main 100mhz clock
	 output clk_25mhz_cd,		//divided 25mhz clock for vga
	 output clk_500hz_cd			//divided 500hz clock for display
	 );

	parameter bufferCount_25mhz = 4;
	parameter bufferCount_500hz = 20000;
	
	reg [2:0] clk_25mhz_bufferReg = 3'b001;	//001 ~ 100
	reg [15:0] clk_500hz_bufferReg = 0;
	
	//reg clk_25mhz_reg = 0;
	reg clk_500hz_reg = 0;
	
	always @(posedge clk_cd) begin
		//if regBuffer reached its parameter
		if(clk_25mhz_bufferReg == bufferCount_25mhz)
			clk_25mhz_bufferReg <= 3'b001;
		//add one to the buffer reg
		clk_25mhz_bufferReg <= clk_25mhz_bufferReg + 1;
	end
	
			//for clk_m
		if(m_buffer == refresh - 1) begin
			m_buffer <= 15'd0;
			clk_500hz_reg <= ~clk_500hz_cl;
		end
		else begin
			m_buffer <= m_buffer + 15'b1;
			clk_500hz_reg <= clk_500hz_cl;
		end

	always @ (posedge clk_cd) begin
		if(clk_500hz_bufferReg == bufferCount_500hz - 1) begin
			clk_500hz_bufferReg <= 0;
			clk_500hz_reg <= ~clk_500hz_cd;
		end
		else begin
			clk_500hz_bufferReg <= clk_500hz_bufferReg + 1;
			clk_500hz_reg <= clk_500hz_cd;
		end
	end
	
	
	assign clk_25mhz_cd <= clk_25mhz_bufferReg[3];
	assign clk_500hz_cd <= clk_500hz_reg;
endmodule
