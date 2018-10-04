module shifter (in, out, shift, mode);
    input   [15:0]  in;
    input   [3:0]   shift;
    input   [1:0]   mode; // 0 - Left Shift, 1 - Arithmetic right shift, 2 - Right rotation

    output  [15:0]  out;

    wire    [15:0]  res_row0, res_row1, res_row2;
    wire    [1:0]   select;

    assign select = { |mode, ~(|mode) };

    always @*
        $display("mode: %b, select: %b", mode, select);

    shift_row_1 row0 (.in(in), .out(res_row0), .select({2{shift[0]}} & select), .sign_ext(mode[0]));
    shift_row_2 row1 (.in(res_row0), .out(res_row1), .select({2{shift[1]}} & select), .sign_ext(mode[0]));
    shift_row_4 row2 (.in(res_row1), .out(res_row2), .select({2{shift[2]}} & select), .sign_ext(mode[0]));
    shift_row_8 row3 (.in(res_row2), .out(out), .select({2{shift[3]}} & select), .sign_ext(mode[0]));
endmodule


module mux_3 (in, out, select);
    input   [2:0]   in;
    input   [1:0]   select;

    output          out;
    reg             out;
    
    always @*
    begin
        case (select)
            2'b00 : out = in[1];
            2'b01 : out = in[0];
            2'b10 : out = in[2];
            default : out = in[1];
    	endcase
    end
endmodule


module shift_row_1 (in, out, select, sign_ext);
    input   [15:0]  in;
    input   [1:0]   select;
    input           sign_ext;

    output  [15:0]  out;

    mux_3 bit0  (.in({ 1'b0,     in[0],  in[1] }), .out(out[0]),  .select(select));
    mux_3 bit1  (.in({ in[0],    in[1],  in[2] }), .out(out[1]),  .select(select));
    mux_3 bit2  (.in({ in[1],    in[2],  in[3] }), .out(out[2]),  .select(select));
    mux_3 bit3  (.in({ in[2],    in[3],  in[4] }), .out(out[3]),  .select(select));

    mux_3 bit4  (.in({ in[3],    in[4],  in[5] }), .out(out[4]),  .select(select));
    mux_3 bit5  (.in({ in[4],    in[5],  in[6] }), .out(out[5]),  .select(select));
    mux_3 bit6  (.in({ in[5],    in[6],  in[7] }), .out(out[6]),  .select(select));
    mux_3 bit7  (.in({ in[6],    in[7],  in[8] }), .out(out[7]),  .select(select));

    mux_3 bit8  (.in({ in[7],    in[8],  in[9] }), .out(out[8]),  .select(select));
    mux_3 bit9  (.in({ in[8],    in[9],  in[10]}), .out(out[9]),  .select(select));
    mux_3 bit10 (.in({ in[9],    in[10], in[11]}), .out(out[10]), .select(select));
    mux_3 bit11 (.in({ in[10],   in[11], in[12]}), .out(out[11]), .select(select));

    mux_3 bit12 (.in({ in[11],   in[12], in[13]}), .out(out[12]), .select(select));
    mux_3 bit13 (.in({ in[12],   in[13], in[14]}), .out(out[13]), .select(select));
    mux_3 bit14 (.in({ in[13],   in[14], in[15]}), .out(out[14]), .select(select));
    mux_3 bit15 (.in({ in[14],   in[15], in[0] & ~sign_ext | sign_ext & in[15]}), .out(out[15]), .select(select));
endmodule


module shift_row_2 (in, out, select, sign_ext);
    input   [15:0]  in;
    input   [1:0]   select;
    input           sign_ext;

    output  [15:0]  out;

    mux_3 bit0  (.in({ 1'b0,     in[0],  in[2] }), .out(out[0]),  .select(select));
    mux_3 bit1  (.in({ 1'b0,     in[1],  in[3] }), .out(out[1]),  .select(select));
    mux_3 bit2  (.in({ in[0],    in[2],  in[4] }), .out(out[2]),  .select(select));
    mux_3 bit3  (.in({ in[1],    in[3],  in[5] }), .out(out[3]),  .select(select));

    mux_3 bit4  (.in({ in[2],    in[4],  in[6] }), .out(out[4]),  .select(select));
    mux_3 bit5  (.in({ in[3],    in[5],  in[7] }), .out(out[5]),  .select(select));
    mux_3 bit6  (.in({ in[4],    in[6],  in[8] }), .out(out[6]),  .select(select));
    mux_3 bit7  (.in({ in[5],    in[7],  in[9] }), .out(out[7]),  .select(select));

    mux_3 bit8  (.in({ in[6],    in[8],  in[10]}), .out(out[8]),  .select(select));
    mux_3 bit9  (.in({ in[7],    in[9],  in[11]}), .out(out[9]),  .select(select));
    mux_3 bit10 (.in({ in[8],    in[10], in[12]}), .out(out[10]), .select(select));
    mux_3 bit11 (.in({ in[9],    in[11], in[13]}), .out(out[11]), .select(select));

    mux_3 bit12 (.in({ in[10],   in[12], in[14]}), .out(out[12]), .select(select));
    mux_3 bit13 (.in({ in[11],   in[13], in[15]}), .out(out[13]), .select(select));
    mux_3 bit14 (.in({ in[12],   in[14], in[0] & ~sign_ext | sign_ext & in[15]}), .out(out[14]), .select(select));
    mux_3 bit15 (.in({ in[13],   in[15], in[1] & ~sign_ext | sign_ext & in[15]}), .out(out[15]), .select(select));
endmodule


module shift_row_4 (in, out, select, sign_ext);
    input   [15:0]  in;
    input   [1:0]   select;
    input           sign_ext;

    output  [15:0]  out;

    mux_3 bit0  (.in({ 1'b0,     in[0],  in[4] }), .out(out[0]),  .select(select));
    mux_3 bit1  (.in({ 1'b0,     in[1],  in[5] }), .out(out[1]),  .select(select));
    mux_3 bit2  (.in({ 1'b0,     in[2],  in[6] }), .out(out[2]),  .select(select));
    mux_3 bit3  (.in({ 1'b0,     in[3],  in[7] }), .out(out[3]),  .select(select));

    mux_3 bit4  (.in({ in[0],    in[4],  in[8] }), .out(out[4]),  .select(select));
    mux_3 bit5  (.in({ in[1],    in[5],  in[9] }), .out(out[5]),  .select(select));
    mux_3 bit6  (.in({ in[2],    in[6],  in[10]}), .out(out[6]),  .select(select));
    mux_3 bit7  (.in({ in[3],    in[7],  in[11]}), .out(out[7]),  .select(select));

    mux_3 bit8  (.in({ in[4],    in[8],  in[12]}), .out(out[8]),  .select(select));
    mux_3 bit9  (.in({ in[5],    in[9],  in[13]}), .out(out[9]),  .select(select));
    mux_3 bit10 (.in({ in[6],    in[10], in[14]}), .out(out[10]), .select(select));
    mux_3 bit11 (.in({ in[7],    in[11], in[15]}), .out(out[11]), .select(select));

    mux_3 bit12 (.in({ in[8],    in[12], in[0] & ~sign_ext | sign_ext & in[15]}), .out(out[12]), .select(select));
    mux_3 bit13 (.in({ in[9],    in[13], in[1] & ~sign_ext | sign_ext & in[15]}), .out(out[13]), .select(select));
    mux_3 bit14 (.in({ in[10],   in[14], in[2] & ~sign_ext | sign_ext & in[15]}), .out(out[14]), .select(select));
    mux_3 bit15 (.in({ in[11],   in[15], in[3] & ~sign_ext | sign_ext & in[15]}), .out(out[15]), .select(select));
endmodule


module shift_row_8 (in, out, select, sign_ext);
    input   [15:0]  in;
    input   [1:0]   select;
    input           sign_ext;

    output  [15:0]  out;

    mux_3 bit0  (.in({ 1'b0,     in[0],  in[8] }), .out(out[0]),  .select(select));
    mux_3 bit1  (.in({ 1'b0,     in[1],  in[9] }), .out(out[1]),  .select(select));
    mux_3 bit2  (.in({ 1'b0,     in[2],  in[10]}), .out(out[2]),  .select(select));
    mux_3 bit3  (.in({ 1'b0,     in[3],  in[11]}), .out(out[3]),  .select(select));

    mux_3 bit4  (.in({ 1'b0,     in[4],  in[12]}), .out(out[4]),  .select(select));
    mux_3 bit5  (.in({ 1'b0,     in[5],  in[13]}), .out(out[5]),  .select(select));
    mux_3 bit6  (.in({ 1'b0,     in[6],  in[14]}), .out(out[6]),  .select(select));
    mux_3 bit7  (.in({ 1'b0,     in[7],  in[15]}), .out(out[7]),  .select(select));

    mux_3 bit8  (.in({ in[1],    in[8],  in[0] & ~sign_ext | sign_ext & in[15]}), .out(out[8]),  .select(select));
    mux_3 bit9  (.in({ in[2],    in[9],  in[1] & ~sign_ext | sign_ext & in[15]}), .out(out[9]),  .select(select));
    mux_3 bit10 (.in({ in[3],    in[10], in[2] & ~sign_ext | sign_ext & in[15]}), .out(out[10]), .select(select));
    mux_3 bit11 (.in({ in[4],    in[11], in[3] & ~sign_ext | sign_ext & in[15]}), .out(out[11]), .select(select));

    mux_3 bit12 (.in({ in[5],    in[12], in[4] & ~sign_ext | sign_ext & in[15]}), .out(out[12]), .select(select));
    mux_3 bit13 (.in({ in[6],    in[13], in[5] & ~sign_ext | sign_ext & in[15]}), .out(out[13]), .select(select));
    mux_3 bit14 (.in({ in[7],    in[14], in[6] & ~sign_ext | sign_ext & in[15]}), .out(out[14]), .select(select));
    mux_3 bit15 (.in({ in[8],    in[15], in[7] & ~sign_ext | sign_ext & in[15]}), .out(out[15]), .select(select));
endmodule
