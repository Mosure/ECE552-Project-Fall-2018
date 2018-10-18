module Control_tb();

reg[4:0] Opcode;
wire RegRead, RegWrite, MemWrite, halt, zEn, vEn, nEn;
wire[1:0] ALUSrc, WriteSelect, Branch;
wire[3:0] ALUOp;

Control iDUT(.Op(Opcode[3:0]), .RegRead(RegRead), .RegWrite(RegWrite), .MemWrite(MemWrite), .halt(halt), .zEn(zEn), .vEn(vEn), .nEn(nEn), .ALUSrc(ALUSrc), .ALUOp(ALUOp), 
			 .WriteSelect(WriteSelect), .Branch(Branch));

initial
	$monitor("Opcode = %b --> RegRead = %b, RegWrite = %b, ALUSrc = %b, ALUOp = %b, MemWrite = %b, WriteSelect = %b, Branch = %b, Halt = %b, zEn = %b, vEn = %b, nEn = %b",
			  Opcode, RegRead, RegWrite, ALUSrc, ALUOp, MemWrite, WriteSelect, Branch, halt, zEn, vEn, nEn);
			  
always begin
	for(Opcode = 5'h00; Opcode < 4'hF; Opcode = Opcode + 1'b1) begin
		#10;
	end
	
	#10;
	$stop();
end
	
endmodule