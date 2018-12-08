module cache_queue(clk, rst, iMemValid, iMemDataOut, iMemDataIn, iMemAddress, iMemEnable, iMemWrite,
                             dMemValid, dMemDataOut, dMemDataIn, dMemAddress, dMemEnable, dMemWrite);
    input           clk;
    input           rst;

    // Is the output to the respective caches valid?
    output          iMemValid;
    output          dMemValid;

    // Read data out
    output  [15:0]  iMemDataOut;
    output  [15:0]  dMemDataOut;

    // Write data in
    input   [15:0]  iMemDataIn; // Can ignore this, iMemWrite = 0
    input   [15:0]  dMemDataIn;

    // Memory address (can only use one at a time)
    input   [15:0]  iMemAddress;
    input   [15:0]  dMemAddress;

    input           iMemEnable;
    input           dMemEnable;

    input           iMemWrite; // This will never be true so writes can only be made from dMemCache
    input           dMemWrite;

    wire            data_valid;
    wire            mem_write;
    wire            enable;
    wire            address;
    wire            data_out;

    // Handle states here
    wire            state;        // 1 if reading
    wire            next_state;
    wire            current_read; // 0 if IMEM, 1 if DMEM

    dff stateFlop(.clk(clk), .rst(rst), .d(next_state), .q(state), .wen(1'b1));

    assign next_state = (state) ? ((data_valid) ? 1'b0 : 1'b1) : ((mem_write) ? 1'b0 : ((iMemEnable | dMemEnable) ? 1'b1 : 1'b0));

    assign enable = (mem_write) ? 1'b1 : (~state & (iMemEnable | dMemEnable));

    assign current_read = (state) ? current_read : dMemEnable;

    assign address = (mem_write) ? dMemAddress : ((current_read) ? dMemAddress : iMemAddress);

    // Ground state -> Read1 or Read2

    memory4c MEM (.data_out(data_out), .data_in(dMemDataIn), .addr(address), .enable(enable), .wr(dMemWrite), .clk(clk), .rst(rst), .data_valid(data_valid));

    assign iMemDataOut = data_out;
    assign dMemDataOut = data_out;

    // assign valid based on state and memory.data_valid
    assign iMemValid = state & data_valid & ~current_read;
    assign dMemValid = state & data_valid & current_read;
endmodule