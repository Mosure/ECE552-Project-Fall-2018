module FlagRegisters(clk, rst, FlagIn, zEn, nEn, vEn, FlagOut);
	input clk, rst, zEn, nEn, vEn;
	input[2:0] FlagIn;
	output[2:0] FlagOut;
	//Flag Order is ZVN

	dff zRegister(.clk(clk), .rst(rst), .d(FlagIn[2]), .wen(zEn), .q(FlagOut[2]));
	dff vRegister(.clk(clk), .rst(rst), .d(FlagIn[1]), .wen(vEn), .q(FlagOut[1]));
	dff nRegister(.clk(clk), .rst(rst), .d(FlagIn[0]), .wen(nEn), .q(FlagOut[0]));
	
endmodule
