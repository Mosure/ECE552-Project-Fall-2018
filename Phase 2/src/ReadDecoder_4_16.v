module ReadDecoder_4_16(input [3:0] RegId, output [15:0] Wordline);

assign Wordline[0] = ~RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Wordline[1] = ~RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Wordline[2] = ~RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Wordline[3] = ~RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Wordline[4] = ~RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Wordline[5] = ~RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Wordline[6] = ~RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Wordline[7] = ~RegId[0] & RegId[1] & RegId[2] & RegId[3];
assign Wordline[8] = RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Wordline[9] = RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Wordline[10] = RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Wordline[11] = RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Wordline[12] = RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Wordline[13] = RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Wordline[14] = RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Wordline[15] = RegId[0] & RegId[1] & RegId[2] & RegId[3];

endmodule