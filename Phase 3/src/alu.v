module alu(op1,op2,aluop,Flag,alu_out);
    input [15:0] op1;
    input [15:0] op2;
    input [3:0] aluop;
    output reg [15:0] alu_out;
    output [2:0] Flag;

    wire [15:0] out0; // adder output
    wire [15:0] out1; // xor output
    wire [15:0] out2; // RED output
    wire [15:0] out3; // shifter output
    wire [15:0] out4; // PADDSB output
    wire [15:0] out5; // LLB output
    wire [15:0] out6; // LHB output
    
    wire ovfl;

    // Adder for ADD, SUB, LW, SW
    AddSub_16bit adder(.a(op1), .b(op2), .sub(aluop[0]), .sum(out0), .ovfl(ovfl));

    // Xor for XOR
    assign out1 = op1 ^ op2;

    Red_adder red_add(.A(op1), .B(op2), .Sum(out2));

    // Shifter, for SLL, SRA, ROR
    shifter shifter1(.in(op1), .shift(op2[3:0]), .mode(aluop[1:0]), .out(out3));
    
    paddsb_4bit paddsb0(.A(op1[3:0]), .B(op2[3:0]), .Sum(out4[3:0]));
    paddsb_4bit paddsb1(.A(op1[7:4]), .B(op2[7:4]), .Sum(out4[7:4]));
    paddsb_4bit paddsb2(.A(op1[11:8]), .B(op2[11:8]), .Sum(out4[11:8]));
    paddsb_4bit paddsb3(.A(op1[15:12]), .B(op2[15:12]), .Sum(out4[15:12]));

    // LLB and LHB
    assign out5 = (op1[15:0] & 16'hFF00) | op2[7:0];
    assign out6 = (op1[15:0] & 16'h00FF) | (op2[7:0] << 8);

    // Set flags
    assign Flag[2] = ~(|alu_out);   //Z Flag
    assign Flag[1] = ovfl;	        //V Flag
    assign Flag[0] = alu_out[15];   //N Flag

    //Select which output to use
    always@(*) begin
        casex(aluop)
            4'b0000: alu_out = out0; //ADD, LW, SW
            4'b0001: alu_out = out0; //SUB
            4'b0010: alu_out = out1; //XOR
            4'b0011: alu_out = out2; //RED
            4'b0100: alu_out = out3; //SLL
            4'b0101: alu_out = out3; //SRA
            4'b0110: alu_out = out3; //ROR 
            4'b0111: alu_out = out4; //PADDSb
            4'b1000: alu_out = out5; //LLB
            4'b1001: alu_out = out6; //LHB
            4'b1100: alu_out = out0;
            4'b1101: alu_out = out0;
            4'b1110: alu_out = out0;
            4'b1111: alu_out = out0;
            default: begin $display("Error default case of alu_out mux triggered: %b", aluop); alu_out = out0; end
        endcase
    end
endmodule
