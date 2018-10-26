module cla_16bit_tb();
	reg [15:0] a, b, exSum;
	reg cin, exCout;
	
	wire [15:0] sum;
	wire cout;

	//Instantiate DUT
	cla_16bit iDUT(.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

	initial begin
		repeat(100) begin	
			a = $random;
			b = $random;
			cin = $random;
			{exCout, exSum} = a + b + cin;
			#5;
			if((exCout != cout) || (exSum != sum)) begin
				$display("Error. a = %d, b = %d, cin = %d, exSum = %d, sum = %d, exCout = %d, cout = %d", a, b, cin, exSum, sum, exCout, cout);
				$stop;
			end
		end
		$display("Tests passed without errors");
		$stop;
	end
endmodule
