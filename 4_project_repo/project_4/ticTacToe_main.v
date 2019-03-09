`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:27:24 03/05/2019 
// Design Name: 
// Module Name:    ticTacToe_main 
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
module ticTacToe_main(
	//inputs: clock, 5 buttons, reset switch
	input clk,	//main 100mhz clock
	input btns,
	input btnu,
	input btnl,
	input btnd,
	input btnr,
	input rst,  //this should be a switch , sw[0]
	input sw[1], // this is a swith that would show the number of games player on 7-Seg-Dis
	//outputs: 3 vgas, 2 syncs, segs, ans
	output vgaRed,
	output vgaGreen,
	output vgaBlue,
	output Hsync,
	output Vsync,
	output seg,
	output an
	//output test_p1,
	//output test_p2
    );
	 //clocks
	 wire clk_25Mhz, clk_500hz;
	 clockDivider cd(.clk_cd(clk), .clk_25Mhz_cd(clk_25Mhz), .clk_500hz_cd(clk_500hz));
	 
	 //player1 and player2 grid
	 wire [0:8] p1Grid;
	 wire [0:8] p2Grid;
	 //  0  1  2
	 //  3  4  5
	 //  6  7  8
	 
	 //current cursor
	 wire [3:0] cursorPosition;
	 // [3:2] : x coordinate, [1:0] : y coordinate
	 //			X
	 // 		00 01 02
	 //	00  x  x  x
	 //Y	01  x  x  x
	 //	02  x  x  x
	 wire [3:0] gameIncrement;
	 //state of game
	 wire [2:0] gameState;
	 //0 : p1 turn
	 //1 : p2 turn
	 //2 : game over - draw
	 //3 : game over - p1 wins
	 //4 : game over - p2 wins
	 
	 //enable display
	 wire en_display;
	 
	 vgaManager vm(.clk_25Mhz_vm(clk_25Mhz), .hsync_vm(hsync), .vsync_vm(vsync), .red(vgaRed), .green(vgaGreen), .blue(vgaBlue));
	 gameManager gm(.clk_gm(clk), .btns_gm(btns), .btnu_gm(btnu), .btnl_gm(btnl), .btnd_gm(btnd), .btnr_gm(btnr), .rst_gm(rst), .cursorPosition_gm(cursorPosition), .gameState_gm(gameState), .gameIncrement_gm(gameIncrement),.p1Grid_gm(p1Grid), .p2Grid_gm(p2Grid));
	seven_segment_display sd( .clk_d(clk_500hz) , .numGamesPlayedState_d(sw[1]) ,  .numGamesPlayed_d(gameIncrement), .gameState_d(gameState) , .an_d(an) , .seg_d(seg) )	
endmodule
