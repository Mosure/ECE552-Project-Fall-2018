module decoder_6_64(in, out);
    input[5:0] in;
    output[63:0] out;
    
    wire[7:0] enLine;
    
    decoder_3_8 first(.in(in[5:3]), .out(enLine), .en(1'b1));
    
    decoder_3_8 last[7:0](.in(in[2:0]), .en(enLine[7:0]), .out(out));
    
endmodule