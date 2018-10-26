module cla_4bit(A, B, Cin, sum, Gen, Prop);
    input [3:0] A,B;
    input Cin;
    output [3:0] sum;
    output Gen, Prop;

    wire [3:0] G;
    wire [3:0] P;
    wire [3:0] C;

    assign G = A & B;
    assign P = A ^ B;

    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);

    assign sum = P ^ C;
    
    assign Prop = P[3] & P[2] & P[1] & P[0];
    assign Gen = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule
