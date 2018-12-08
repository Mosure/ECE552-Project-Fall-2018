module PCregister(clk, rst, wen, nextPC, PC);
	input clk, rst, wen;
	input[15:0] nextPC;
	output[15:0] PC;
	
	//16 D flip flops store the current PC
	dff bit15(.clk(clk), .rst(rst), .d(nextPC[15]), .q(PC[15]), .wen(wen));
	dff bit14(.clk(clk), .rst(rst), .d(nextPC[14]), .q(PC[14]), .wen(wen));
	dff bit13(.clk(clk), .rst(rst), .d(nextPC[13]), .q(PC[13]), .wen(wen));
	dff bit12(.clk(clk), .rst(rst), .d(nextPC[12]), .q(PC[12]), .wen(wen));
	dff bit11(.clk(clk), .rst(rst), .d(nextPC[11]), .q(PC[11]), .wen(wen));
	dff bit10(.clk(clk), .rst(rst), .d(nextPC[10]), .q(PC[10]), .wen(wen));
	dff bit9(.clk(clk), .rst(rst), .d(nextPC[9]), .q(PC[9]), .wen(wen));
	dff bit8(.clk(clk), .rst(rst), .d(nextPC[8]), .q(PC[8]), .wen(wen));
	dff bit7(.clk(clk), .rst(rst), .d(nextPC[7]), .q(PC[7]), .wen(wen));
	dff bit6(.clk(clk), .rst(rst), .d(nextPC[6]), .q(PC[6]), .wen(wen));
	dff bit5(.clk(clk), .rst(rst), .d(nextPC[5]), .q(PC[5]), .wen(wen));
	dff bit4(.clk(clk), .rst(rst), .d(nextPC[4]), .q(PC[4]), .wen(wen));
	dff bit3(.clk(clk), .rst(rst), .d(nextPC[3]), .q(PC[3]), .wen(wen));
	dff bit2(.clk(clk), .rst(rst), .d(nextPC[2]), .q(PC[2]), .wen(wen));
	dff bit1(.clk(clk), .rst(rst), .d(nextPC[1]), .q(PC[1]), .wen(wen));
	dff bit0(.clk(clk), .rst(rst), .d(nextPC[0]), .q(PC[0]), .wen(wen));
	
endmodule
