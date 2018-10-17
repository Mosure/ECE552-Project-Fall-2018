module PC_control(C, I, F, B, Breg, PC_in, PC_out);
	input[2:0] C, F;	//branch conditions and flags
	input[8:0] I;		//immediate
	input[15:0] PC_in;	//Current PC
	input[15:0] Breg;	//Branch register
	input[1:0] B; 		//Branch, indicates what the instruction is
	output[15:0] PC_out;

	wire[15:0] PC_inc, PC_branch;
	wire takeBranch;
	wire[9:0] I_shifted;

	/*ccc
	000 not equal 0xx
	001 equal 1xx
	010 greater than 0x0
	011 less than xx0
	100	greater or equal 1xx, 0x0
	101 less or equal xx1, 1xx
	110 overflow x1x
	111 unconditional xxx
	*/

	/*B
	00 anything
	01 anything
	10 branch to offset
	11 branch to register
	*/

	//always@(C,F) begin
	//	case (C)
	//		3'b000: takeBranch = ~F[2]; 				//Not Equal
	//		3'b001: takeBranch = F[2];					//Equal
	//		3'b010: takeBranch = ~(F[2] | F[0]);		//Greater than
	//		3'b011: takeBranch = ~F[0];					//Less than
	//		3'b100: takeBranch = F[2] | ~(F[2] | F[0]);	//Greater than or Equal
	//		3'b101: takeBranch = F[0] | F[2]; 			//Less than or Equal
	//		3'b110: takeBranch = F[1];					//Overflow
	//		3'b111: takeBranch = 1'b1;					//Unconditional
	//		default: begin takeBranch = 1'b0; $display("Error, PC_control default case was selected, %b", C); end
	//	endcase
	//end

	assign takeBranch = (~C[2]&~C[1]&~C[0] ? ~F[2] : 1'bz) |
						(~C[2]&~C[1]& C[0] ?  F[2] : 1'bz) |
						(~C[2]& C[1]&~C[0] ?~(F[2] | F[0]) : 1'bz) |
						(~C[2]& C[1]& C[0] ? ~F[0] : 1'bz) |
						( C[2]&~C[1]&~C[0] ?  F[2] | ~(F[2] | F[0]) : 1'bz) |
						( C[2]&~C[1]& C[0] ?  F[0] | F[2] : 1'bz) |
						( C[2]& C[1]&~C[0] ?  F[1] : 1'bz) |
						( C[2]& C[1]& C[0] ?  1'b1 : 1'bz) | 1'b0;

	//Increment the PC
	adder_16bit	incPC(.A(PC_in), .B(16'h0002), .Sum(PC_inc), .Ovfl());
	
	//Shift the immediate
	assign I_shifted = I << 1;

	//Add the immediate
	adder_16bit	branchPC(.A(PC_inc), .B({6'h00, I_shifted}), .Sum(PC_branch), .Ovfl());

	//Select which new PC option to use
	assign PC_out = (B[1] & takeBranch) ? ((B[0]) ? Breg : PC_branch) : PC_inc;
						   
endmodule
