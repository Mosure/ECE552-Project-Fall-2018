module AddSub_16bit(a, b, sub, sum, ovfl);
    input [15:0] a, b;
    input sub;
    output [15:0] sum;
    output ovfl;

    wire [15:0] comp_b; // b is possibly complemented for subtraction
    wire [15:0] intSum; // result before saturation
    wire cout;

    // b is complemented if subtraction is occuring
    assign comp_b = (sub) ? ~b : b;

    // Perform addition or subtraction depending on sub
    cla_16bit adder(.a(a), .b(comp_b), .cin(sub), .sum(intSum), .cout(cout)); 

    // Check if overflow occured
    assign ovfl = (comp_b[15] ~^ a[15]) & (intSum[15] ^ a[15]);

    // If overflow did occur, saturate the result
    assign sum = ovfl ? (cout ? 16'h8000 : 16'h7FFF) : intSum;

endmodule
