module reg_8bit(clk, rst, d, wen, q);
    input clk, rst, wen;
    input[7:0] d;
    output[7:0] q;

    dff bit0(.clk(clk), .rst(rst), .wen(wen), .d(d[0]), .q(q[0]));
    dff bit1(.clk(clk), .rst(rst), .wen(wen), .d(d[1]), .q(q[1]));
    dff bit2(.clk(clk), .rst(rst), .wen(wen), .d(d[2]), .q(q[2]));
    dff bit3(.clk(clk), .rst(rst), .wen(wen), .d(d[3]), .q(q[3]));
    dff bit4(.clk(clk), .rst(rst), .wen(wen), .d(d[4]), .q(q[4]));
    dff bit5(.clk(clk), .rst(rst), .wen(wen), .d(d[5]), .q(q[5]));
    dff bit6(.clk(clk), .rst(rst), .wen(wen), .d(d[6]), .q(q[6]));
    dff bit7(.clk(clk), .rst(rst), .wen(wen), .d(d[7]), .q(q[7]));

endmodule