module alu_tb ();
    reg signed  [15:0]  op1, op2;
    reg         [3:0]   alu_op;

    wire        [2:0]   flag;
    wire signed [15:0]  out;
    
    integer i;
    integer failed;

    initial 
    begin
        failed = 0;

        for (i = 0; i < 500; i++)
            begin
                {op1, op2} = $random;
                {alu_op} = $random;

                #1;

                // This needs saturation added to all alu_op's that have saturation outputs
                // Needs ROR correctness condition

                if (alu_op == 4'b0000) // Add
                    begin
                        if (op1 + op2 !== out)
                            begin
                                $display("[FAIL %b] %d + %d != %d", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0001) // Sub
                    begin
                        if (op1 - op2 !== out)
                            begin
                                $display("[FAIL %b] %d - %d != %d", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0010) // Xor
                    begin
                        if (op1 ^ op2 !== out)
                            begin
                                $display("[FAIL %b] %b ^ %b != %b", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0011) // Red
                    begin
                        if (op1[15:8] + op2[15:8] + op1[7:0] + op2[7:0] != out)
                            begin
                                $display("[FAIL %b] %d + %d + %d + %d != %d", alu_op, op1[15:8], op2[15:8], op1[7:0], op2[7:0], out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0100) // Sll
                    begin
                        if (op1 << op2 != out)
                            begin
                                $display("[FAIL %b] %b << %d != %b", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0101) // Sra
                    begin
                        if (op1 >> op2 != out)
                            begin
                                $display("[FAIL %b] %b >> %d != %b", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0110) // Ror
                    begin
                        
                    end
                else if (alu_op == 4'b0111) // Paddsb
                    begin
                        if (op1[15:12] + op2[15:12] != out[15:12] || op1[11:8] + op2[11:8] != out[11:8] || op1[7:4] + op2[7:4] != out[7:4] || op1[3:0] + op2[3:0] != out[3:0])
                            begin
                                $display("[FAIL %b]", alu_op);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b1000) // Llb
                    begin
                        if ({op1[15:8], op2[7:0]} != out)
                            begin
                                $display("[FAIL %b]", alu_op);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b1001) // Lhb
                    begin
                        if ({op2[15:8], op1[7:0]} != out)
                            begin
                                $display("[FAIL %b]", alu_op);
                                failed++;
                            end
                    end
            end
        
        $display("[TEST] Completed with %d failures", failed);
        #50 $finish;
    end
    
    alu DUT (.op1(op1), .op2(op2), .aluop(alu_op), .Flag(flag), .alu_out(out));
endmodule
