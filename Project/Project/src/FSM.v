// The FSM's purpose is to change between the different states of the system

`timescale 1ms / 1ns

module FSM_exp_control (input wire Clk, Reset, Init, Ovf5,
	output reg Erase, Expose, NRE_1, NRE_2, ADC, Start,
	output logic Ovf4);
	
	// Defining the three states
	parameter [1:0] Idle = 0;
	parameter [1:0] Exposure = 1;
	parameter [1:0] Readout = 2;
	
	reg [1:0] state_current, state_next;
	reg [4:0] ctr;
	
	always @ (posedge Clk) begin // When Reset is 1, the state is changed to idle
		if (Reset == 1 || Ovf4) begin
			state_current <= Idle;
			ctr <= 0;
			Ovf4 <= 0;
			end
		else if (state_current == Readout && ctr < 9) begin // When we're in Readout we should count. Readout lasts for 9 clock periods
			ctr <= ctr + 1;
			state_current <= state_next;
			end
		else
			state_current <= state_next;
		
	end
	
	always @ (*)
		begin
			state_next <= state_current; //By default we shouldn't switch states
			
			//We start in Idle and set the outputs accordingly
			Erase <= 1;
			Expose <= 0;
			NRE_1 <= 1;
			NRE_2 <= 1;
			ADC <= 0;
			Start <= 0;
			
			// We set the different outputs depending on the state.
			case (state_current) 
				Idle : begin
					Ovf4 <= 0;
					ctr <= 0;
					if (Init == 1 && Reset == 0) begin // We only change the signals that differ from the default values.
						state_next <= Exposure;
						Erase <= 1;
						Start <= 1;
						Expose <= 0;
						end
					else
						state_next <= state_current;
					end	
				Exposure : begin
					// We only need to change these 3 signals
					Erase <= 0;
					Expose <= 1;
					Start <= 0;
					
					if (Reset == 1) begin // Reset brings us back to idle
						state_next <= Idle;
						end
					else if (Reset == 0 && Ovf5 == 1) begin // Ovf5 changes the state to Readout
						Expose <= 0;
						state_next <= Readout;
						end
					else if (Reset == 0 && Ovf5 == 0) begin // Otherwise we stay in Expose
						Expose <= 1;
						state_next <= state_current;
						end
					end
				Readout : begin
					Erase <= 0;
					Expose <= 0;
					NRE_1 <= 0;
					NRE_2 <= 1;
					ADC <= 0;
					Ovf4 <= 0;
					
					if (Reset)
						state_next <= Idle;
						
					// The Readout state consists of multiple clock periods where the output signals have different values
					// We use the counter to cycle through these.
					else if (ctr == 1) begin
						NRE_1 <= 0;
						NRE_2 <= 1;
						ADC <= 1;
						end
					else if (ctr == 2) begin
						NRE_1 <= 0;
						NRE_2 <= 1;
						ADC <= 0;
						end
					else if (ctr == 3) begin
						NRE_1 <= 1;
						NRE_2 <= 1;
						ADC <= 0;
						end
					else if (ctr == 4) begin
						NRE_1 <= 1;
						NRE_2 <= 0;
						ADC <= 0;
						end
					else if (ctr == 5) begin
						NRE_1 <= 1;
						NRE_2 <= 0;
						ADC <= 1;
						end
					else if (ctr == 6) begin
						NRE_1 <= 1;
						NRE_2 <= 0;
						ADC <= 0;
						end
					else if (ctr == 7) begin
						NRE_1 <= 1;
						NRE_2 <= 1;
						ADC <= 0; 
						Ovf4 <=1;
						state_next <= Idle;
						end
					end
			endcase
		end
endmodule	