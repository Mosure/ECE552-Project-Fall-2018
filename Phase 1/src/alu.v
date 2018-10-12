
module alu(op1,op2,aluop,Z,N,V,alu_out);
input [15:0] op1;
input [15:0] op2;
input [2:0] aluop;
output [15:0] alu_out;
output Z,N,V;

wire [15:0] out0;
wire [15:0] out1;
wire [15:0] out2;
wire [15:0] out3;
wire [15:0] out4;
wire [15:0] out5;
wire [15:0] out6;
wire [15:0] out7;
wire Ovfl0,Ovfl1;

adder_16bit add0( .A(op1),
	        .B(op2),
		.Cin(1'b0),
		.Sum(out0),
		.Ovfl(Ovfl0)
);

sub_16bit sub0( .A(op1),
	        .B(op2),
		.Cin(1'b1),
		.Sum(out1),
		.Ovfl(Ovfl1)
);

xor(out2[15],op1[15],op2[15]);
xor(out2[14],op1[14],op2[14]);
xor(out2[13],op1[13],op2[13]);
xor(out2[12],op1[12],op2[12]);
xor(out2[11],op1[11],op2[11]);
xor(out2[10],op1[10],op2[10]);
xor(out2[9],op1[9],op2[9]);
xor(out2[8],op1[8],op2[8]);
xor(out2[7],op1[7],op2[7]);
xor(out2[6],op1[6],op2[6]);
xor(out2[5],op1[5],op2[5]);
xor(out2[4],op1[4],op2[4]);
xor(out2[3],op1[3],op2[3]);
xor(out2[2],op1[2],op2[2]);
xor(out2[1],op1[1],op2[1]);
xor(out2[0],op1[0],op2[0]);


Red_adder red_add(.A(op1),
	        .B(op2),
		.Cin(1'b0),
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
		.Cin(1'b0),
		.Sum(out7[3:0])
);
paddsb_4bit paddsb1( .A(op1[7:4]),
	        .B(op2[7:4]),
		.Cin(1'b0),
		.Sum(out7[7:4])
);
paddsb_4bit paddsb2( .A(op1[11:8]),
	        .B(op2[11:8]),
		.Cin(1'b0),
		.Sum(out7[11:8])
);
paddsb_4bit paddsb3( .A(op1[15:12]),
	        .B(op2[15:12]),
		.Cin(1'b0),
		.Sum(out7[15:12])
);

assign Z = ~(alu_out[15] | alu_out[14] | alu_out[13] | alu_out[12] |  alu_out[11] | alu_out[10] | alu_out[9] | alu_out[8] |  alu_out[7] | alu_out[6] | alu_out[5] | alu_out[4] |  alu_out[3] | alu_out[2] | alu_out[1] | alu_out[0]);
assign N = (aluop == 3'b000)? out0[15]: (aluop == 3'b001)? out1[15]: N;
assign V = (aluop == 3'b000)? Ovfl1: (aluop == 3'b001)? Ovfl0: V;


wire [7:0] in0,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15;

assign in0 = {out7[0],out6[0],out5[0],out4[0],out3[0],out2[0],out1[0],out0[0]};
assign in1 = {out7[1],out6[1],out5[1],out4[1],out3[1],out2[1],out1[1],out0[1]};
assign in2 = {out7[2],out6[2],out5[2],out4[2],out3[2],out2[2],out1[2],out0[2]};
assign in3 = {out7[3],out6[3],out5[3],out4[3],out3[3],out2[3],out1[3],out0[3]};
assign in4 = {out7[4],out6[4],out5[4],out4[4],out3[4],out2[4],out1[4],out0[4]};
assign in5 = {out7[5],out6[5],out5[5],out4[5],out3[5],out2[5],out1[5],out0[5]};
assign in6 = {out7[6],out6[6],out5[6],out4[6],out3[6],out2[6],out1[6],out0[6]};
assign in7 = {out7[7],out6[7],out5[7],out4[7],out3[7],out2[7],out1[7],out0[7]};
assign in8 = {out7[8],out6[8],out5[8],out4[8],out3[8],out2[8],out1[8],out0[8]};
assign in9 = {out7[9],out6[9],out5[9],out4[9],out3[9],out2[9],out1[9],out0[9]};
assign in10 = {out7[10],out6[10],out5[10],out4[10],out3[10],out2[10],out1[10],out0[10]};
assign in11 = {out7[11],out6[11],out5[11],out4[11],out3[11],out2[11],out1[11],out0[11]};
assign in12 = {out7[12],out6[12],out5[12],out4[12],out3[12],out2[12],out1[12],out0[12]};
assign in13 = {out7[13],out6[13],out5[13],out4[13],out3[13],out2[13],out1[13],out0[13]};
assign in14 = {out7[14],out6[14],out5[14],out4[14],out3[14],out2[14],out1[14],out0[14]};
assign in15 = {out7[15],out6[15],out5[15],out4[15],out3[15],out2[15],out1[15],out0[15]};

/*
assign in17 = {6'b000000,out1[15],out0[15]};
assign in18 = {6'b000000,Ovfl1,Ovfl0};



mux_8_1 m17(
.in(in17),
.select(aluop),
.out(N)
);

mux_8_1 m18(
.in(in18),
.select(aluop),
.out(V)
);
*/
mux_8_1 m0(
.in(in0),
.select(aluop),
.out(alu_out[0])
);
mux_8_1 m1(
.in(in1),
.select(aluop),
.out(alu_out[1])
);
mux_8_1 m2(
.in(in2),
.select(aluop),
.out(alu_out[2])
);
mux_8_1 m3(
.in(in3),
.select(aluop),
.out(alu_out[3])
);
mux_8_1 m4(
.in(in4),
.select(aluop),
.out(alu_out[4])
);
mux_8_1 m5(
.in(in5),
.select(aluop),
.out(alu_out[5])
);
mux_8_1 m6(
.in(in6),
.select(aluop),
.out(alu_out[6])
);
mux_8_1 m7(
.in(in7),
.select(aluop),
.out(alu_out[7])
);
mux_8_1 m8(
.in(in8),
.select(aluop),
.out(alu_out[8])
);
mux_8_1 m9(
.in(in9),
.select(aluop),
.out(alu_out[9])
);
mux_8_1 m10(
.in(in10),
.select(aluop),
.out(alu_out[10])
);
mux_8_1 m11(
.in(in11),
.select(aluop),
.out(alu_out[11])
);
mux_8_1 m12(
.in(in12),
.select(aluop),
.out(alu_out[12])
);
mux_8_1 m13(
.in(in13),
.select(aluop),
.out(alu_out[13])
);
mux_8_1 m14(
.in(in14),
.select(aluop),
.out(alu_out[14])
);
mux_8_1 m15(
.in(in15),
.select(aluop),
.out(alu_out[15])
);
/*
always @(*)

case(aluop)

//ADD
3'b000: 
begin
 alu_out <= out0;
 V <= Ovfl0;
 N <= out0[15];
end

//SUB
3'b001: 
begin
 alu_out <= out1;
 V <= Ovfl1;
 N <= out1[15];
end

//XOR
3'b010: 
begin
alu_out <= out2;
V1<= V1;
N1 <= N1;
end

//Red
3'b011:
begin
alu_out <= out3;
V1 <= V1;
N1 <= N1;
end

//SLL
3'b100:
begin
alu_out <= out4;
V1 <= V1;
N1 <= N1;
end

//SRA
3'b101:
begin
alu_out <= out5;
V1 <= V1;
N1 <= N1;
end

//ROR
3'b110:
begin
alu_out <= out6;
V1 <= V1;
N1 <= N1;
end

//PADDSB
3'b111:
begin
alu_out <= out7;
V1 <= V1;
N1 <= N1;
end

endcase
*/
endmodule

/////////////////////////////////////////////////////////////////

module adder(
input a,
input b,
input cin,
output cout,
output s);

wire  p,q,r;

	xor (p,b,a);
	xor (s,p,cin);
 
	and(q,p,cin);
	and(r,a,b);
	or(cout,r,q);

endmodule

////////////////////////////////////////////////////////////////



module paddsb_4bit(
input [3:0] A,B,
input Cin,
output [3:0] Sum
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

xor(Ovfl,C[3],Cout);

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
    
//assign Prop = P[3] & P[2] & P[1] & P[0];
//assign Gen = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);


xor(Ovfl,C[3],Cout);

assign Sum = Ovfl?(B[3]?4'b1000:4'b0111):S;

endmodule


/////////////////////////////////////////

module Red_adder(
input [15:0] A,B,
input Cin,
output [15:0] Sum
);

wire [7:0] S1,S2;
wire [11:0] S3;
wire [3:0] ex1, ex2;
wire c1,cout1,c2,cout2,c3,cout3,c4,c5;



adder_4bit a1(
.A(A[3:0]),
.B(B[3:0]),
.Cin(1'b0),
.Sum(S1[3:0]),
.Cout(c1)
);

adder_4bit a2(
.A(A[7:4]),
.B(B[7:4]),
.Cin(c1),
.Sum(S1[7:4]),
.Cout(cout1)
);

adder_4bit a3(
.A(A[11:8]),
.B(B[11:8]),
.Cin(1'b0),
.Sum(S2[3:0]),
.Cout(c2)
);

adder_4bit a4(
.A(A[15:12]),
.B(B[15:12]),
.Cin(c2),
.Sum(S2[7:4]),
.Cout(cout2)
);

assign ex1 = {3'b000, cout1};
assign ex2 = {3'b000, cout2};

adder_4bit a5(
.A(S1[3:0]),
.B(S2[3:0]),
.Cin(1'b0),
.Sum(S3[3:0]),
.Cout(c4)
);

adder_4bit a6(
.A(S1[7:4]),
.B(S2[7:4]),
.Cin(c4),
.Sum(S3[7:4]),
.Cout(c5)
);

adder_4bit a7(
.A(ex1),
.B(ex2),
.Cin(c5),
.Sum(S3[11:8]),
.Cout(cout3)
);

assign Sum = $signed(S3[9:0]);

endmodule

///////////////////////////////////////////////////

module adder_16bit(
input [15:0] A,B,
input Cin,
output [15:0] Sum,
output Ovfl
);

wire [15:0] G;
wire [15:0] P;
wire [16:0] C;
wire [15:0] S;

assign G = A & B;
assign P = A ^ B;

assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign C[4] = G[3] | (P[3] & C[3]);
assign C[5] = G[4] | (P[4] & C[3]);
assign C[6] = G[5] | (P[5] & C[3]);
assign C[7] = G[6] | (P[6] & C[3]);
assign C[8] = G[7] | (P[7] & C[3]);
assign C[9] = G[8] | (P[8] & C[3]);
assign C[10] = G[9] | (P[9] & C[9]);
assign C[11] = G[10] | (P[10] & C[10]);
assign C[12] = G[11] | (P[11] & C[11]);
assign C[13] = G[12] | (P[12] & C[12]);
assign C[14] = G[13] | (P[13] & C[13]);
assign C[15] = G[14] | (P[14] & C[14]);
assign Cout = G[15] | (P[15] & C[15]);

assign S = P ^ C;
    
xor(Ovfl,C[15],Cout);

assign Sum = Ovfl?(B[15]?16'b1000000000000000:16'b0111111111111111):S;

endmodule

/////////////////////////////////////////////////////////////

module sub_16bit(
input [15:0] A,B,
input Cin,
output [15:0] Sum,
output Ovfl
);

wire [15:0] G;
wire [15:0] P;
wire [16:0] C;
wire [15:0] S;
wire [15:0] Bbar;
assign Bbar = ~B;
assign G = A & Bbar;
assign P = A ^ Bbar;

assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign C[4] = G[3] | (P[3] & C[3]);
assign C[5] = G[4] | (P[4] & C[3]);
assign C[6] = G[5] | (P[5] & C[3]);
assign C[7] = G[6] | (P[6] & C[3]);
assign C[8] = G[7] | (P[7] & C[3]);
assign C[9] = G[8] | (P[8] & C[3]);
assign C[10] = G[9] | (P[9] & C[9]);
assign C[11] = G[10] | (P[10] & C[10]);
assign C[12] = G[11] | (P[11] & C[11]);
assign C[13] = G[12] | (P[12] & C[12]);
assign C[14] = G[13] | (P[13] & C[13]);
assign C[15] = G[14] | (P[14] & C[14]);
assign Cout = G[15] | (P[15] & C[15]);

assign S = P ^ C;
    
xor(Ovfl,C[15],Cout);

assign Sum = Ovfl?(Bbar[15]?16'b1000000000000000:16'b0111111111111111):S;

endmodule

module mux_8_1(
    input [7:0] in,
    input [2:0] select,
    output out
);

assign out = (~select[2] & ~select[1] & ~select[0] & in[0]) | (~select[2] & ~select[1] & select[0] & in[1]) | (~select[2] & select[1] & ~select[0] & in[2]) | (~select[2] & select[1] & select[0] & in[3]) | (select[2] & ~select[1] & ~select[0] & in[4]) |(select[2] & ~select[1] & select[0] & in[5]) | (select[2] & select[1] & ~select[0] & in[6]) |(select[2] & select[1] & select[0] & in[7]);
endmodule
