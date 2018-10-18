module WriteDecoder_4_16(input [3:0] RegId, input WriteReg, output [15:0] Wordline);

wire [15:0] Int_Wordline;

assign Int_Wordline[0] = ~RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Int_Wordline[1] = ~RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Int_Wordline[2] = ~RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Int_Wordline[3] = ~RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Int_Wordline[4] = ~RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Int_Wordline[5] = ~RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Int_Wordline[6] = ~RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Int_Wordline[7] = ~RegId[0] & RegId[1] & RegId[2] & RegId[3];
assign Int_Wordline[8] = RegId[0] & ~RegId[1] & ~RegId[2] & ~RegId[3];
assign Int_Wordline[9] = RegId[0] & ~RegId[1] & ~RegId[2] & RegId[3];
assign Int_Wordline[10] = RegId[0] & ~RegId[1] & RegId[2] & ~RegId[3];
assign Int_Wordline[11] = RegId[0] & ~RegId[1] & RegId[2] & RegId[3];
assign Int_Wordline[12] = RegId[0] & RegId[1] & ~RegId[2] & ~RegId[3];
assign Int_Wordline[13] = RegId[0] & RegId[1] & ~RegId[2] & RegId[3];
assign Int_Wordline[14] = RegId[0] & RegId[1] & RegId[2] & ~RegId[3];
assign Int_Wordline[15] = RegId[0] & RegId[1] & RegId[2] & RegId[3];

assign Wordline = WriteReg ? Int_Wordline : 16'b0;

endmodule