`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    00:30:38 03/19/2013
// Design Name:
// Module Name:    vga640x480
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
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
	input wire [8:0] g1Grid_vg,
	input wire [8:0] g2Grid_vg,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);

	parameter hpixels = 800;// horizontal pixels per line
	parameter vlines = 521; // vertical lines per frame
	parameter hpulse = 96; 	// hsync pulse length
	parameter vpulse = 2; 	// vsync pulse length
	parameter hbp = 144; 	// end of horizontal back porch
	parameter hfp = 784; 	// beginning of horizontal front porch
	parameter vbp = 31; 		// end of vertical back porch
	parameter vfp = 511; 	// beginning of vertical front porch

	// registers for storing the horizontal & vertical counters
	reg [9:0] hc;
	reg [9:0] vc;

	// Horizontal & vertical counters --
	always @(posedge dclk or posedge clr)
	begin
		// reset condition
		if (clr == 1)
		begin
			hc <= 0;
			vc <= 0;
		end

		else begin
			// keep counting until the end of the line
			if (hc < hpixels - 1)
				hc <= hc + 1;
			else
			begin
				hc <= 0;
				if (vc < vlines - 1)
					vc <= vc + 1;
				else
					vc <= 0;
			end
		end
	end

	// generate sync pulses (active low)
	// ----------------
	// "assign" statements are a quick way to
	// give values to variables of type: wire
	assign hsync = (hc < hpulse) ? 0:1;
	assign vsync = (vc < vpulse) ? 0:1;
	parameter vOffset = 50;
	parameter hOffset = 144;

	always @(*)
	begin
		// first check if we're within vertical active video range
		if (vc >= vbp && vc < vfp) begin
			//If we're in the game grid (with 9 boxes)
			if(hc < hbp + 402 && vc < vbp + 402) begin

        //at leftmost box lane
        if(hc > hbp && hc < hbp + 128) begin

          //at upper box lane
          if(vc > vbp && vc < vbp + 128) begin
            red = 3'b111;
            green = 3'b000;
            blue = 2'b00;
          end

          //the first upper line
          else if (vc > vbp + 128 && vc < vbp + 138) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the center box lane in x-axis
          else if(vc > vbp + 138 && vc < vbp + 266) begin
            red = 3'b000;
            green = 3'b111;
            blue = 2'b00;
          end

          //the right white line
          else if(vc > vbp + 266 && vc < vbp + 276) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the rightmost box lane
          else if(vc > 276) begin
            red = 3'b000;
            green = 3'b000;
            blue = 2'b11;
          end

        end //end of leftmost box lane

        //the first leftmost line
        else if (hc > hbp + 128 && hc < hbp + 138) begin
          red = 3'b111;
          green = 3'b111;
          blue = 2'b11;
        end

        //the center box lane in x-axis
        else if(hc > hbp + 138 && hc < hbp + 266) begin//at upper box lane
          //at upper box lane
          if(vc > vbp && vc < vbp + 128) begin
            red = 3'b111;
            green = 3'b000;
            blue = 2'b00;
          end

          //the first upper line
          else if (vc > vbp + 128 && vc < vbp + 138) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the center box lane in x-axis
          else if(vc > vbp + 138 && vc < vbp + 266) begin
            red = 3'b000;
            green = 3'b111;
            blue = 2'b00;
          end

          //the right white line
          else if(vc > vbp + 266 && vc < vbp + 276) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the rightmost box lane
          else if(vc > 276) begin
            red = 3'b000;
            green = 3'b000;
            blue = 2'b11;
          end
        end//end of center box lane x-axis

        //the right white line
        else if(hc > hbp + 266 && hc < hbp + 276) begin
          red = 3'b111;
          green = 3'b111;
          blue = 2'b11;
        end

        //the rightmost box lane
        else if(hc > 276) begin
          if(vc > vbp && vc < vbp + 128) begin
            red = 3'b111;
            green = 3'b000;
            blue = 2'b00;
          end

          //the first upper line
          else if (vc > vbp + 128 && vc < vbp + 138) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the center box lane in x-axis
          else if(vc > vbp + 138 && vc < vbp + 266) begin
            red = 3'b000;
            green = 3'b111;
            blue = 2'b00;
          end

          //the right white line
          else if(vc > vbp + 266 && vc < vbp + 276) begin
            red = 3'b111;
            green = 3'b111;
            blue = 2'b11;
          end

          //the rightmost box lane
          else if(vc > 276) begin
            red = 3'b000;
            green = 3'b000;
            blue = 2'b11;
          end
        end //end of rightmost box lane
      end //end of in game grid

	  // we're outside active vertical active video range so display black
	  else
			begin
				red = 0;
				green = 0;
				blue = 0;
		  end
		end//end of if within vertical active range
		//line width =2px
		// we're outside active vertical range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end



	endmodule
