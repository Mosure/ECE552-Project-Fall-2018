module cla_16bit(a, b, cin, sum, cout);
    input[15:0] a, b;
    input cin;
    output [15:0] sum;
    output cout;

    //Carries, generates, and propagates
    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    assign C[0] = cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign cout = G[3] | (P[3] & C[3]);

    cla_4bit a0(.A(a[3:0]), .B(b[3:0]), .Cin(C[0]), .sum(sum[3:0]), .Prop(P[0]), .Gen(G[0]));
    cla_4bit a1(.A(a[7:4]), .B(b[7:4]), .Cin(C[1]), .sum(sum[7:4]), .Prop(P[1]), .Gen(G[1]));
    cla_4bit a2(.A(a[11:8]), .B(b[11:8]), .Cin(C[2]), .sum(sum[11:8]), .Prop(P[2]), .Gen(G[2]));
    cla_4bit a3(.A(a[15:12]), .B(b[15:12]), .Cin(C[3]), .sum(sum[15:12]), .Prop(P[3]), .Gen(G[3]));

endmodule
