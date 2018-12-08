module Hazard_Detection(X_memRead, D_memWrite, X_Rt, D_Rs, D_Rt, X_Rd, M_Rd, B_stall, L_stall, opcode, CC,X_zEn,X_vEn,X_nEn);

input X_memRead, D_memWrite,X_zEn,X_vEn,X_nEn;
input[3:0] X_Rt, D_Rs, D_Rt, X_Rd, M_Rd;
input[3:0] opcode;
input[2:0] CC;
output B_stall, L_stall;

wire Op1_dep, Op2_dep, Flag_dep, BReg_dep;

//// Op1_dep: Load to use dependency on 1st operand i.e. X_Rt = D_Rs ////
assign Op1_dep = (X_memRead) && (X_Rt != 4'h0) && (X_Rt == D_Rs);

//// Op2_dep: Load to use dependency on 2nd operand i.e. X_Rt = D_Rt except ////
//// the case of LW followed by SW which is solved by MEM-MEM forwarding. /////
assign Op2_dep = (X_memRead) && (X_Rt != 4'h0) && (X_Rt == D_Rs) && (~D_memWrite);

//// Flag_dep: Stall is needed when conditional branch exists,
//// and flags need to be updated. No stall for unconditional brances
assign Flag_dep = (opcode[3] & opcode[2] & ~opcode[1] & ~(&CC) & (X_zEn | X_vEn | X_nEn));

//// Enable stall when Branch Control needs updated Branch Register ////
assign BReg_dep = (opcode[3] & opcode[2] & ~opcode[1] & opcode[0] & (D_Rs == X_Rd || D_Rs == M_Rd));

//// Enable stall in any of these cases ////
assign L_stall = Op1_dep | Op2_dep;
assign B_stall = Flag_dep | BReg_dep;

endmodule