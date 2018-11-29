module decoder_7_128(in, out);
    input[6:0] in;
    output[127:0] out;
    
    wire[7:0] enLine;
    
    decoder_3_8 first(.in(in[6:4]), .out(enLine), .en(1'b1));
    
    decoder_4_16 last[7:0](.in(in[3:0]), .en(enLine[7:0]), .out(out));
    
endmodule