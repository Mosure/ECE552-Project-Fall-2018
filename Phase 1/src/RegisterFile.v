module RegisterFile(input clk, input rst, input [3:0] SrcReg1, input [3:0] SrcReg2, input [3:0]
DstReg, input WriteReg, input [15:0] DstData, inout [15:0] SrcData1, inout [15:0] SrcData2);

wire [15:0] RWL1, RWL2, WWL; 

ReadDecoder_4_16 RD1(.RegId(SrcReg1), .Wordline(RWL1));
ReadDecoder_4_16 RD2(.RegId(SrcReg2), .Wordline(RWL2));

WriteDecoder_4_16 WD(.RegId(DstReg), .WriteReg(WriteReg), .Wordline(WWL));

Register R0(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[0]),
			.ReadEnable1(RWL1[0]),
			.ReadEnable2(RWL2[0]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));
			
Register R1(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[1]),
			.ReadEnable1(RWL1[1]),
			.ReadEnable2(RWL2[1]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));
			
Register R2(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[2]),
			.ReadEnable1(RWL1[2]),
			.ReadEnable2(RWL2[2]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));
			
Register R3(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[3]),
			.ReadEnable1(RWL1[3]),
			.ReadEnable2(RWL2[3]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R4(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[4]),
			.ReadEnable1(RWL1[4]),
			.ReadEnable2(RWL2[4]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R5(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[5]),
			.ReadEnable1(RWL1[5]),
			.ReadEnable2(RWL2[5]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));			

Register R6(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[6]),
			.ReadEnable1(RWL1[6]),
			.ReadEnable2(RWL2[6]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));
			
Register R7(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[7]),
			.ReadEnable1(RWL1[7]),
			.ReadEnable2(RWL2[7]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R8(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[8]),
			.ReadEnable1(RWL1[8]),
			.ReadEnable2(RWL2[8]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R9(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[9]),
			.ReadEnable1(RWL1[9]),
			.ReadEnable2(RWL2[9]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R10(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[10]),
			.ReadEnable1(RWL1[10]),
			.ReadEnable2(RWL2[10]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R11(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[11]),
			.ReadEnable1(RWL1[11]),
			.ReadEnable2(RWL2[11]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R12(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[12]),
			.ReadEnable1(RWL1[12]),
			.ReadEnable2(RWL2[12]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R13(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[13]),
			.ReadEnable1(RWL1[13]),
			.ReadEnable2(RWL2[13]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R14(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[14]),
			.ReadEnable1(RWL1[14]),
			.ReadEnable2(RWL2[14]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));

Register R15(.clk(clk),
			.rst(rst),
			.D(DstData),
			.WriteReg(WWL[15]),
			.ReadEnable1(RWL1[15]),
			.ReadEnable2(RWL2[15]),
			.Bitline1(SrcData1),
			.Bitline2(SrcData2));
			
endmodule