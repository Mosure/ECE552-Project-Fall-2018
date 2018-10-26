module Red_adder(A, B, Sum);
    input [15:0] A, B;
    output [15:0] Sum;

    wire [7:0] S1,S2;
    wire [11:0] S3;
    wire [11:0] ex1,ex2;
    wire [1:0] P1,G1,C1;
    wire [1:0] P2,G2,C2;
    wire [2:0] P3,G3,C3;

    // Add the Lower 8 bits 
    cla_adder_4bit a1(.A(A[3:0]), .B(B[3:0]), .Cin(1'b0), .Sum(S1[3:0]), .Prop(P1[0]), .Gen(G1[0]));
    cla_adder_4bit a2(.A(A[7:4]), .B(B[7:4]), .Cin(C1[0]), .Sum(S1[7:4]), .Prop(P1[1]), .Gen(G1[1]));

    assign C1[1] = G1[1] | (P1[1] & C1[0]);
    assign C1[0] = G1[0] | (P1[0] & 1'b0);

    // Add the Upper 8 bits
    cla_adder_4bit a3(.A(A[11:8]), .B(B[11:8]), .Cin(1'b0), .Sum(S2[3:0]), .Prop(P2[0]), .Gen(G2[0]));
    cla_adder_4bit a4(.A(A[15:12]), .B(B[15:12]), .Cin(C2[0]), .Sum(S2[7:4]), .Prop(P2[1]), .Gen(G2[1]) );

    assign C2[0] = G2[0] | (P2[0] & 1'b0);
    assign C2[1] = G2[1] | (P2[1] & C2[0]);

    // Extend the intermdiate results;
    assign ex1 = {3'b000, C1[1], S1};
    assign ex2 = {3'b000, C2[1], S2};

    // Add the two sums together
    cla_adder_4bit a5(.A(ex1[3:0]), .B(ex2[3:0]), .Cin(1'b0), .Sum(S3[3:0]), .Prop(P3[0]), .Gen(G3[0]));
    cla_adder_4bit a6(.A(ex1[7:4]), .B(ex2[7:4]), .Cin(C3[0]), .Sum(S3[7:4]), .Prop(P3[1]), .Gen(G3[1]));
    cla_adder_4bit a7(.A(ex1[11:8]), .B(ex2[11:8]), .Cin(C3[1]), .Sum(S3[11:8]), .Prop(P3[2]), .Gen(G3[2]));
    
    assign C3[0] = G3[0] | (P3[0] & 1'b0);
    assign C3[1] = G3[1] | (P3[1] & C3[0]);
    assign C3[2] = G3[2] | (P3[2] & C3[1]);

    // Get the final answer 
    assign Sum = {{4{C3[2]}},S3};


endmodule
