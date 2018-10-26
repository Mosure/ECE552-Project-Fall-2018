module AddSub_16bit_tb();
    reg[15:0] a, b, exSum;
    reg sub, exOvfl;
    
    wire[15:0] sum;
    wire ovfl;
    
    //Instantiate DUT
    AddSub_16bit DUT(.a(a), .b(b), .sub(sub), .sum(sum), .ovfl(ovfl));
    
    initial begin
        repeat(100) begin
            a = $random;
            b = $random;
            sub = $random;
            exOvfl = 1'b0;
            exSum = sub ? a-b : a+b;
            if(sub) begin
                if(a[15] & ~b[15] & ~exSum[15]) begin
                    exSum = 16'h8000;
                    exOvfl = 1'b1;
                end
                else if(~a[15] & b[15] & exSum[15]) begin
                    exSum = 16'h7FFF;
                    exOvfl = 1'b1;
                end
            end
            else begin
                if(a[15] & b[15] & ~exSum[15]) begin
                    exSum = 16'h8000;
                    exOvfl = 1'b1;
                end
                else if(~a[15] & ~b[15] & exSum[15]) begin
                    exSum = 16'h7FFF;
                    exOvfl = 1'b1;
                end
            end
            #5;
            if((exSum != sum) | (exOvfl != ovfl)) begin
                    $display("Error. a = %d, b = %d, sub = %d, exSum = %d, sum = %d", a, b, sub, exSum, sum);
                $stop;
            end
        end
        $display("Tests passed with no errors.");
        $stop;
    end
endmodule
