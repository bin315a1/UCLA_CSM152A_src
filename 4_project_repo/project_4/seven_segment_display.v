`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:		 Han Lee
// Create Date:    15:11:15 02/08/2019
// Module Name:    clocks
//////////////////////////////////////////////////////////////////////////////////
module display(
//=============inputs===========
	input clk_d,
	input numGamesPlayedState_d, // from switch, either 1'b1 or 1'b0, if 1'b1 then display should show the number of games played
	input numGamesPlayed_d, // how many games have been played so far
	input  [2:0] gameState_d,
	output [3:0] an_d;
	output [7:0] seg_d;
    );
	
	 //state of game
	 // gameState;
	 //0 : p1 turn
	 //1 : p2 turn
	 //2 : game over - draw
	 //3 : game over - p1 wins
	 //4 : game over - p2 wins	

	reg [2:0] iterator = 3'b001;	//iterator: iterates through the first~fourth digits, initialized to 1
	reg tempDig; // keep tracks of each digit
	reg [3:0] an_reg;
	reg [7:0] seg_reg;
	reg [3:0] value;	


	//iterate through anodes, 1 - 4, when 5 goes back to 1
	always @(posedge clk_d) begin
		if(iterator == 3'b101) begin
			iterator = 3'b001;
		end

		case(iterator)
			3'b001: an_reg = 4'b1110;	// anode 1
			3'b010: an_reg = 4'b1101;	// anode 2
			3'b011: an_reg = 4'b1011;	// anode 3
			3'b100: an_reg = 4'b0111;	// anode 4
		endcase

		//the game state is 2 -> game is over show: D R A W
		if(gameState_d==3'b010)begin
			case(iterator)
				3'b001: seg_reg = 8'b11010101;  // W : for the first anode
				3'b010: seg_reg = 8'b10001000;  // A : for the second anode
				3'b011: seg_reg = 8'b11111010;	// r : for the third anode
				3'b100: seg_reg = 8'b11000010;	// d : for the fourth anode; 
			endcase
			iterator = iterator + 1;
		end

		//the game state is 3 -> P1 has won: P 2 L 
		else if(gameState_d==3'b011)begin
			case(iterator)
				3'b001: seg_reg = 8'b11111111;  // blank
				3'b010: seg_reg = 8'b11110001;	// L
				3'b011: seg_reg = 8'b10100100;	// 2
				3'b100: seg_reg = 8'b10011000;	// P
			endcase
			iterator = iterator + 1;	
		end

		//the game state is 4 -> P1 has won: P 1 L
		else if(gameState_d==3'b100)begin
			case(iterator)
				3'b001: seg_reg = 8'b11111111;  // blank
				3'b010: seg_reg = 8'b11110001;	// L
				3'b011: seg_reg = 8'b11111001;	// 1
				3'b100: seg_reg = 8'b10011000;	// P
			endcase
			iterator = iterator + 1;
		end

		
		//if the desired switch got turned on to show how many games have been played so far
		else if(numGamesPlayedState_d==1'b1)begin
			// loop through the 
			while(numGamesPlayed_d >0 )begin
				//pick the desired anode based on the iterator
				case(iterator)
					3'b001: an_reg = 4'b1110;	// anode 1
					3'b010: an_reg = 4'b1101;	// anode 2
					3'b011: an_reg = 4'b1011;	// anode 3
					3'b100: an_reg = 4'b0111;	// anode 4
				endcase
				//assign the digit to the corresponding iterator
				case(iterator)
					3'b001: value = numGamesPlayed_d%10;
					3'b010: value = numGamesPlayed_d%10;
					3'b011: value = numGamesPlayed_d%10;
					3'b100: value = numGamesPlayed_d%10;	//value equals to the numbers from according digits
				endcase
		
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
					//default to blank
					default : seg_reg = 8'b11111111; //blank
				endcase
				numGamesPlayed_d= numGamesPlayed_d/10;
				iterator = iterator + 1;
			end
		end
		//if non of the state above, 7-seg-dis should show nothing 
		else beign
			case(iterator)
				3'b001: seg_reg = 8'b11111111;  // blank
				3'b010: seg_reg = 8'b11111111;  // blank
				3'b011: seg_reg = 8'b11111111;  // blank
				3'b100: seg_reg = 8'b11111111;  // blank
			endcase
			iterator = iterator + 1;
		end
	assign seg_d = seg_reg;
	assign an_d = an_reg;

endmodule
