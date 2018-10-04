module shifter_tb ();
    reg signed  [15:0]  in;
    reg         [3:0]   shift;
    reg         [1:0]   mode;

    wire signed [15:0]  out;
    
    integer i;

    initial 
    begin
        for (i = 0; i < 100; i++)
            begin
                {in, shift, mode} = $random;

                if (mode == 2'b11)
                    begin
                        mode = 2'b00;
                    end

                #1;

                if (mode == 2'b00)
                    begin
                        if (in << shift !== out)
                            begin
                                $display("[FAIL %b] %b << %d != %b", mode, in, shift, out);
                            end
                    end
                else if (mode == 2'b01)
                    begin
                        if (in >>> shift !== out)
                            begin
                                $display("[FAIL %b] %b >>> %d != %b", mode, in, shift, out);
                            end
                    end
                else if (mode == 2)
                    begin

                    end
            end
        
        $display("Done.");
        #50 $finish;
    end
    
    shifter DUT (.in(in), .out(out), .shift(shift), .mode(mode));
endmodule
