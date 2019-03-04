`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		 Han Lee
// Create Date:    15:11:15 02/08/2019
// Module Name:    clocks
//////////////////////////////////////////////////////////////////////////////////
module display(
	clk_m_d,
	clk_blink,
	ADJ_d,
	SEL_d,
	min_tens_d,
	min_ones_d,
	sec_tens_d,
	sec_ones_d,
	an_d,
	seg_d
    );
	//_d for "display"
	input clk_m_d;		//for display refreshing
	input clk_blink;	//for blinking digit in ADJ mode
	input ADJ_d;			    //ADJ boolean input for display module
	input [1:0] SEL_d;		//for choosing which digit to blink in adj mode
	input [3:0] min_tens_d;
	input [3:0] min_ones_d;
	input [3:0] sec_tens_d;
	input [3:0] sec_ones_d;

	output [3:0] an_d;
	output [7:0] seg_d;


	reg [2:0] iterator = 3'b001;	//iterator iterates through the first~fourth digits, initialized to 1
	reg [3:0] value;					//the value is the number on the digit iterator points to
	reg [3:0] an_reg;
	reg [7:0] seg_reg;

	always @(posedge clk_m_d) begin
		if(iterator == 3'b101) begin
			iterator = 3'b001;
		end

		case(iterator)
			3'b001: an_reg = 4'b1110;	// iterator points to tens min
			3'b010: an_reg = 4'b1101;	// ones min
			3'b011: an_reg = 4'b1011;	// tens sec
			3'b100: an_reg = 4'b0111;	// ones sec
		endcase

		case(iterator)
			3'b001: value = sec_ones_d;
			3'b010: value = sec_tens_d;
			3'b011: value = min_ones_d;
			3'b100: value = min_tens_d;	//value equals to the numbers from according digits
		endcase

		//if we're in ADJ MODE,
		if(ADJ_d == 1) begin
			//if iterator points to the digit same as SEL,
			if ((iterator - 1'b1)== SEL_d) begin
				//finally, if the blinker is ON
				if(clk_blink == 1) begin
					//set value to 1011 so that seg shows blank
					value = 4'b1011;
				end
			end
		end

		case(value)
			4'b0000 : seg_reg = 8'b11000000;	//seg is assigned accordingly
			4'b0001 : seg_reg = 8'b11111001;
			4'b0010 : seg_reg = 8'b10100100;
			4'b0011 : seg_reg = 8'b10110000;
			4'b0100 : seg_reg = 8'b10011001;
			4'b0101 : seg_reg = 8'b10010010;
			4'b0110 : seg_reg = 8'b10000010;
			4'b0111 : seg_reg = 8'b11111000;
			4'b1000 : seg_reg = 8'b10000000;
			4'b1001 : seg_reg = 8'b10010000;
			4'b1011 : seg_reg = 8'b11111111; //blank
			//default to 0
			default : seg_reg = 8'b11000000;
		endcase

		iterator = iterator + 1;
	end

	assign seg_d = seg_reg;
	assign an_d = an_reg;

endmodule
