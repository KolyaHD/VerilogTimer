module assign2017(CLOCK_50, KEY, SW, LEDR, LEDG, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);
	input CLOCK_50;
	input [3:0] KEY;
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	output [17:0] LEDR;
	output [7:0] LEDG;
	
	//assign green LEDs to respective Keys
	assign LEDG[3:0] = ~KEY[3:0];
	
	//MyPart1 mp1(.iClk(CLOCK_50), .iRst(~KEY[0]), .iErrorCodes(SW[1:0]), .iEnableDisplay(SW[2]), .iFreezeDisplay(KEY[1]), .oHEX0(HEX0), .oHEX1(HEX1), .oHEX2(HEX2), .oHEX3(HEX3));
	
	//ButtonGenerationDisplay bgd1(.iClk(~KEY[3]), .iRst(~KEY[0]), .iBlankDisplay(~KEY[2]), .iNewButtonReq(SW[0]), .iChooseRandID(SW[1]), .oButtonRequested(), .oHEX(HEX4));
	
	PerceptionTimer pt1(.iClk(CLOCK_50), .iRst(~KEY[0]), .iChooseRandID(SW[0]), .iButtonsPressed(~KEY[3:1]), .oHEX0(HEX0), .oHEX1(HEX1), .oHEX2(HEX2), .oHEX3(HEX3), .oHEX4(HEX4), .oHEX5(HEX5), .oHEX6(HEX6), .oHEX7(HEX7));
	
endmodule