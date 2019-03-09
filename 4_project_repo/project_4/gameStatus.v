`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:04:59 03/05/2019 
// Design Name: 
// Module Name:    gameStatus 
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
module gameStatus(
	input clk_gs,
	input btns_gs,
	input [0:8] p1Grid_gs,
	input [0:8] p2Grid_gs,
	output reg [2:0] gameState_gs,
	output reg [3:0] gameIncrement_gs // counts the number of games player, it will increment if either of the player wins or the game is draw
    );

	//win- horizontal line
	parameter win1 = 9'b111000000;
	parameter win2 = 9'b000111000;
	parameter win3 = 9'b000000111;
	//win- vertical line
	parameter win4 = 9'b100100100;
	parameter win5 = 9'b010010010;
	parameter win6 = 9'b001001001;
	//win- diagonal line
	parameter win7 = 9'b100010001;
	parameter win8 = 9'b001010100;
	
	initial begin
		gameState_gs = 0;
		gameIncrement_gs=0;
	end
	
	//check if the game is over: draw or either winning.
	always@(posedge clk_gs or posedge btns_gs) begin
	
		//change player turn when the center button is pressed
		if(btns_gs ==1) begin
			if(gameState_gs==0)
				gameState_gs = 1;
			else if(gameState_gs == 1)
				gameState_gs = 0;
		end
		
		//if up button wasn't pressed
		else begin
			//check if draw
			if(p1Grid_gs + p2Grid_gs == 9'b111111111)begin
				gameState_gs = 2;
				gameIncrement_gs=gameIncrement_gs+ 3'b001;
			end
			
			//check if anyone won
			else begin
			
				//check for p1
				if(gameState_gs == 0) begin
					case(p1Grid_gs)
						//if it matches any of the parameters, p1 wins
							win1,win2,win3,win4,win5,win6,win7,win8: gameState_gs = 3;
							gameIncrement_gs=gameIncrement_gs+ 3'b001;
						//else the state stays the same
						default: gameState_gs = 0;
					endcase
				end
				
				//check for p2
				else if(gameState_gs == 1)begin
					case(p2Grid_gs)
					//if it matches any of the parameters, p1 wins
						win1,win2,win3,win4,win5,win6,win7,win8: gameState_gs = 4;	
						gameIncrement_gs=gameIncrement_gs+ 3'b001;
					//else the state stays the same
					default: gameState_gs = 1;
					endcase
				end
			end
		end

	end

endmodule
