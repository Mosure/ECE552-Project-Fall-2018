module inc_3bit(in, out, cout);
    input[2:0] in;      // 3 bit input
    output[2:0] out;    // input + 1
	output cout;
    
    wire int1, int2;    // intermediate values for carry logic
    
    // 1st bit
    assign out[0] = in[0] ^ 1; 
    assign int1 = in[0] & 1;
    
    // 2nd bit
    assign out[1] = in[1] ^ int1;
    assign int2 = in[1] & int1;
    
    // 3rd bit
    assign out[2] = in[2] ^ int2;
	assign cout = in[2] & int2;
    
endmodule