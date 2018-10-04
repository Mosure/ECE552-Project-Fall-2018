// Since we are sign extending in only a few places, this could be setup to do static length sign extensions but unless we are graded based on CPU performance, this is simpler
// Do out = (in << extension_bits) >> extension_bits;
module sign_ext(in, out, extension_bits);
    input   [15:0]  in;
    input   [3:0]   extension_bits;

    output  [15:0]  out;

    wire    [15:0]  res_shift;

    shifter ls  (.in(in), .out(res_shift), .shift(extension_bits), .mode(2'b00));
    shifter rss (.in(res_shift), .out(out), .shift(extension_bits), .mode(2'b01));
endmodule
