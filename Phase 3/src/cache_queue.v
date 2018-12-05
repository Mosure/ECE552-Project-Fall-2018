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

    // Whether or not the cache thinks it should enable memory
    input           iMemEnable;
    input           dMemEnable;

    // Whether or not the cache thinks it should write to memory
    input           iMemWrite; // This will never be true so writes can only be made from dMemCache
    input           dMemWrite;

    wire            data_valid;
    wire            mem_write;
    wire            enable;
    wire            address;
    wire            data_out;

    // Handle states here


    memory4c MEM (.data_out(data_out), .data_in(dMemDataIn), .addr(address), .enable(enable), .wr(mem_write), .clk(clk), .rst(rst), .data_valid(data_valid));

    assign iMemDataOut = data_out;
    assign dMemDataOut = data_out;

    // assign valid based on state and memory.data_valid
    assign iMemValid = 1'b0;
    assign dMemValid = 1'b0;
endmodule