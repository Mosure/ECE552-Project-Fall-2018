module cpu (clk, rst_n, hlt, pc);
    input clk, rst_n;
    output hlt;
    output[15:0] pc;

    wire[15:0] next_pc, Instruction;
    wire RegRead, RegWrite, MemWrite, zEn, vEn, nEn;
    wire[1:0] ALUSrc, Branch, WriteSelect;
    wire[3:0] ALUOp;
    wire[3:0] srcReg1, srcReg2;
    wire[15:0] regData1, regData2;
    wire[15:0] DstData, ALUSrc2;
    wire[15:0] offset, shamt, loadByte;
    wire[2:0] Flag, FlagIn;
    wire[15:0] ALUOut, DMemOut;
    wire rst;
    
    //Convert active low reset to active high reset
    assign rst = ~rst_n;

    /****************************
    ** Instruction Fetch Stage **
    ****************************/
    //PC register stores the current pc
    PCregister PC(.clk(clk), .rst(rst), .wen(~hlt), .nextPC(next_pc), .PC(pc));
    
    //Instruction Memory
    memory1c IMEM(.clk(clk), .rst(rst), .data_in(16'hzzzz), .addr(pc), .enable(1'b1), .wr(1'b0),  .data_out(Instruction));

    
    /*****************************
    ** Instruction Decode Stage **
    *****************************/
    //Determine the inputs to the register file
    assign srcReg1 = (RegRead) ? Instruction[11:8] : Instruction[7:4];

    assign srcReg2 = (MemWrite) ? Instruction[11:8] : Instruction[3:0];

    //16 register Register File
    RegisterFile registers(.clk(clk), .rst(rst), .SrcReg1(srcReg1), .SrcReg2(srcReg2), .DstReg(Instruction[11:8]),
                            .WriteReg(RegWrite), .DstData(DstData), .SrcData1(regData1), .SrcData2(regData2));
	
    //Global Control Logic
    Control GlobalControl(.Op(Instruction[15:12]), .RegRead(RegRead), .RegWrite(RegWrite), .MemWrite(MemWrite), .halt(hlt), .ALUSrc(ALUSrc),
                            .Branch(Branch), .WriteSelect(WriteSelect), .ALUOp(ALUOp), .zEn(zEn), .vEn(vEn), .nEn(nEn));
                            
    // PC Control Logic
    PC_control PCC(.C(Instruction[11:9]), .I(Instruction[8:0]), .F(Flag), .B(Branch), .Breg(regData1), .PC_in(pc), .PC_out(next_pc));
	   
    /********************
    ** Execution Stage **
    ********************/
    // odetermine all the possible immediate inputs to ALU
    assign offset = {{11{Instruction[3]}}, Instruction[3:0], 1'b0};
    assign shamt  = {12'h000, Instruction[3:0]};
    assign loadByte = {8'h00, Instruction[7:0]};
	
    //ALUsrc MUX
    assign ALUSrc2 = (ALUSrc == 2'b00) ? regData2 : // register Data
                     (ALUSrc == 2'b01) ? shamt :    // zero extended immediate
                     (ALUSrc == 2'b10) ? offset :   // offset for LW or SW
                                         loadByte;  // 8-bit immediate

    //ALU
    alu iALU(.op1(regData1), .op2(ALUSrc2), .aluop(ALUOp), .Flag(FlagIn), .alu_out(ALUOut));
	
    //3 flip-flops, one for each flag
    //Flag Order is ZVN
    FlagRegisters flags(.clk(clk), .rst(rst), .FlagIn(FlagIn), .zEn(zEn), .vEn(vEn), .nEn(nEn), .FlagOut(Flag));
	
    
    /************************
    ** Memory Access Stage **
    ************************/
    //Data Memory
    memory1c DMEM(.clk(clk), .rst(rst), .data_in(regData2), .addr(ALUOut), .enable(1'b1), .wr(MemWrite), .data_out(DMemOut));

    
    /*********************
    ** Write Back Stage **
    *********************/
    //Write Select MUX
    assign DstData = (WriteSelect == 2'b00) ? ALUOut :
                     (WriteSelect == 2'b01) ? DMemOut :
                     (WriteSelect == 2'b10) ? next_pc : 
                                              16'h0000;  

    
endmodule
