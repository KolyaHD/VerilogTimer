module FSM(iClk, iRst, iButtonsPressed, iTimer16, iButtonRequested, oResetTimer, oButtonError, 
			  oDisplayFrozenTimer, oBlankButtonDisplay, oShowTimerErrorDisplay, oNewButtonReq, oState);

	input iClk, iRst;
	input [2:0] iButtonsPressed; 	// button 2 100, button 1 010, button 0 001
	input [15:0] iTimer16;       	// time since oResetTimer becoming 0 in milliseconds 
	input [2:0] iButtonRequested; // button 2 100, button 1 010, button 0 001
	output reg 	oResetTimer, 				// zero timer value.
					oDisplayFrozenTimer, 	// freeze timer value and display this value or an error if it occurred.
					oBlankButtonDisplay, 	// when 1 button display is blank.
					oNewButtonReq, 			// a new button value will be generated on the next clock edge
					oShowTimerErrorDisplay;	// Show the frozen time or error (if oButton not 00)
	output reg [1:0] oButtonError;  		// 0 for no error, 1 wrong button pressed, 2 timeout reached with no button pressed.
	
	output [2:0] oState;					// state available only for debugging. 
	
	assign oState = state;
	
	//parameters for states
	parameter RESET_STATE=0,INITIAL_BLANK_STATE=1,DISPLAY_BUTTON_STATE=2,WAIT_FOR_PRESS=3,DISPLAY_RESPONSE_TIME=4,DISPLAY_ERROR=5,DISPLAY_TIMEOUT=6;
	
	//current state and next state register
	reg [2:0] state, next_state;   
	
	//
	always@(state, iTimer16, iButtonsPressed, iButtonRequested) 
	begin: FsmNextState
		
		
		//default values
		oBlankButtonDisplay=0;
		oResetTimer=0;
		oDisplayFrozenTimer=1;
		oNewButtonReq=0;
		oShowTimerErrorDisplay=0;
		next_state = state;
		oButtonError = 2'b00;
		
		//states
		case(state)
			RESET_STATE:
				//resets values for sequence
				begin
					oBlankButtonDisplay=1;
					oResetTimer=1;
					next_state = INITIAL_BLANK_STATE;
				end
			INITIAL_BLANK_STATE:
				//2 second pause, where nothing is displayed
				begin
					oBlankButtonDisplay=1;
					if (iTimer16 >= 2000) next_state = DISPLAY_BUTTON_STATE;
					else next_state = INITIAL_BLANK_STATE;
				end
			DISPLAY_BUTTON_STATE:
				//displayes button to be pressed
				begin
					oNewButtonReq=1;
					oResetTimer=1;
					next_state = WAIT_FOR_PRESS;
				end
			WAIT_FOR_PRESS:
				//reads button press input
				begin
					if (iButtonsPressed == iButtonRequested & iTimer16<5000) next_state=DISPLAY_RESPONSE_TIME;
					else if (iButtonsPressed != iButtonRequested & iButtonsPressed != 3'b000 & iTimer16<5000) next_state=DISPLAY_ERROR;
					else if (iTimer16>=5000) next_state=DISPLAY_TIMEOUT;
					else next_state = WAIT_FOR_PRESS;
				end
			DISPLAY_RESPONSE_TIME:
				//if correct button was pressed, display the response time
				begin
					oDisplayFrozenTimer=0;
					oShowTimerErrorDisplay=1;
					if (iButtonsPressed == iButtonRequested) next_state=DISPLAY_RESPONSE_TIME;
					else next_state = RESET_STATE;
				end
			DISPLAY_ERROR:
				//if the wrong button was pressed, display Error 1
				begin
					oButtonError = 2'b01;
					oShowTimerErrorDisplay=1;
					if (iButtonsPressed != iButtonRequested & iButtonsPressed != 3'b000) next_state=DISPLAY_ERROR;
					else next_state = RESET_STATE;
				end
			DISPLAY_TIMEOUT:
				//Timeout after 5 seconds, display Error 2
				begin
					oButtonError = 2'b10;
					oShowTimerErrorDisplay=1;
					if (iButtonsPressed == 3'b000) next_state=DISPLAY_TIMEOUT;
					else next_state = RESET_STATE;
				end
				
			//default to reset state
			default: next_state = RESET_STATE;
		endcase
	end
	
	// Update state on iClk edge
	always @(posedge iClk) 
	begin: FsmNextStateTrigger
		if (iRst) state <= RESET_STATE;
		else state <= next_state;
	end
endmodule