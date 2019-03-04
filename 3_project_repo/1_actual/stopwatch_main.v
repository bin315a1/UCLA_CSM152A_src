`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		 Han Lee
// Create Date:    17:34:16 02/12/2019
// Module Name:    clocks
//////////////////////////////////////////////////////////////////////////////////
module stopwatch_main(
	clk,
	btns,	//pause
	btnu,	//reset
	sw,
	seg,
	an
    );
	input clk;
	input [7:0] sw;	//[7:4] 	: NUM
							//[2] 	: ADJ
							//[1:0]	: SEL
							//[3] is unused
							
	//pre-debounced buttons
	input btns;		//center button: PAUSE
	input btnu;		//right button: RESET
	
	output [7:0] seg;	//value that one of the segment digit will show
	output [3:0] an;	//chooses the segment digit being modified
	
	//testing: set to 0s
	wire btns_deb;	//btns debounced
	wire btnu_deb;	//btnu debounced
	
	//three different clocks
	wire clk_1hz;	//for counter
	wire clk_2hz;	//for blinking in ADJ mode
						//might want to change it into a 2hz
	wire clk_500hz;//for refreshing display
	
	//reg of all four digits, initialized to zeroes
	wire [3:0] min_tens_m ;
	wire [3:0] min_ones_m ;
	wire [3:0] sec_tens_m ;
	wire [3:0] sec_ones_m ;
	
	/*
	//states
	parameter normalRun = 0;	//NORMAL RUN mode
	parameter pause = 1;			//PAUSED mode
	parameter adjustment = 2;	//ADJ mode
	reg [1:0] state = 0;			//reg for state initialize for normalRun
	*/
	
	//counter model:
	//inputs(2): clk, state
	
	//outputs(4): min_tens, min_ones, sec_tens, sec_ones
	counter onetwothree(.clk_c(clk_1hz), .reset_c(btnu_deb), .pause_c(btns_deb), .ADJ(sw[2]), .SEL(sw[1:0]), .NUM(sw[7:4]),.min_ones(min_ones_m), .min_tens(min_tens_m),.sec_ones(sec_ones_m), .sec_tens(sec_tens_m));
	clocks ticktock(.clk_cl(clk), .clk_500hz_cl(clk_500hz), .clk_1hz_cl(clk_1hz), .clk_2hz_cl(clk_2hz));
	debouncer debounce_pause (.button_in(btns), .clk_in(clk), .button_out(btns_deb));
	debouncer debounce_reset (.button_in(btnu), .clk_in(clk), .button_out(btnu_deb));
	display television (.clk_m_d(clk_500hz), .clk_blink(clk_2hz), .ADJ_d(sw[2]), .SEL_d(sw[1:0]), .min_tens_d(min_tens_m), .min_ones_d(min_ones_m), .sec_tens_d(sec_tens_m), .sec_ones_d(sec_ones_m), .an_d(an), .seg_d(seg));

endmodule
