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

                if (alu_op == 4'b0000)
                    begin
                        if (op1 + op2 !== out)
                            begin
                                $display("[FAIL %b] %d + %d != %d", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0001)
                    begin
                        if (op1 - op2 !== out)
                            begin
                                $display("[FAIL %b] %d - %d != %d", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0010)
                    begin
                        if (op1 ^ op2 !== out)
                            begin
                                $display("[FAIL %b] %b ^ %b != %b", alu_op, op1, op2, out);
                                failed++;
                            end
                    end
                else if (alu_op == 4'b0011)
                    begin
                        if ()
                    end
            end
        
        $display("[TEST] Completed with %d failures", failed);
        #50 $finish;
    end
    
    alu DUT (.op1(op1), .op2(op2), .aluop(alu_op), .Flag(flag), .alu_out(out));
endmodule
