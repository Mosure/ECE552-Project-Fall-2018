module F_D_register(clk, rst, wen, F_instruction, F_incPC,F_hlt, D_instruction, D_incPC,D_hlt);
    input[15:0] F_instruction, F_incPC;
    input clk, rst, wen;
    output[15:0] D_instruction, D_incPC;
    input F_hlt;
    output D_hlt;

    reg_16bit instruction(.clk(clk), .rst(rst), .wen(wen), .d(F_instruction), .q(D_instruction));
    reg_16bit incPC(.clk(clk), .rst(rst), .wen(wen), .d(F_incPC), .q(D_incPC));
    dff hlt(.clk(clk), .rst(rst), .wen(wen), .d(F_hlt), .q(D_hlt));
endmodule
