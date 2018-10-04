module MyPart1(iClk, iRst, iErrorCodes, iEnableDisplay, iFreezeDisplay, oHEX0, oHEX1, oHEX2, oHEX3);
	//define inputs and outputs
	input iClk, iRst, iEnableDisplay, iFreezeDisplay;
	input [1:0] iErrorCodes;
	output [6:0] oHEX0, oHEX1, oHEX2, oHEX3;

	//define timer counter and internal reset register
	wire [15:0] Timer_msec;
	reg iRstInternal;
	
	//instantiate
	DisplayTimerError dte1(.iClk(iClk), .iButtonError(iErrorCodes), .iEnable(iEnableDisplay), .iFreezeTimer(iFreezeDisplay), .iTimer_msec(Timer_msec), .oHEX0(oHEX0), .oHEX1(oHEX1), .oHEX2(oHEX2), .oHEX3(oHEX3));
	Timer t1(.iClk(iClk), .iRst(iRstInternal), .oTime_msec16(Timer_msec));
	
	//always check if the timer count is above 2781, if so, set to 0
	always@(Timer_msec)
	begin
	if (Timer_msec > 16'd2781) iRstInternal = 1'b1;
	else iRstInternal = 1'b0;
	end
	
endmodule