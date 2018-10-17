


module alu_testbench;

reg [15:0] op1;
reg [15:0] op2;
reg [3:0] aluop;
wire Z,N,V;
wire [2:0] Flag;
wire [15:0] alu_out;
//wire error;

alu alu1(
.op1(op1),
.op2(op2),
.aluop(aluop),
.Flag(Flag),
.alu_out(alu_out)
);

assign Z = Flag[2];
assign N = Flag[0];
assign V = Flag[1];

initial
begin
op1 = 0;
op2 = 0;
aluop = 0;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0000;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0000;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0001;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0001;

 
# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0010;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0010;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0011;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0011;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0100;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0100;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0101;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0101;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0110;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0110;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0111;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b0111;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b1000;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b1000;
# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b1001;

# 30 
op1 = {$random} % 65536;
op2 = {$random} % 65536;
aluop = 4'b1001;
end

initial
begin
$monitor("time = %2d, A =%4h, B=%4h, Aluop=%4b, Result=%4h, Z=%1b, N=%1b, V=%1b ", $time,op1,op2, aluop,alu_out,Z,N,V);
end
 
endmodule