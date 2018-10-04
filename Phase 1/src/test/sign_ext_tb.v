module sign_ext_tb ();
    reg  [15:0]  in;
    reg  [3:0]   extension_bits;

    wire [15:0]  out;

    integer failed;
    
    initial 
    begin
        failed = 0;

        in = { 8'b00000000, 8'b10100110 };
        extension_bits = 4'b1000;
        #1;
        if (out != 16'b1111111110100110)
            begin
                $display("[FAIL] sign_ext(10100110) != %b", out);
                failed++;
            end
        
        in = { 8'b00000000, 8'b01100110 };
        extension_bits = 4'b1000;
        #1;
        if (out != 16'b0000000001100110)
            begin
                $display("[FAIL] sign_ext(01100110) != %b", out);
                failed++;
            end

        in = { 7'b0010100, 9'b011001010 };
        extension_bits = 4'b0111;
        #1;
        if (out != 16'b0000000011001010)
            begin
                $display("[FAIL] sign_ext(011001010) != %b", out);
                failed++;
            end

        in = { 7'b0010100, 9'b101001010 };
        extension_bits = 4'b0111;
        #1;
        if (out != 16'b1111111101001010)
            begin
                $display("[FAIL] sign_ext(101001010) != %b", out);
                failed++;
            end
        
        in = { 12'b000000000000, 4'b1010 };
        extension_bits = 4'b1100;
        #1;
        if (out != 16'b1111111111111010)
            begin
                $display("[FAIL] sign_ext(1010) != %b", out);
                failed++;
            end

        in = { 12'b000000000000, 4'b0110 };
        extension_bits = 4'b110;
        #1;
        if (out != 16'b0000000000000110)
            begin
                $display("[FAIL] sign_ext(0110) != %b", out);
                failed++;
            end

        $display("[TEST] Completed with %d failures", failed);
        #50 $finish;
    end
    
    sign_ext DUT (.in(in), .out(out), .extension_bits(extension_bits));
endmodule
