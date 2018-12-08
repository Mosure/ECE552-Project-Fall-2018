module paddsb_4bit(A, B, Sum);
    input[3:0] A, B;
    output[3:0] Sum;

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
