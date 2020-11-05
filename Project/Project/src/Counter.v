// This module's purpose is to control how long the expose state lasts depending on the exposure time.
// It uses a counter that starts at 0, and increments it by 1 each clock period, which is 1 ms.
// Once the counter reaches endTime which is set by the exposure time, the FSM will have been in the expose state for the correct amount of time.
// Afterwards it sets Ovf5 to 1, which causes the FSM to switch to the Readout state.
	
`timescale 1ms / 1ns

module Counter (input wire Clk, Reset,
	input wire [4:0] endTime,
	input wire Start,
	output reg Ovf5);

	reg [4:0] ctr;
	logic ctr_finished;
	
	always @ (posedge Clk, posedge Reset)
		begin
			if (Reset) begin
				ctr <= 0;
				ctr_finished <= 0;
				Ovf5 <= 0;
				end		
			else if (Reset == 0 && Start == 1) begin // The Start signal initializes the counter
				ctr <= ctr + 1;
				end
			else if (Reset == 0	&& ctr > 0 && ctr != endTime) begin // Increments the counter by 1
				ctr <= ctr + 1;
				end
			else if (ctr == endTime ) begin	// Sets Ovf5 once the counter is finished
				Ovf5 <= 1;
				ctr <= 0;
				ctr_finished <= 1;
				end
			if (ctr_finished) begin	// Makes it so Ovf5 is only 1 for one clock period,
				Ovf5 <= 0;
				ctr_finished <= 0;
				end
		end
endmodule