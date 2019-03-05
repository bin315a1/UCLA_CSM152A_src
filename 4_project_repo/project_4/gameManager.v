`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:01:02 03/05/2019 
// Design Name: 
// Module Name:    gameManager 
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
module gameManager(
	input clk_gm,
	input btns_gm,
	input btnu_gm,
	input btnl_gm,
	input btnd_gm,
	input btnr_gm,
	input rst_gm,

	output reg [3:0] cursorPosition_gm,
	output wire [2:0] gameState_gm,
	output reg [8:0] p1Grid_gm,
	output reg [8:0] p2Grid_gm
    );
	 
	 wire btns_db, btnu_db, btnl_db, btnd_db, btnr_db;
	 reg playerTurn;	//0 for p1, 1 for p2
	 
	//debouncers here
	debouncer d0(.clk_in(clk_gm), .button_in(btns_gm), .button_out(btns_db));
	debouncer d1(.clk_in(clk_gm), .button_in(btnu_gm), .button_out(btnu_db));
	debouncer d2(.clk_in(clk_gm), .button_in(btnl_gm), .button_out(btnl_db));
	debouncer d3(.clk_in(clk_gm), .button_in(btnd_gm), .button_out(btnd_db));
	debouncer d4(.clk_in(clk_gm), .button_in(btnr_gm), .button_out(btnr_db));
	
	
	/////////////////////////////////////////////////////////////////////////
	/////////////Moving the Cursors
	/////////////////////////////////////////////////////////////////////////
	initial begin
		cursorPosition_gm = 4'b0000;
		p1Grid_gm = 9'b000000000;
		p2Grid_gm = 9'b000000000;
	end
	
	//Moving the cursor in X direction: Left
	always@(posedge btnl_db or posedge btnr_db) begin
	
		//if the button pressed was left
		if(btnl_db == 1) begin
			//if cursor is already at leftmost, go to rightmost
			if(cursorPosition_gm [1:0] == 2'b00)
				cursorPosition_gm[1:0] <= 2'b10;
				
			//else if cursor is currently at center, go one left
			else if(cursorPosition_gm [1:0] == 2'b01)
				cursorPosition_gm[1:0] <= 2'b00;
				
			//else cursor is at the rightmost
			else
				cursorPosition_gm[1:0] <= 2'b01;
		end
		
		//else if the button pressed was right
		else begin	
			//if cursor is at leftmost, go one right
			if(cursorPosition_gm [1:0] == 2'b00)
				cursorPosition_gm[1:0] <= 2'b01;
				
			//else if cursor is currently at center, go one right
			else if(cursorPosition_gm [1:0] == 2'b01)
				cursorPosition_gm[1:0] <= 2'b10;
				
			//else cursor is already at the rightmost, go to leftmost
			else
				cursorPosition_gm[1:0] <= 2'b00;
		end
		
	end
	
	
	//Moving the cursor in Y direction
	always@(posedge btnu_db or posedge btnd_db) begin
	
		//if the button pressed was down
		if(btnu_db == 1) begin
			//if cursor is at top, go down
			if(cursorPosition_gm [3:2] == 2'b00)
				cursorPosition_gm[3:2] <= 2'b10;
				
			//else if cursor is currently at center, go up one
			else if(cursorPosition_gm [3:2] == 2'b01)
				cursorPosition_gm[3:2] <= 2'b00;
				
			//else cursor is at the bottom, go up one
			else
				cursorPosition_gm[3:2] <= 2'b01;
		end
		
		//else if the button pressed was up
		else begin
			//if cursor is at top, go down
			if(cursorPosition_gm [3:2] == 2'b00)
				cursorPosition_gm[3:2] <= 2'b01;
				
			//else if cursor is currently at center, go up one
			else if(cursorPosition_gm [3:2] == 2'b01)
				cursorPosition_gm[3:2] <= 2'b10;
				
			//else cursor is at the bottom, go up one
			else
				cursorPosition_gm[3:2] <= 2'b00;
		end
		
	end
	
	/////////////////////////////////////////////////////////////////////////
	/////////////Game Play
	/////////////////////////////////////////////////////////////////////////
	
	always@(posedge btns_gm)begin
	
		//if the center button's pressed while p1's turn
		if(gameState_gm == 0)begin
			//if the current spot of the cursor is not taken by p1 and p2
			if(p1Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] != 1 &&
				p2Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] != 1
				) begin
				p1Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] = 1;
			end
		end
		
		//if the center button's pressed while p2's turn
		else if(gameState_gm == 1) begin
			//if the current spot of the cursor is not taken by p1 and p2
			if(p1Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] != 1 &&
				p2Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] != 1
				)begin
				p2Grid_gm[3*cursorPosition_gm[3:2] + cursorPosition_gm[1:0]] = 1;
			end
		end
		
	end
	
	gameStatus gs(.clk_gs(clk_gm), .btns_gs(btns_gm), .p1Grid_gs(p1Grid_gm), .p2Grid_gs(p2Grid_gm), .gameState_gs(gameState_gm));
	
endmodule
