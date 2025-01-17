module Control(rst,exBranch_d,I_stall_d, Op, RegRead, RegWrite, MemRead, MemWrite, zEn, vEn, nEn, ALUSrc, WriteSelect, Branch, ALUOp);
	
    input rst,exBranch_d,I_stall_d;   
    input[3:0] Op;
    output RegRead, RegWrite, MemRead, MemWrite, zEn, vEn, nEn;
    output[1:0] ALUSrc, WriteSelect, Branch;
    output[3:0] ALUOp;
				
    // RegRead: 1 for LLB and LHB, 0 otherwise                
    assign RegRead = Op[3] & Op[1];

    // RegWrite: 0 for SW, B, BR, HLT, 1 otherwise
    assign RegWrite = ~ I_stall_d & ~exBranch_d & ~rst & ((~Op[3]) | (~Op[2] & ~Op[0]) | (~Op[2] & Op[1]) | (Op[1] & ~Op[0]));

    /* ALUSrc:
        00: regData2                (ADD, SUB, XOR, PADDSB, RED)
        01: zero-extended immediate (SLL, SRA, ROR)
        10: sign-extended immediate (LW, SW)
        11: 8-bit immediate         (LLB, LHB) */
    assign ALUSrc[0] = (Op[2] & ~Op[1]) | (Op[2] & ~Op[0]) | (Op[3] & Op[1]);
    assign ALUSrc[1] = Op[3];


    assign ALUOp[0] = (~Op[3] & Op[0]) | (Op[1] & Op[0]);
    assign ALUOp[1] = ~Op[3] & Op[1];
    assign ALUOp[2] = Op[2];
    assign ALUOp[3] = Op[3] & Op[1];

    // halt: 1 for HLT, 0 otherwise
    //assign halt = &Op;

    /* Branch: 
        0X: Non-Branch instruction
        10: Branch to immediate
        11: Branch to register value */
    assign Branch[0] = Op[3] & Op[2] & ~Op[1] & Op[0];
    assign Branch[1] = Op[3] & Op[2] & ~Op[1];

    /* WriteSelect:
        00: ALUOut
        01: MemOut
        10: next PC */
    assign WriteSelect[0] = Op[3] & ~Op[1] & ~Op[2] & ~Op[0];
    assign WriteSelect[1] = Op[3] & Op[2] & Op[1] & ~Op[0];

    // MemWrite: 1 for SW, 0 otherwise
    assign MemWrite = Op[3] & ~Op[2] & ~Op[1] & Op[0];
    
	// MemRead: 1 for LW, 0 otherwise
	assign MemRead = Op[3] & ~Op[2] & ~Op[1] & ~Op[0];
	
    // zEn: 1 for ADD, SUB, XOR, SLL, SRA, ROR, 0 otherwise
    assign zEn = (~Op[3] & ~Op[1]) | (~Op[3] & ~Op[0]);
    
    // vEn and nEn: 1 for ADD and SUB, 0 otherwise
    assign vEn = ~|Op[3:1];
    assign nEn = ~|Op[3:1];

endmodule