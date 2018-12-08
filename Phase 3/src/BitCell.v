module BitCell( input clk, input rst, input D, input WriteEnable, input ReadEnable1, input
ReadEnable2, inout Bitline1, inout Bitline2);

    wire Q;

    dff iDFF(.clk(clk), .rst(rst), .wen(WriteEnable), .q(Q), .d(D));

    assign Bitline1 = (ReadEnable1) ? Q : 1'bz;
    assign Bitline2 = (ReadEnable2) ? Q : 1'bz;

endmodule
