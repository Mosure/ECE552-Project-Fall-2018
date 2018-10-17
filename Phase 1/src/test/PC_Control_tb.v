module PC_control_tb();
	reg[15:0] PC_in, Breg, exPC_out;
	reg[8:0] immediate;
	reg[2:0] CC, Flags;
	reg[1:0] Branch;

	reg[15:0] PC_branch, PC_inc;
	wire[15:0] PC_out;	
	reg Branch_GO;

	//Instantiate DUT
	PC_control	DUT(.C(CC), .F(Flags), .I(immediate), .B(Branch), .Breg(Breg), .PC_in(PC_in), .PC_out(PC_out));

	initial begin
		repeat(100) begin
			PC_in = $random;
			Breg = $random;
			immediate = $random; 
			CC = $random;
			Flags = $random;
			Branch = $random;
			
			PC_inc = PC_in + 2;
			PC_branch = PC_in + 2 + (immediate << 1);
			if((CC == 3'b000 & Flags[2] == 1'b0) |
			   (CC == 3'b001 & Flags[2] == 1'b1) |
			   (CC == 3'b010 & Flags == 3'b0x0) |
			   (CC == 3'b011 & Flags[0] == 1'b0) |
			   (CC == 3'b100 & (Flags[2] == 1'b1) | (Flags[2] == 1'b0 & Flags[0] == 1'b0)) |
			   (CC == 3'b101 & (Flags[0] == 1'b1 | Flags[2] == 1'b1)) |
			   (CC == 3'b110 & Flags[1] == 1'b1) |
			   (CC == 3'b111) | 1'b0)
				Branch_GO = 1'b1;
			else Branch_GO = 1'b0;

			casex(Branch)
				2'b0?: exPC_out = PC_inc;
				2'b10: exPC_out = Branch_GO ? PC_branch : PC_inc;
				2'b11: exPC_out = Branch_GO ? Breg : PC_inc;
			endcase
			#5;
			if(exPC_out != PC_out) begin
				$display("Error. PC_in = %h, Branch_GO = %h, Breg = %h, Branch = %b, exPC_out = %h, PC_out = %h", PC_in, Branch_GO, Breg, Branch, exPC_out, PC_out);
				#50 $finish;
			end
		end
		$display("Tests passed with no errors");
		#50 $finish;
	end

endmodule
