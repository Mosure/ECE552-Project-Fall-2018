module Forwarding_Unit(M_regWrite, W_regWrite, M_memWrite, M_Rd, W_Rd, X_Rs, X_Rt, M_Rt, forwardA, forwardB, MMforward);

/////// Inputs to determine EX-EX Forwarding ////////
input M_regWrite;
input[3:0] M_Rd;
input[3:0] X_Rs, X_Rt;						// Also used for MEM-EX forwarding				

/////// Inputs to determine MEM-EX Forwarding ///////
input W_regWrite;
input[3:0] W_Rd;							// Also used for MEM-MEM forwarding

/////// Inputs to determine MEM-MEM Forwarding //////
input M_memWrite;
input[3:0] M_Rt;

////////////////// Outputs //////////////////////
/////// forward = 00 --> No forwarding //////////
/////// forward = 01 --> EX-EX forwarding ///////
/////// forward = 10 --> MEM-EX forwarding //////
/////// forwardA is for ALUSrc1 /////////////////
/////// forwardB is for ALUSrc2 /////////////////
/////// MMforward is for MEM-MEM forwarding /////
/////////////////////////////////////////////////
output[1:0] forwardA, forwardB;
output MMforward;

wire exA, exB, memA, memB;

assign exA = (M_regWrite) && (M_Rd != 4'h0) && (M_Rd == X_Rs);
assign exB = (M_regWrite) && (M_Rd != 4'h0) && (M_Rd == X_Rt);

assign memA = (W_regWrite) && (W_Rd != 4'h0) && (W_Rd == X_Rs);
assign memB = (W_regWrite) && (W_Rd != 4'h0) && (W_Rd == X_Rt);

assign forwardA = exA ? 2'b01 :											// Preference to EX-EX forwarding
				  memA ? 2'b10 : 2'b00;
				  
assign forwardB = exB ? 2'b01 :
				  memB ? 2'b10 : 2'b00;

assign MMforward = (M_memWrite) && (W_regWrite) && (W_Rd != 4'h0) && (W_Rd == M_Rt);	// MEM-MEM forwarding
				  
endmodule