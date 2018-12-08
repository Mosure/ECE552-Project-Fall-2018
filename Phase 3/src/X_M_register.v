module X_M_register(clk, rst, wen, X_regWrite, X_memRead, X_memWrite, X_hlt, X_writeSelect, X_Rs, X_Rt, X_Rd, X_regData2, 
                    X_aluOut, X_PC, M_regWrite, M_memRead, M_memWrite, M_hlt, M_writeSelect, M_Rs, M_Rt, M_Rd, M_regData2, M_aluOut, M_PC);
    input clk, rst, wen;
    input X_regWrite, X_memRead, X_memWrite, X_hlt;
    input[1:0] X_writeSelect;
    input[3:0] X_Rs, X_Rt, X_Rd;
    input[15:0] X_regData2, X_aluOut, X_PC;
    output M_regWrite, M_memRead, M_memWrite, M_hlt;
    output[1:0] M_writeSelect;
    output[3:0] M_Rs, M_Rt, M_Rd;
    output[15:0] M_regData2, M_aluOut, M_PC;

    // Signals needed at MEM stage
    dff memRead(.clk(clk), .rst(rst), .wen(wen), .d(X_memRead), .q(M_memRead));
    dff memWrite(.clk(clk), .rst(rst), .wen(wen), .d(X_memWrite), .q(M_memWrite));
    reg_16bit regData2(.clk(clk), .rst(rst), .wen(wen), .d(X_regData2), .q(M_regData2));
    
    // Signals needed at WB stage
    dff hlt(.clk(clk), .rst(rst), .wen(wen), .d(X_hlt), .q(M_hlt));
    dff regWrite(.clk(clk), .rst(rst), .wen(wen), .d(X_regWrite), .q(M_regWrite));
    reg_2bit writeSelect(.clk(clk), .rst(rst), .wen(wen), .d(X_writeSelect), .q(M_writeSelect));
    reg_4bit Rd(.clk(clk), .rst(rst), .wen(wen), .d(X_Rd), .q(M_Rd));
    reg_16bit aluOut(.clk(clk), .rst(rst), .wen(wen), .d(X_aluOut), .q(M_aluOut));
    reg_16bit incPC(.clk(clk), .rst(rst), .wen(wen), .d(X_PC), .q(M_PC));
    
    // Signals needed for forwarding checking
    reg_4bit Rs(.clk(clk), .rst(rst), .wen(wen), .d(X_Rs), .q(M_Rs));
    reg_4bit Rt(.clk(clk), .rst(rst), .wen(wen), .d(X_Rt), .q(M_Rt));
    
endmodule
