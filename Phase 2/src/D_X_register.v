module D_X_register(clk, rst, wen, D_regWrite, D_memRead, D_memWrite, D_writeSelect, D_zEn, D_vEn, D_nEn, D_hlt, D_ALUsrc,
                    D_ALUOp, D_Rs, D_Rt, D_Rd, D_offset, D_shamt, D_loadByte, D_regData1, D_regData2, D_PC, X_regWrite, X_memRead, X_memWrite, X_writeSelect,
                    X_zEn, X_vEn, X_nEn, X_hlt, X_ALUsrc, X_ALUOp, X_Rs, X_Rt, X_Rd, X_offset, X_shamt, X_loadByte, X_regData1, X_regData2, X_PC);
    input clk, rst, wen;
    input D_regWrite, D_memRead, D_memWrite, D_hlt; 
    input D_zEn, D_vEn, D_nEn;
    input[1:0] D_ALUsrc, D_writeSelect;
    input[3:0] D_ALUOp, D_Rs, D_Rt, D_Rd;
	input[15:0] D_offset, D_shamt, D_loadByte;
    input[15:0] D_regData1, D_regData2, D_PC;
	
    output X_regWrite, X_memRead, X_memWrite, X_hlt;
    output X_zEn, X_vEn, X_nEn;
    output[1:0] X_ALUsrc, X_writeSelect;
    output[3:0] X_ALUOp, X_Rs, X_Rt, X_Rd;
    output[15:0] X_offset, X_shamt, X_loadByte;
	output[15:0] X_regData1, X_regData2, X_PC;

    
    // Signals needed at EX stage
    dff zEn(.clk(clk), .rst(rst), .wen(wen), .d(D_zEn), .q(X_zEn));
    dff vEn(.clk(clk), .rst(rst), .wen(wen), .d(D_vEn), .q(X_vEn));
    dff nEn(.clk(clk), .rst(rst), .wen(wen), .d(D_nEn), .q(X_nEn));
    reg_2bit ALUSrc(.clk(clk), .rst(rst), .wen(wen), .d(D_ALUsrc), .q(X_ALUsrc));
    reg_4bit ALUOp(.clk(clk), .rst(rst), .wen(wen), .d(D_ALUOp), .q(X_ALUOp));
    reg_16bit offset(.clk(clk), .rst(rst), .wen(wen), .d(D_offset), .q(X_offset));
    reg_16bit shamt(.clk(clk), .rst(rst), .wen(wen), .d(D_shamt), .q(X_shamt));
    reg_16bit loadByte(.clk(clk), .rst(rst), .wen(wen), .d(D_loadByte), .q(X_loadByte));
    reg_16bit regData1(.clk(clk), .rst(rst), .wen(wen), .d(D_regData1), .q(X_regData1));
   
    // Signals needed at MEM stage
    dff memWrite(.clk(clk), .rst(rst), .wen(wen), .d(D_memWrite), .q(X_memWrite));
	dff memRead(.clk(clk), .rst(rst), .wen(wen), .d(D_memRead), .q(X_memRead));
    reg_16bit regData2(.clk(clk), .rst(rst), .wen(wen), .d(D_regData2), .q(X_regData2));
    
    // Signals needed at WB stage
    dff hlt(.clk(clk), .rst(rst), .wen(wen), .d(D_hlt), .q(X_hlt));
    dff regWrite(.clk(clk), .rst(rst), .wen(wen), .d(D_regWrite), .q(X_regWrite));
    reg_2bit writeSelect(.clk(clk), .rst(rst), .wen(wen), .d(D_writeSelect), .q(X_writeSelect));
    reg_4bit Rd(.clk(clk), .rst(rst), .wen(wen), .d(D_Rd), .q(X_Rd));
    reg_16bit incPC(.clk(clk), .rst(rst), .wen(wen), .d(D_PC), .q(X_PC));
    
    // Signals needed for forwarding checks
    reg_4bit Rs(.clk(clk), .rst(rst), .wen(wen), .d(D_Rs), .q(X_Rs));
    reg_4bit Rt(.clk(clk), .rst(rst), .wen(wen), .d(D_Rt), .q(X_Rt));
    
endmodule
