module decoder_4_16(in, en, out);
    input en;
	input [3:0] in;
	output [15:0] out;
    
    wire[15:0] tempOut;

	assign tempOut[15] = in[3] & in[2] & in[1] & in[0];
	assign tempOut[14] = in[3] & in[2] & in[1] & ~in[0];
	assign tempOut[13] = in[3] & in[2] & ~in[1] & in[0];
	assign tempOut[12] = in[3] & in[2] & ~in[1] & ~in[0];
	assign tempOut[11] = in[3] & ~in[2] & in[1] & in[0];
	assign tempOut[10] = in[3] & ~in[2] & in[1] & ~in[0];
	assign tempOut[9] = in[3] & ~in[2] & ~in[1] & in[0];
	assign tempOut[8] = in[3] & ~in[2] & ~in[1] & ~in[0];
	assign tempOut[7] = ~in[3] & in[2] & in[1] & in[0];
	assign tempOut[6] = ~in[3] & in[2] & in[1] & ~in[0];
	assign tempOut[5] = ~in[3] & in[2] & ~in[1] & in[0];
	assign tempOut[4] = ~in[3] & in[2] & ~in[1] & ~in[0];
	assign tempOut[3] = ~in[3] & ~in[2] & in[1] & in[0];
	assign tempOut[2] = ~in[3] & ~in[2] & in[1] & ~in[0];
	assign tempOut[1] = ~in[3] & ~in[2] & ~in[1] & in[0];
	assign tempOut[0] = ~in[3] & ~in[2] & ~in[1] & ~in[0];
    
    assign out = en ? tempOut : 16'h0000;
    

endmodule
