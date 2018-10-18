module BitCell_tb();
	reg clk, rst, D, wen, ren1, ren2;
	reg exline1, exline2;
	wire bline1, bline2;

	//Instantiate DUT
	BitCell iDUT(.clk(clk), .rst(rst), .D(D), .WriteEnable(wen), .ReadEnable1(ren1), .ReadEnable2(ren2), .Bitline1(bline1), .Bitline2(bline2)); 

	initial begin
		clk = 0;
	 	rst = 1;
		ren1 = 0;
		ren2 = 0;
		wen = 0;
		@(posedge clk)
		rst = 0;
		wen = 1;
		D = 1;
		ren2 = 1;
		repeat(1) @ (posedge clk);
		ren2 = 0;
		ren1 = 1;
		wen = 0;
		@ (posedge clk);
		D = 0;
		@ (posedge clk);
		$stop;
		
	end

	always #5 clk <= ~clk;
endmodule