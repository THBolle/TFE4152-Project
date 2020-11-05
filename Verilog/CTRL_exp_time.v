// This module's purpose is to let the user increase and decrease the exposure time and keep track of this value.
// It uses a base value of 10 ms and adds or subtracts from this value
`timescale 1ms / 1ns

module CTRL_exp_time(input Clk, Reset, Exp_increase, Exp_decrease,
	output reg [4:0] Exp_time);
	always @ (posedge Clk)
		begin
			if (Reset == 1)
				// Sets a base value for the exposure time
				Exp_time <= 10;
			else if (Exp_increase == 1 && Exp_time < 30) //Max Exp_time is 30ms 
				Exp_time <= Exp_time + 1;
			else if (Exp_decrease == 1 && Exp_time > 2) //Min Exp_time is 2ms
				Exp_time <= Exp_time -1;
		end
endmodule