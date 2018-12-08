module BranchControl(C, I, F, B, regPC, incPC, branchPC, exBranch);
    input[2:0] C, F;        // Condition Codes and Flag bits
    input[8:0] I;           // Immediate from Instruction
    input[1:0] B;           // Indicates what kind of instruction to execute
    input[15:0] regPC;      // new PC from register for BR instruction 
    input[15:0] incPC;      // PC of current instruction + 2
    output[15:0] branchPC;  // new PC if branch is taken
    output exBranch;        // 1 if branch should be taken, 0 otherwise
    
    reg takeBranch;         // 1 if Condition Codes are met, 0 otherwise
    wire[15:0] I_shifted;   // SE immediate for PC+offset type branch
    wire[15:0] offsetPC;    // incPC + offset
    
    /* Condition Codes, meaning, 
       and what Flags must be set
    000 not equal 0xx
    001 equal 1xx
    010 greater than 0x0
    011 less than xx0
    100	greater or equal 1xx, 0x0
    101 less or equal xx1, 1xx
    110 overflow x1x
    111 unconditional xxx
    */
    
    /* Meaning of input B
    00 anything
    01 anything
    10 branch to offset
    11 branch to register
    */
    
    // Decode Flags to determine if Branch can be taken.
    always@(*) begin
        casex (C)
            3'b000: takeBranch = ~F[2];                 //Not Equal
            3'b001: takeBranch = F[2];                  //Equal
            3'b010: takeBranch = ~(F[2] | F[0]);        //Greater than
            3'b011: takeBranch = ~F[0];                 //Less than
            3'b100: takeBranch = F[2] | ~(F[2] | F[0]); //Greater than or Equal
            3'b101: takeBranch = F[0] | F[2];           //Less than or Equal
            3'b110: takeBranch = F[1];                  //Overflow
            3'b111: takeBranch = 1'b1;                  //Unconditional
            default: begin takeBranch = 1'b0; $display("Error, PC_control default case was selected, %b", C); end
        endcase
    end
    
    // Branch will be taken if conditions are met and is Branch instruction
    assign exBranch = B[1] & takeBranch;
    
    // Determine PC if offset Branch is performed
    assign I_shifted = {{6{I[8]}}, I, 1'b0};
    cla_16bit PCadder(.a(incPC), .b(I_shifted), .cin(1'b0), .sum(offsetPC), .cout());
    
    // Determine what the branch PC would be
    assign branchPC = B[0] ? regPC : offsetPC;
    
endmodule
    