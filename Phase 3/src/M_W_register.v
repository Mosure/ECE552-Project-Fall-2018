module M_W_register(clk, rst, wen, M_regWrite, M_hlt, M_writeSelect, M_Rs, M_Rt, M_Rd, M_ALUOut,
                    M_DMemOut, M_PC, W_regWrite, W_hlt, W_writeSelect, W_Rs, W_Rt, W_Rd, W_ALUOut, W_DMemOut, W_PC);
    input clk, rst, wen;
    input M_regWrite, M_hlt;
    input[1:0] M_writeSelect;
    input[3:0] M_Rs, M_Rt, M_Rd;
    input[15:0] M_ALUOut, M_DMemOut, M_PC;
    output W_regWrite, W_hlt;
    output[1:0] W_writeSelect;
    output[3:0] W_Rs, W_Rt, W_Rd;
    output[15:0] W_ALUOut, W_DMemOut, W_PC;

    // Signals needed at WB stage
    dff hlt(.clk(clk), .rst(rst), .wen(wen), .d(M_hlt), .q(W_hlt));
    dff regWrite(.clk(clk), .rst(rst), .wen(wen), .d(M_regWrite), .q(W_regWrite));
    reg_2bit writeSelect(.clk(clk), .rst(rst), .wen(wen), .d(M_writeSelect), .q(W_writeSelect));
    reg_4bit Rd(.clk(clk), .rst(rst), .wen(wen), .d(M_Rd), .q(W_Rd));
    reg_16bit ALUOut(.clk(clk), .rst(rst), .wen(wen), .d(M_ALUOut), .q(W_ALUOut));
    reg_16bit DMemOut(.clk(clk), .rst(rst), .wen(wen), .d(M_DMemOut), .q(W_DMemOut));
    reg_16bit incPC(.clk(clk), .rst(rst), .wen(wen), .d(M_PC), .q(W_PC));
    
    // Signals used for forwarding checking
    reg_4bit Rs(.clk(clk), .rst(rst), .wen(wen), .d(M_Rs), .q(W_Rs));
    reg_4bit Rt(.clk(clk), .rst(rst), .wen(wen), .d(M_Rt), .q(W_Rt));
    
endmodule

