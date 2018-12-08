module reg_4bit(clk, rst, wen, d, q);
	input clk, rst, wen;
	input[3:0] d;
	output[3:0] q;

	dff bit0(.clk(clk), .rst(rst), .wen(wen), .d(d[0]), .q(q[0]));
	dff bit1(.clk(clk), .rst(rst), .wen(wen), .d(d[1]), .q(q[1]));
	dff bit2(.clk(clk), .rst(rst), .wen(wen), .d(d[2]), .q(q[2]));
	dff bit3(.clk(clk), .rst(rst), .wen(wen), .d(d[3]), .q(q[3]));

endmodule

