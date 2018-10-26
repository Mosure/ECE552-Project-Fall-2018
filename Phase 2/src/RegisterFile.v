module RegisterFile(clk, rst, SrcReg1, SrcReg2, DstReg, WriteReg, DstData, SrcData1, SrcData2);
	input clk, rst, WriteReg;
	input [3:0] SrcReg1, SrcReg2, DstReg;
	input [15:0] DstData;
	inout [15:0] SrcData1, SrcData2;

	wire [15:0] ReadEnable1, ReadEnable2, WriteEnable, RegData1, RegData2;

	//Decode the register values
	ReadDecoder_4_16 SrcDecode1(.RegId(SrcReg1), .Wordline(ReadEnable1));
	ReadDecoder_4_16 SrcDecode2(.RegId(SrcReg2), .Wordline(ReadEnable2));
	WriteDecoder_4_16 DstDecode(.RegId(DstReg), .Wordline(WriteEnable), .WriteReg(WriteReg));

	//Storage Space
	Register reg15(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[15]), .ReadEnable1(ReadEnable1[15]), 
					.ReadEnable2(ReadEnable2[15]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg14(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[14]), .ReadEnable1(ReadEnable1[14]), 
					.ReadEnable2(ReadEnable2[14]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg13(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[13]), .ReadEnable1(ReadEnable1[13]), 
					.ReadEnable2(ReadEnable2[13]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg12(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[12]), .ReadEnable1(ReadEnable1[12]), 
					.ReadEnable2(ReadEnable2[12]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg11(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[11]), .ReadEnable1(ReadEnable1[11]), 
					.ReadEnable2(ReadEnable2[11]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg10(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[10]), .ReadEnable1(ReadEnable1[10]), 
					.ReadEnable2(ReadEnable2[10]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg9(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[9]), .ReadEnable1(ReadEnable1[9]), 
					.ReadEnable2(ReadEnable2[9]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg8(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[8]), .ReadEnable1(ReadEnable1[8]), 
					.ReadEnable2(ReadEnable2[8]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg7(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[7]), .ReadEnable1(ReadEnable1[7]), 
					.ReadEnable2(ReadEnable2[7]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg6(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[6]), .ReadEnable1(ReadEnable1[6]), 
					.ReadEnable2(ReadEnable2[6]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg5(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[5]), .ReadEnable1(ReadEnable1[5]), 
					.ReadEnable2(ReadEnable2[5]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg4(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[4]), .ReadEnable1(ReadEnable1[4]), 
					.ReadEnable2(ReadEnable2[4]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg3(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[3]), .ReadEnable1(ReadEnable1[3]), 
					.ReadEnable2(ReadEnable2[3]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg2(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[2]), .ReadEnable1(ReadEnable1[2]), 
					.ReadEnable2(ReadEnable2[2]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg1(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[1]), .ReadEnable1(ReadEnable1[1]), 
					.ReadEnable2(ReadEnable2[1]), .Bitline1(RegData1), .Bitline2(RegData2));
	Register reg0(.clk(clk), .rst(rst), .D(DstData), .WriteReg(WriteEnable[0]), .ReadEnable1(ReadEnable1[0]), 
					.ReadEnable2(ReadEnable2[0]), .Bitline1(RegData1), .Bitline2(RegData2));
	
	//Write-before-Read bypassing
	assign SrcData1 = (DstReg == SrcReg1) ? DstData : RegData1;
	assign SrcData2 = (DstReg == SrcReg2) ? DstData : RegData2;

endmodule
