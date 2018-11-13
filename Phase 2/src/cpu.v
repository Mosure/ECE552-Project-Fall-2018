module cpu (clk, rst_n, hlt, pc);
    input clk, rst_n;
    output hlt;
    output[15:0] pc;

    wire rst;
    
    // IF Phase signals
    wire[15:0] F_instruction;
    wire[15:0] next_pc;
    wire[15:0] F_incPC;
    wire       F_hlt;
    
    // Branch signals
    wire[15:0] branchPC;
    wire exBranch;
    
    // ID Phase signals
    wire RegRead;
    wire[1:0] Branch;
    wire[15:0] D_instruction, D_incPC;
    wire[15:0] D_offset, D_shamt, D_loadByte;
    wire D_regWrite, D_memRead, D_memWrite, D_zEn, D_vEn, D_nEn, D_hlt;
    wire[1:0] D_ALUsrc, D_writeSelect;
    wire[3:0] D_ALUOp, D_Rs, D_Rt, D_Rd;
    wire[15:0] D_regData1, D_regData2;
    wire stall;

    // EX Phase signals
    wire[1:0] forwardA, forwardB;
    wire MMforward;
    wire[2:0] Flag, FlagIn;
    wire[15:0] ALUSrcMuxOut;
    wire[15:0] ALUSrc1, ALUSrc2;
    wire[15:0] X_offset, X_shamt, X_loadByte;
    wire X_regWrite, X_memRead, X_memWrite, X_zEn, X_vEn, X_nEn, X_hlt;
    wire[1:0] X_writeSelect, X_ALUsrc;
    wire[3:0] X_Rs, X_Rt, X_Rd, X_ALUOp;
    wire[15:0] X_regData1, X_regData2, X_incPC, X_ALUOut;
    
    // MEM Phase signals
    wire[15:0] DMEM_In;
    wire M_regWrite, M_memWrite, M_hlt;
    wire[1:0] M_writeSelect;
    wire[3:0] M_Rs, M_Rt, M_Rd;
    wire[15:0] M_regData2, M_ALUOut, M_incPC, M_DMemOut;
    
    // WB Phase signals
    wire[15:0] DstData;
    wire W_regWrite, W_hlt;
    wire[1:0] W_writeSelect;
    wire[3:0] W_Rs, W_Rt, W_Rd;
    wire[15:0] W_DMemOut, W_incPC, W_ALUOut;

    
    // Convert active low reset to active high reset
    assign rst = ~rst_n;

    /****************************
    ** Instruction Fetch Stage **
    ****************************/
    
    // PC Src Mux
    assign next_pc = (exBranch) ? branchPC : F_incPC;
    assign F_hlt = &F_instruction[15:12] & ~exBranch; // Check for HLT, allow PCregister to increment if the branch is taken
    
    // PC register stores the current pc
    // Don't write to PC if hlt in the IF stage
    PCregister PC(.clk(clk), .rst(rst), .wen(~F_hlt & ~stall), .nextPC(next_pc), .PC(pc));
    
    // Instruction Memory
    memory1c IMEM(.clk(clk), .rst(rst), .data_in(16'hzzzz), .addr(pc), .enable(1'b1), .wr(1'b0),  .data_out(F_instruction));
    
    // PC Incrementer
    cla_16bit PCinc(.a(pc), .b(16'h0002), .cin(1'b0), .sum(F_incPC), .cout());
    
    // IF/ID pipeline register : Write enable condition is ~stall. Freeze the contents of the register if stall is asserted
    // Flush the IF register if branch is taken
    F_D_register pipeReg1(.clk(clk), .rst(rst), .wen(~stall), .F_instruction(F_instruction), .F_incPC(F_incPC), .D_instruction(D_instruction), .D_incPC(D_incPC));
    
    /*****************************
    ** Instruction Decode Stage **
    *****************************/
    // Determine the inputs to the register file
    assign D_Rs = (RegRead) ? D_instruction[11:8] : D_instruction[7:4];

    assign D_Rt = (D_memWrite) ? D_instruction[11:8] : D_instruction[3:0];

    assign D_Rd = D_instruction[11:8];

    // 16 register Register File
    RegisterFile registers(.clk(clk), .rst(rst), .SrcReg1(D_Rs), .SrcReg2(D_Rt), .DstReg(W_Rd),
                            .WriteReg(W_regWrite), .DstData(DstData), .SrcData1(D_regData1), .SrcData2(D_regData2));

    // Global Control Logic
    Control GlobalControl(.Op(D_instruction[15:12]), .RegRead(RegRead), .RegWrite(D_regWrite), .MemRead(D_memRead), .MemWrite(D_memWrite), .halt(D_hlt), .ALUSrc(D_ALUsrc),
                            .Branch(Branch), .WriteSelect(D_writeSelect), .ALUOp(D_ALUOp), .zEn(D_zEn), .vEn(D_vEn), .nEn(D_nEn));
                            
    // PC Control Logic
    BranchControl BC(.C(D_instruction[11:9]), .I(D_instruction[8:0]), .F(Flag), .B(Branch), .regPC(D_regData1), .incPC(D_incPC), .branchPC(branchPC), .exBranch(exBranch));

    // Hazard Detection Unit
    Hazard_Detection HDU(.X_memRead(X_memRead), .D_memWrite(D_memWrite), .X_Rt(X_Rt), .D_Rs(D_Rs), .D_Rt(D_Rt), .X_Rd(X_Rd), .M_Rd(M_Rd), .stall(stall), .opcode(D_instruction[15:12]), .CC(D_instruction[11:9]));

    // determine all the possible immediate inputs to ALU
    assign D_offset = {{11{D_instruction[3]}}, D_instruction[3:0], 1'b0};
    assign D_shamt  = {12'h000, D_instruction[3:0]};
    assign D_loadByte = {8'h00, D_instruction};
    
    // ID/EX pipeline register : reset condition is rst|stall. Insert nop if stall is asserted.
    D_X_register pipeReg2(.clk(clk), .rst(rst|stall | exBranch), .wen(1'b1), .D_regWrite(D_regWrite), .D_memRead(D_memRead), .D_memWrite(D_memWrite), .D_writeSelect(D_writeSelect),
                    .D_zEn(D_zEn), .D_vEn(D_vEn), .D_nEn(D_nEn), .D_hlt(D_hlt), .D_ALUsrc(D_ALUsrc), .D_ALUOp(D_ALUOp), .D_Rs(D_Rs), .D_Rt(D_Rt),
                    .D_Rd(D_Rd), .D_offset(D_offset), .D_shamt(D_shamt), .D_loadByte(D_loadByte), .D_regData1(D_regData1), .D_regData2(D_regData2), .D_PC(D_incPC), .X_regWrite(X_regWrite),
                    .X_memRead(X_memRead), .X_memWrite(X_memWrite), .X_writeSelect(X_writeSelect), .X_zEn(X_zEn), .X_vEn(X_vEn), .X_nEn(X_nEn), .X_hlt(X_hlt), .X_ALUsrc(X_ALUsrc),
                    .X_ALUOp(X_ALUOp), .X_Rs(X_Rs), .X_Rt(X_Rt), .X_Rd(X_Rd), .X_offset(X_offset), .X_shamt(X_shamt), .X_loadByte(X_loadByte), .X_regData1(X_regData1), .X_regData2(X_regData2), .X_PC(X_incPC));
                       
    /********************
    ** Execution Stage **
    ********************/
	
    // ALUsrc MUX
    assign ALUSrcMuxOut = (X_ALUsrc == 2'b00) ? X_regData2 :   	 // register Data
                          (X_ALUsrc == 2'b01) ? X_shamt :        // zero extended immediate
                          (X_ALUsrc == 2'b10) ? X_offset :       // offset for LW or SW
                                                X_loadByte;      // 8-bit immediate

    // Forwarding Unit
    Forwarding_Unit FwdUnit(.M_regWrite(M_regWrite), .W_regWrite(W_regWrite), .M_memWrite(M_memWrite), .M_Rd(M_Rd), .W_Rd(W_Rd),
                            .X_Rs(X_Rs), .X_Rt(X_Rt), .M_Rt(M_Rt), .forwardA(forwardA), .forwardB(forwardB), .MMforward(MMforward));

    // Forwarding MUXes
    assign ALUSrc1 = (forwardA == 2'b01) ? M_ALUOut :			 // EX-EX forwarding
                     (forwardA == 2'b10) ? DstData :			 // MEM-EX forwarding
                                           X_regData1;			 // No forwarding

    assign ALUSrc2 = (forwardB == 2'b01) ? M_ALUOut :			 // EX-EX forwarding
                     (forwardB == 2'b10) ? DstData :			 // MEM-EX forwarding
                                           ALUSrcMuxOut;		 // No forwarding										   
    
    // ALU
    alu iALU(.op1(ALUSrc1), .op2(ALUSrc2), .aluop(X_ALUOp), .Flag(FlagIn), .alu_out(X_ALUOut));

    // 3 flip-flops, one for each flag
    // Flag Order is ZVN
    FlagRegisters flags(.clk(clk), .rst(rst), .FlagIn(FlagIn), .zEn(X_zEn), .vEn(X_vEn), .nEn(X_nEn), .FlagOut(Flag));
    
    // EX/MEM pipeline register
    X_M_register pipeReg3(.clk(clk), .rst(rst), .wen(1'b1), .X_regWrite(X_regWrite), .X_memWrite(X_memWrite), .X_hlt(X_hlt), 
                    .X_writeSelect(X_writeSelect), .X_Rs(X_Rs), .X_Rt(X_Rt), .X_Rd(X_Rd), .X_regData2(X_regData2),
                    .X_aluOut(X_ALUOut), .X_PC(X_incPC), .M_regWrite(M_regWrite), .M_memWrite(M_memWrite), .M_hlt(M_hlt),
                    .M_writeSelect(M_writeSelect), .M_Rs(M_Rs), .M_Rt(M_Rt), .M_Rd(M_Rd), .M_regData2(M_regData2),
                    .M_aluOut(M_ALUOut), .M_PC(M_incPC));
                    
    
    /************************
    ** Memory Access Stage **
    ************************/
    
    // MEM_MEM Forwarding MUX
    assign DMEM_In = MMforward ? DstData : M_regData2; 

    // Data Memory
    memory1c DMEM(.clk(clk), .rst(rst), .data_in(DMEM_In), .addr(M_ALUOut), .enable(1'b1), .wr(M_memWrite), .data_out(M_DMemOut));
    
    // MEM/WB pipeline register
    M_W_register pipeReg4(.clk(clk), .rst(rst), .wen(1'b1), .M_regWrite(M_regWrite), .M_hlt(M_hlt), .M_writeSelect(M_writeSelect), .M_Rs(M_Rs),
                    .M_Rt(M_Rt), .M_Rd(M_Rd), .M_ALUOut(M_ALUOut), .M_DMemOut(M_DMemOut), .M_PC(M_incPC), .W_regWrite(W_regWrite), .W_hlt(W_hlt),
                    .W_writeSelect(W_writeSelect), .W_Rs(W_Rs), .W_Rt(W_Rt), .W_Rd(W_Rd), .W_ALUOut(W_ALUOut), .W_DMemOut(W_DMemOut), .W_PC(W_incPC));
                    
                
    /*********************
    ** Write Back Stage **
    *********************/
    // Write Select MUX
    assign DstData = (W_writeSelect == 2'b00) ? W_ALUOut :
                     (W_writeSelect == 2'b01) ? W_DMemOut :
                     (W_writeSelect == 2'b10) ? W_incPC : 
                                              16'h0000;  

    assign hlt = W_hlt;
    
endmodule
