// Gokul's D-flipflop

module dff (q, d, wen, clk, rst);

    output         q; //DFF output
    input          d; //DFF input
    input 	       wen; //Write Enable
    input          clk; //Clock
    input          rst; //Reset (used synchronously)

    reg            state, next_state;

    assign q = state;

    always @(*) begin
        next_state = rst ? 0 : (wen ? d : state);
    end

    always @(posedge clk) begin
        state <= next_state;
    end

endmodule
