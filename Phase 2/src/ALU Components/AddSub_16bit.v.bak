module AddSub_16bit(a, b, sub, sum, ovfl);
    input [15:0] a, b;
    input sub;
    output [15:0] sum;
    output ovfl;

    wire [15:0] comp_b; // b is possibly complemented for subtraction
    wire [15:0] intSum; // result before saturation

    // b is complemented if subtraction is occuring
    assign comp_b = (sub) ? ~b : b;

    // Perform addition or subtraction depending on sub
    cla_16bit adder(.a(a), .b(comp_b), .cin(sub), .sum(intSum), .cout()); 

    // Check if overflow occured
    assign ovfl = (sub) ? ((a[15] ^ b[15]) & ~(b[15] ^ intSum[15]) ? 1'b1 : 1'b0) 
                        : (~(a[15] ^ b[15]) & (b[15] ^ intSum[15]) ? 1'b1 : 1'b0);

    // If overflow did occur, saturate the result
    assign sum = ovfl ? (intSum[15] ? 16'h7FFF : 16'h8000) : intSum;

endmodule
