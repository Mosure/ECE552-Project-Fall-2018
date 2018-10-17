module Adder_NoSat(a, b, sum);
	input[15:0] a, b;
	input[15:0] sum;

	wire [3:0] G;
	wire [3:0] P;
	wire [2:0] C;

	cla_adder_4bit a0(
		.A(a[3:0]),
		.B(b[3:0]),
		.Cin(1'b0),
		.Sum(sum[3:0]),
		.Prop(P[0]),
		.Gen(G[0])
	);
	
	assign C[0] = G[0] | (P[0] & 1'b0);

	cla_adder_4bit a1(
		.A(a[7:4]),
		.B(b[7:4]),
		.Cin(C[0]),
		.Sum(sum[7:4]),
		.Prop(P[1]),
		.Gen(G[1])
	);

	assign C[1] = G[1] | (P[1] & C[0]);

	cla_adder_4bit a2(
		.A(a[11:8]),
		.B(b[11:8]),
		.Cin(C[1]),
		.Sum(sum[11:8]),
		.Prop(P[2]),
		.Gen(G[2])
	);

	assign C[2] = G[2] | (P[2] & C[1]);

	cla_adder_4bit a3(
		.A(a[15:12]),
		.B(b[15:12]),
		.Cin(C[2]),
		.Sum(sum[15:12]),
		.Prop(P[3]),
		.Gen(G[3])
	);
	
endmodule
