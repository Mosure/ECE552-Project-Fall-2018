module decoder_3_8(in, en, out);
    input en;
	input [2:0] in;
	output [7:0] out;
    
    wire [7:0] tempOut;

	assign tempOut[7] = in[2] & in[1] & in[0];
	assign tempOut[6] = in[2] & in[1] & ~in[0];
	assign tempOut[5] = in[2] & ~in[1] & in[0];
	assign tempOut[4] = in[2] & ~in[1] & ~in[0];
	assign tempOut[3] = ~in[2] & in[1] & in[0];
	assign tempOut[2] = ~in[2] & in[1] & ~in[0];
	assign tempOut[1] = ~in[2] & ~in[1] & in[0];
	assign tempOut[0] = ~in[2] & ~in[1] & ~in[0];
    
    assign out = en ? tempOut : 8'h00;

endmodule
