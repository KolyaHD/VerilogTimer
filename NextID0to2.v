module NextID0to2(iClk, iRst, iNext, oIDmod3);
	input iClk, 		// System clock
		iNext,		// Next value to be produced on 0->1 clock edge when ClockEnable=1
		iRst;			// Resets to starting state.

	output reg [1:0] oIDmod3; // The student ID value mod 3 being produced
	
	//current state and next state registers
	reg [2:0] cs, ns;
	
	//sting 27812073 %3 -> 21212010
	//set outputs and next state
	always@(cs)
	begin: stateIDnext
		case(cs)
		3'b000: begin
						ns = 3'b001;
						oIDmod3 = 2'b10;
					end
		3'b001: begin
						ns = 3'b010;
						oIDmod3 = 2'b01;
					end
		3'b010: begin
						ns = 3'b011;
						oIDmod3 = 2'b10;
					end
		3'b011: begin
						ns = 3'b100;
						oIDmod3 = 2'b01;
					end
		3'b100: begin
						ns = 3'b101;
						oIDmod3 = 2'b10;
					end
		3'b101: begin
						ns = 3'b110;
						oIDmod3 = 2'b00;
					end
		3'b110: begin
						ns = 3'b111;
						oIDmod3 = 2'b01;
					end
		3'b111: begin
						ns = 3'b000;
						oIDmod3 = 2'b00;
					end
		
		//default behaves as state 0
		default: begin
						ns = 3'b001;
						oIDmod3 = 2'b10;
					end
		endcase
		
		//to reset, next state is 0
		if (iRst) begin
						ns = 3'b000;
					end
		
		
	end
	
	//triggered with clock and if a new number is requested or rest is triggered
	//set current state equal to next state
	always@(posedge iClk & (iNext | iRst))
	begin: stateIDnextTrigger
		cs <= ns;
	end
	
	
	
endmodule
