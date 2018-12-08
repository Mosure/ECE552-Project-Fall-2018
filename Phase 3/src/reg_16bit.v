module reg_16bit(clk, rst, d, wen, q);
    input clk, rst, wen;
    input[15:0] d;
    output[15:0] q;

    dff bit0(.clk(clk), .rst(rst), .wen(wen), .d(d[0]), .q(q[0]));
    dff bit1(.clk(clk), .rst(rst), .wen(wen), .d(d[1]), .q(q[1]));
    dff bit2(.clk(clk), .rst(rst), .wen(wen), .d(d[2]), .q(q[2]));
    dff bit3(.clk(clk), .rst(rst), .wen(wen), .d(d[3]), .q(q[3]));
    dff bit4(.clk(clk), .rst(rst), .wen(wen), .d(d[4]), .q(q[4]));
    dff bit5(.clk(clk), .rst(rst), .wen(wen), .d(d[5]), .q(q[5]));
    dff bit6(.clk(clk), .rst(rst), .wen(wen), .d(d[6]), .q(q[6]));
    dff bit7(.clk(clk), .rst(rst), .wen(wen), .d(d[7]), .q(q[7]));
    dff bit8(.clk(clk), .rst(rst), .wen(wen), .d(d[8]), .q(q[8]));
    dff bit9(.clk(clk), .rst(rst), .wen(wen), .d(d[9]), .q(q[9]));
    dff bit10(.clk(clk), .rst(rst), .wen(wen), .d(d[10]), .q(q[10]));
    dff bit11(.clk(clk), .rst(rst), .wen(wen), .d(d[11]), .q(q[11]));
    dff bit12(.clk(clk), .rst(rst), .wen(wen), .d(d[12]), .q(q[12]));
    dff bit13(.clk(clk), .rst(rst), .wen(wen), .d(d[13]), .q(q[13]));
    dff bit14(.clk(clk), .rst(rst), .wen(wen), .d(d[14]), .q(q[14]));
    dff bit15(.clk(clk), .rst(rst), .wen(wen), .d(d[15]), .q(q[15]));

endmodule
