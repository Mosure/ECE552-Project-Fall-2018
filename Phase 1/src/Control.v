module Control(input[3:0] Op,
		output RegRead, RegWrite, MemWrite, halt,
		output[1:0] ALUSrc, WriteSelect, Branch,
		output[3:0] ALUOp);
				
assign RegRead = Op[3] & Op[1];
assign RegWrite = (~Op[3])|(~Op[2] & ~Op[0])|(~Op[2] & Op[1])|(Op[1] & ~Op[0]);
assign ALUSrc[0] = (Op[2] & ~Op[1])|(Op[2] & ~Op[0])|(Op[3] & Op[1]);
assign ALUSrc[1] = Op[3];
assign ALUOp[0] = (~Op[3] & Op[0])|(Op[1] & Op[0]);
assign ALUOp[1] = ~Op[3] & Op[1];
assign ALUOp[2] = Op[2];
assign ALUOp[3] = Op[3] & Op[1];
assign halt = Op[3] & Op[2] & Op[1] & Op[0];
assign Branch[0] = Op[3] & Op[2] & ~Op[1] & Op[0];
assign Branch[1] = Op[3] & Op[2] & ~Op[1];
assign WriteSelect[0] = Op[3] & ~Op[1];
assign WriteSelect[1] = Op[3] & Op[2];
assign MemWrite = Op[3] & ~Op[2] & ~Op[1] & Op[0];

endmodule
