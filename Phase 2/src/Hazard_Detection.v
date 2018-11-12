module Hazard_Detection(X_memRead, D_memWrite, X_Rt, D_Rs, D_Rt, stall, Opcode, CC);

input X_memRead, D_memWrite;
input[3:0] X_Rt, D_Rs, D_Rt;
input[3:0] opcode;
input[2:0] CC;

output stall;

wire Op1_dep, Op2_dep Flag_dep;

//// Op1_dep: Load to use dependency on 1st operand i.e. X_Rt = D_Rs ////
assign Op1_dep = (X_memRead) && (X_Rt != 4'h0) && (X_Rt == D_Rs);

//// Op2_dep: Load to use dependency on 2nd operand i.e. X_Rt = D_Rt except ////
//// the case of LW followed by SW which is solved by MEM-MEM forwarding. /////

assign Op2_dep = (X_memRead) && (X_Rt != 4'h0) && (X_Rt == D_Rs) && (~D_memWrite);


//// Flag_dep: Stall is needed when conditional branch exists,
//// As flags need to be updated. No stall for conditional brances
assign Flag_dep = (opcode[3] & opcode[2] & ~opcode[1] & ~(&CC));

//// Enable stall in either of the two cases ////
assign stall = Op1_dep | Op2_dep | Flag_dep;

endmodule