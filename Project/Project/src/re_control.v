// Top level module
module re_control(input reg Init, Exp_increase, Exp_decrease, Reset, Clk,
	output wire Expose, Erase, ADC, NRE_1, NRE_2,
	output logic Ovf4, Ovf5);

	logic Start;
	logic [4:0] Exp_time;
	
	FSM_exp_control FSM(Clk, Reset, Init, Ovf5, Erase, Expose, NRE_1, NRE_2, ADC, Start, Ovf4);
	Counter C(Clk, Reset, Exp_time, Start, Ovf5);
	CTRL_exp_time CTRL_Exp(Clk, Reset, Exp_increase, Exp_decrease, Exp_time);
	
endmodule

