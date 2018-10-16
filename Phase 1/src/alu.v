
module alu(op1,op2,aluop,Flag,alu_out);
input [15:0] op1;
input [15:0] op2;
input [3:0] aluop;
output [15:0] alu_out;
output [2:0] Flag;

wire [15:0] out0;
wire [15:0] out1;
wire [15:0] out2;
wire [15:0] out3;
wire [15:0] out4;
wire [15:0] out5;
wire [15:0] out6;
wire [15:0] out7;
wire [15:0] out8;
wire [15:0] out9;

wire Ovfl0,Ovfl1;

adder_16bit add0( .A(op1),
	        .B(op2),
		.Sum(out0),
		.Ovfl(Ovfl0)
);

sub_16bit sub0( .A(op1),
	        .B(op2),
		.Sum(out1),
		.Ovfl(Ovfl1)
);

assign out2 = op1 ^ op2;

Red_adder red_add(.A(op1),
	        .B(op2),
		.Sum(out3)	
);

shifter shifter1( .in(op1),
	        .shift(op2[3:0]),
		.mode(2'b00),
		.out(out4)
);
shifter shifter2( .in(op1),
	        .shift(op2[3:0]),
		.mode(2'b01),
		.out(out5)
);
shifter shifter3( .in(op1),
	        .shift(op2[3:0]),
		.mode(2'b10),
		.out(out6)
);

paddsb_4bit paddsb0( .A(op1[3:0]),
	        .B(op2[3:0]),
		.Sum(out7[3:0])
);
paddsb_4bit paddsb1( .A(op1[7:4]),
	        .B(op2[7:4]),
		.Sum(out7[7:4])
);
paddsb_4bit paddsb2( .A(op1[11:8]),
	        .B(op2[11:8]),
		.Sum(out7[11:8])
);
paddsb_4bit paddsb3( .A(op1[15:12]),
	        .B(op2[15:12]),
		.Sum(out7[15:12])
);

assign out8 = (op1[15:0] & 16'hFF00) | op2[7:0];
assign out9 = (op1[15:0] & 16'h00FF) | (op2[7:0] << 8);

assign Flag[2] = ~(|alu_out);			//Z Flag
assign Flag[1] = (aluop[0]) ? Ovfl1 : Ovfl0;	//V Flag
assign Flag[0] = alu_out[15];			//N Flag

wire [9:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15;

assign in0 = {out9[0],out8[0],out7[0],out6[0],out5[0],out4[0],out3[0],out2[0],out1[0],out0[0]};
assign in1 = {out9[1],out8[1],out7[1],out6[1],out5[1],out4[1],out3[1],out2[1],out1[1],out0[1]};
assign in2 = {out9[2],out8[2],out7[2],out6[2],out5[2],out4[2],out3[2],out2[2],out1[2],out0[2]};
assign in3 = {out9[3],out8[3],out7[3],out6[3],out5[3],out4[3],out3[3],out2[3],out1[3],out0[3]};
assign in4 = {out9[4],out8[4],out7[4],out6[4],out5[4],out4[4],out3[4],out2[4],out1[4],out0[4]};
assign in5 = {out9[5],out8[5],out7[5],out6[5],out5[5],out4[5],out3[5],out2[5],out1[5],out0[5]};
assign in6 = {out9[6],out8[6],out7[6],out6[6],out5[6],out4[6],out3[6],out2[6],out1[6],out0[6]};
assign in7 = {out9[7],out8[7],out7[7],out6[7],out5[7],out4[7],out3[7],out2[7],out1[7],out0[7]};
assign in8 = {out9[8],out8[8],out7[8],out6[8],out5[8],out4[8],out3[8],out2[8],out1[8],out0[8]};
assign in9 = {out9[9],out8[9],out7[9],out6[9],out5[9],out4[9],out3[9],out2[9],out1[9],out0[9]};
assign in10 = {out9[10],out8[10],out7[10],out6[10],out5[10],out4[10],out3[10],out2[10],out1[10],out0[10]};
assign in11 = {out9[11],out8[11],out7[11],out6[11],out5[11],out4[11],out3[11],out2[11],out1[11],out0[11]};
assign in12 = {out9[12],out8[12],out7[12],out6[12],out5[12],out4[12],out3[12],out2[12],out1[12],out0[12]};
assign in13 = {out9[13],out8[13],out7[13],out6[13],out5[13],out4[13],out3[13],out2[13],out1[13],out0[13]};
assign in14 = {out9[14],out8[14],out7[14],out6[14],out5[14],out4[14],out3[14],out2[14],out1[14],out0[14]};
assign in15 = {out9[15],out8[15],out7[15],out6[15],out5[15],out4[15],out3[15],out2[15],out1[15],out0[15]};


mux_10_1 m0(
.in(in0),
.select(aluop),
.out(alu_out[0])
);
mux_10_1 m1(
.in(in1),
.select(aluop),
.out(alu_out[1])
);
mux_10_1 m2(
.in(in2),
.select(aluop),
.out(alu_out[2])
);
mux_10_1 m3(
.in(in3),
.select(aluop),
.out(alu_out[3])
);
mux_10_1 m4(
.in(in4),
.select(aluop),
.out(alu_out[4])
);
mux_10_1 m5(
.in(in5),
.select(aluop),
.out(alu_out[5])
);
mux_10_1 m6(
.in(in6),
.select(aluop),
.out(alu_out[6])
);
mux_10_1 m7(
.in(in7),
.select(aluop),
.out(alu_out[7])
);
mux_10_1 m8(
.in(in8),
.select(aluop),
.out(alu_out[8])
);
mux_10_1 m9(
.in(in9),
.select(aluop),
.out(alu_out[9])
);
mux_10_1 m10(
.in(in10),
.select(aluop),
.out(alu_out[10])
);
mux_10_1 m11(
.in(in11),
.select(aluop),
.out(alu_out[11])
);
mux_10_1 m12(
.in(in12),
.select(aluop),
.out(alu_out[12])
);
mux_10_1 m13(
.in(in13),
.select(aluop),
.out(alu_out[13])
);
mux_10_1 m14(
.in(in14),
.select(aluop),
.out(alu_out[14])
);
mux_10_1 m15(
.in(in15),
.select(aluop),
.out(alu_out[15])
);

endmodule

/////////////////////////////////////////////////////////////////

module adder(
input a,
input b,
input cin,
output cout,
output s);

wire  p,q,r;

	assign p = b ^ a;
	assign s = p ^ cin;
 
	assign q = p & cin;
	assign r = a & b;
	assign cout = r | q;

endmodule

////////////////////////////////////////////////////////////////



module paddsb_4bit(
input [3:0] A,B,
output [3:0] Sum
);

wire [3:0] G;
wire [3:0] P;
wire [4:0] C;
wire [3:0] S;

assign G = A & B;
assign P = A ^ B;

assign C[0] = 1'b0;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign Cout = G[3] | (P[3] & C[3]);

assign S = P ^ C;

assign Ovfl = C[3] ^ Cout;

assign Sum = Ovfl?(B[3]?4'b1000:4'b0111):S;


endmodule
//////////////////////////////////////////////////////////////////////

module adder_4bit(
input [3:0] A,B,
input Cin,
output [3:0] Sum,
output Cout
);

wire [3:0] G;
wire [3:0] P;
wire [4:0] C;
wire [3:0] S;

assign G = A & B;
assign P = A ^ B;

assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign Cout = G[3] | (P[3] & C[3]);

assign S = P ^ C;
   
assign Ovfl = C[3] ^ Cout;

assign Sum = Ovfl?(B[3]?4'b1000:4'b0111):S;


endmodule
/////////////////////////////////////////////////
module cla_adder_4bit(
input [3:0] A,B,
input Cin,
output [3:0] Sum,
output Gen, Prop
);

wire [3:0] G;
wire [3:0] P;
wire [3:0] C;

assign G = A & B;
assign P = A ^ B;

assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);


assign Sum = P ^ C;
    
assign Prop = P[3] & P[2] & P[1] & P[0];
assign Gen = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);


endmodule

/////////////////////////////////////////

module Red_adder(
input [15:0] A,B,
output [15:0] Sum
);

wire [7:0] S1,S2;
wire [11:0] S3;
wire [11:0] ex1,ex2;
wire [1:0] P1,G1,C1;
wire [1:0] P2,G2,C2;
wire [2:0] P3,G3,C3;

cla_adder_4bit a1(
.A(A[3:0]),
.B(B[3:0]),
.Cin(1'b0),
.Sum(S1[3:0]),
.Prop(P1[0]),
.Gen(G1[0])
);

assign C1[0] = G1[0] | (P1[0] & 1'b0);

cla_adder_4bit a2(
.A(A[7:4]),
.B(B[7:4]),
.Cin(C1[0]),
.Sum(S1[7:4]),
.Prop(P1[1]),
.Gen(G1[1])
);

assign C1[1] = G1[1] | (P1[1] & C1[1]);

cla_adder_4bit a3(
.A(A[11:8]),
.B(B[11:8]),
.Cin(1'b0),
.Sum(S2[3:0]),
.Prop(P2[0]),
.Gen(G2[0])
);

assign C2[0] = G2[0] | (P2[0] & 1'b0);

cla_adder_4bit a4(
.A(A[15:12]),
.B(B[15:12]),
.Cin(C2[0]),
.Sum(S2[7:4]),
.Prop(P2[1]),
.Gen(G2[1])
);

assign C2[1] = G2[1] | (P2[1] & C2[1]);

assign ex1 = {3'b000, C1[1], S1};
assign ex2 = {3'b000, C2[1], S2};

cla_adder_4bit a5(
.A(ex1[3:0]),
.B(ex2[3:0]),
.Cin(1'b0),
.Sum(S3[3:0]),
.Prop(P3[0]),
.Gen(G3[0])
);

assign C3[0] = G3[0] | (P3[0] & 1'b0);

cla_adder_4bit a6(
.A(ex1[7:4]),
.B(ex2[7:4]),
.Cin(C3[0]),
.Sum(S3[7:4]),
.Prop(P3[1]),
.Gen(G3[1])
);

assign C3[1] = G3[1] | (P3[1] & C3[1]);

cla_adder_4bit a7(
.A(ex1[11:8]),
.B(ex2[11:8]),
.Cin(C3[1]),
.Sum(S3[11:8]),
.Prop(P3[2]),
.Gen(G3[2])
);
assign C3[2] = G3[2] | (P3[2] & C3[2]);

assign Sum = $signed(S3[9:0]);


endmodule

///////////////////////////////////////////////////

module adder_16bit(
input [15:0] A,B,
output [15:0] Sum,
output Ovfl
);

wire [4:0] G;
wire [4:0] P;
wire [4:0] C;
wire [15:0] S;

cla_adder_4bit a0(
.A(A[3:0]),
.B(B[3:0]),
.Cin(1'b0),
.Sum(S[3:0]),
.Prop(P[0]),
.Gen(G[0])
);

assign C[0] = G[0] | (P[0] & 1'b0);

cla_adder_4bit a1(
.A(A[7:4]),
.B(B[7:4]),
.Cin(C[0]),
.Sum(S[7:4]),
.Prop(P[1]),
.Gen(G[1])
);

assign C[1] = G[1] | (P[1] & C[1]);

cla_adder_4bit a2(
.A(A[11:8]),
.B(B[11:8]),
.Cin(C[1]),
.Sum(S[11:8]),
.Prop(P[2]),
.Gen(G[2])
);
assign C[2] = G[2] | (P[2] & C[2]);

cla_adder_4bit a3(
.A(A[15:12]),
.B(B[15:12]),
.Cin(C[2]),
.Sum(S[15:12]),
.Prop(P[3]),
.Gen(G[3])
);
assign C[3] = G[3] | (P[3] & C[3]);

assign Ovfl = (A[15] ^ B[15]) ? 1'b0 : (A[15] ^ S[15])? 1'b1: 1'b0;

assign Sum = Ovfl?(B[15]?16'b1000000000000000:16'b0111111111111111):S;


endmodule

/////////////////////////////////////////////////////////////

module sub_16bit(
input [15:0] A,B,
output [15:0] Sum,
output Ovfl
);


wire [15:0] Bbar;
assign Bbar = ~B;

wire [4:0] G;
wire [4:0] P;
wire [4:0] C;
wire [15:0] S;

cla_adder_4bit a0(
.A(A[3:0]),
.B(Bbar[3:0]),
.Cin(1'b1),
.Sum(S[3:0]),
.Prop(P[0]),
.Gen(G[0])
);

assign C[0] = G[0] | (P[0] & 1'b0);

cla_adder_4bit a1(
.A(A[7:4]),
.B(Bbar[7:4]),
.Cin(C[0]),
.Sum(S[7:4]),
.Prop(P[1]),
.Gen(G[1])
);

assign C[1] = G[1] | (P[1] & C[1]);

cla_adder_4bit a2(
.A(A[11:8]),
.B(Bbar[11:8]),
.Cin(C[1]),
.Sum(S[11:8]),
.Prop(P[2]),
.Gen(G[2])
);
assign C[2] = G[2] | (P[2] & C[2]);

cla_adder_4bit a3(
.A(A[15:12]),
.B(Bbar[15:12]),
.Cin(C[2]),
.Sum(S[15:12]),
.Prop(P[3]),
.Gen(G[3])
);
assign C[3] = G[3] | (P[3] & C[3]);

assign Ovfl = (A[15] ^ B[15]) ? 1'b0 : (A[15] ^ S[15])? 1'b1: 1'b0;

assign Sum = Ovfl?(B[15]?16'b1000000000000000:16'b0111111111111111):S;


endmodule

module mux_10_1(
    input [9:0] in,
    input [3:0] select,
    output out
);

assign out = (~select[3] & ~select[2] & ~select[1] & ~select[0] & in[0]) | (~select[3] & ~select[2] & ~select[1] & select[0] & in[1]) | (~select[3] & ~select[2] & select[1] & ~select[0] & in[2]) | (~select[3] & ~select[2] & select[1] & select[0] & in[3]) | (~select[3] & select[2] & ~select[1] & ~select[0] & in[4]) |( ~select[3] & select[2] & ~select[1] & select[0] & in[5]) | (~select[3] & select[2] & select[1] & ~select[0] & in[6]) |(~select[3] & select[2] & select[1] & select[0] & in[7])|(select[3] & ~select[2] & ~select[1] & ~select[0] & in[8])|(select[3] & ~select[2] & ~select[1] & select[0] & in[9]);
endmodule
