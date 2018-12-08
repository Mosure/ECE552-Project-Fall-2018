module reg_2bit(clk, rst, d, wen, q);
    input clk, rst, wen;
    input[1:0] d;
    output[1:0] q;

    dff bit0(.clk(clk), .rst(rst), .wen(wen), .d(d[0]), .q(q[0]));
    dff bit1(.clk(clk), .rst(rst), .wen(wen), .d(d[1]), .q(q[1]));

endmodule