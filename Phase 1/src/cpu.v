module cpu (clk, rst_n, hlt, pc);
    input           clk;
    input           rst_n;

    output          hlt;
    output  [15:0]  pc;
	
	wire[15:0] next_pc, Instruction;
	wire RegRead, RegWrite, MemWrite, zEn, vEn, nEn;
	wire[1:0] ALUSrc, Branch, WriteSelect;
	wire[3:0] ALUOp;
	wire[3:0] RegReadMuxOut;
	wire[15:0] Rs, Rt;
	wire[15:0] WriteSelectMuxOut, ALUSrcMuxOut;
	wire[15:0] imm_sgnext_shft1;
	wire[2:0] Flag, FlagIn;
	wire[15:0] ALUOut, DMemOut;
	
	PCregister PC(.clk(clk), .rst(~rst_n), .wen(~hlt), .nextPC(next_pc), .PC(pc));											// Halt Mux

	memory1c IMEM(.data_in(16'hzzzz),								 					// Instruction Memory
					.data_out(Instruction), 
					.addr(pc), 
					.enable(1'b1), 
					.wr(1'b0), 
					.clk(clk), 
					.rst(~rst_n));
	
	assign RegReadMuxOut = (RegRead) ? Instruction[11:8] : Instruction[7:4];
	
	RegisterFile registers(.clk(clk),													// Registers 
							.rst(~rst_n), 
							.SrcReg1(RegReadMuxOut), 
							.SrcReg2(Instruction[3:0]), 
							.DstReg(Instruction[11:8]),
							.WriteReg(RegWrite),
							.DstData(WriteSelectMuxOut),
							.SrcData1(Rs),
							.SrcData2(Rt));
	
	///// Assign imm_sgnext_shft1 here, using sign extender and shifter
	assign imm_sgnext_shft1 = {{12{Instruction[3]}}, Instruction[3:0]}; //sign-extended offset for LW and SW
	
	assign ALUSrcMuxOut = (ALUSrc == 2'b00) ? Rt :										// ALUSrc MUX
						  (ALUSrc == 2'b01) ? Instruction[3:0] :
						  (ALUSrc == 2'b10) ? imm_sgnext_shft1 : Instruction[7:0];
						  
	alu iALU(.op1(Rs),																	// ALU
			 .op2(ALUSrcMuxOut),
			 .aluop(ALUOp),
			 .Flag(FlagIn),
			 .alu_out(ALUOut));
	
	FlagRegisters flags(.clk(clk), .rst(~rst_n), .FlagIn(FlagIn), .zEn(zEn), .vEn(vEn), .nEn(nEn), .FlagOut(Flag));
	
	memory1c DMEM(.data_in(Rt),								 							// Data Memory
					.data_out(DMemOut), 
					.addr(ALUOut), 
		     			.enable(1'b1), 													// Check the working of enable and wr inputs!
					.wr(MemWrite), 														// 11 --> Write
					.clk(clk), 															// 10 --> Read
					.rst(~rst_n));

	PC_control PCC(.C(Instruction[11:9]),												// PC Control Logic
				   .I(Instruction[8:0]),
				   .F(Flag),
				   .B(Branch),
				   .Breg(Rs),
				   .PC_in(pc),
		       		   .PC_out(next_pc));
	
	assign WriteSelectMuxOut = (WriteSelect == 2'b00) ? ALUOut :						// Write Select MUX 
							   (WriteSelect == 2'b01) ? DMemOut :
							   (WriteSelect == 2'b10) ? next_pc : 16'h0000;  
	
	Control GlobalControl(.Op(Instruction[15:12]),										// Global Control Logic
						  .RegRead(RegRead),
						  .RegWrite(RegWrite),
						  .MemWrite(MemWrite),
						  .halt(hlt),
						  .ALUSrc(ALUSrc),
						  .Branch(Branch),
						  .WriteSelect(WriteSelect),
						  .ALUOp(ALUOp),
						  .zEn(zEn),
						  .vEn(vEn),
						  .nEn(nEn));
	
endmodule
