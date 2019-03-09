`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:18:08 03/06/2019 
// Design Name: 
// Module Name:    vgaManager 
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

//incorporated vga tips and methods from the link given from the TA, https://www.element14.com/community/thread/23394/l/draw-vga-color-bars-with-fpga-in-verilog
module vgaManager(
	input wire clk_25Mhz_vm,	//25mhz clock
	output wire hsync_vm,
	output wire vsync_vm,
	output reg [2:0] red,
	output reg [2:0] green,
	output reg [1:0] blue
    );

	parameter hpixels = 800;
	parameter vlines = 521;
	parameter hpulse = 96;
	parameter vpulse = 2;
	parameter hbp = 144;
	parameter hfp = 784;
	parameter vbp = 31;
	parameter vfp = 511;
	
	parameter boxDimension = 128;	//size of the boxes
	parameter lineThickness = 10;	//thickness of line of the # grid

	reg [9:0] hc;
	reg [9:0] vc;
	
	/////////////////////////////////////////////////////////////////////////
	/////////////Counter for hc and vc
	/////////////////////////////////////////////////////////////////////////
	always @(posedge clk_25Mhz_vm) begin
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
	end

	assign hsync = (hc < hpulse) ? 0:1;
	assign vsync = (vc < vpulse) ? 0:1;


	/////////////////////////////////////////////////////////////////////////
	/////////////Drawing the # grid
	/////////////////////////////////////////////////////////////////////////
	always @(*)
	begin
		if (vc >= vbp && vc < vfp) begin
			//If we're in the game grid (with 9 boxes)
			if(hc < hbp + 402 && vc < vbp + 402)begin
				//draws the left vertical line
				if(hc > hbp + 128 && hc < hbp + 138) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
				//draws the right vertical line
				else if(hc > hbp + 264 && hc < hbp + 274) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
				//draws the upper(?) horizontal line
				else if(vc > vbp + 128 && vc < vbp + 138) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
				//draws the lower(?) horizontal line
				else if(vc > vbp + 264 && vc < vbp + 274) begin
					red = 3'b111;
					green = 3'b111;
					blue = 2'b11;
				end
			end
			// we're outside active horizontal range so display black
			else
			begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end//end of if within vertical active range
		// we're outside active vertical range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end	
endmodule
