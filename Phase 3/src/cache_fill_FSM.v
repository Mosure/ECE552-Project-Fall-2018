module cache_fill_FSM(clk, rst, miss_detected, miss_address, fsm_busy, write_data_array, 
        write_tag_array, memory_address, memory_data_valid);
    input clk, rst;           // Standard clock and active-high reset signals
    input miss_detected;        // Asserted when Cache miss occurs
    input memory_data_valid;    // Asserted when data coming from memory is valid
    input[15:0] miss_address;   // Address that caused cache miss
    output reg fsm_busy;        // Tells cpu that cache is being filled (stall)
    output reg write_tag_array; // Asserted to tell cache to update tag array
    output reg write_data_array;// Asserted to tell cache to update data array
    output[15:0] memory_address;// Address of byte currently being pulled from memory

    wire state;                 // Output of state flop
    reg nxtState;               // Input of state flop
    wire[2:0] nxtCount, count;  // Input and Output of counter flop, respectively
    wire[2:0] countUp;          // count + 1
    wire cnt_full;              // Asserted when count == 7
    wire[11:0] block_address;   // first 12 bits of miss address, shared by all bytes being written
    reg cnt_en;                 // enable signal for counter flop
    
          
    // State Flop that tracks current state of the Cache Miss Handler
    // 1 when Cache miss is being handled, 0 otherwise
    dff stateFlop(.clk(clk), .rst(rst), .d(nxtState), .q(state), .wen(1'b1));
    
    // Counter flop keeps track of number of writes to the cache finished so far, from 0 to 7
    // the count is zeroed when the miss happens, and incremented each time memory_data_valid is asserted
    // cnt_full is set when count == 7
    dff counter[2:0](.clk(clk), .rst(rst), .d(nxtCount[2:0]), .q(count[2:0]), .wen(cnt_en));
    
    inc_3bit inc_count(.in(count), .out(countUp)); 
    assign nxtCount = miss_detected ? 3'h0 : countUp;
    assign cnt_full = &count; 
    
    
    // The memory_address being read from the cache is 2 byte aligned, and is composed of
    // the first 12 bit of the miss_address concatenated with the count
    assign block_address = miss_detected ? miss_address[15:4] : block_address;                                   
    assign memory_address = {block_address, count, 1'b0};
          

    // Finite State Machine Logic
    // There are two states, IDLE and ACTIVE, and the controller moves to ACTIVE when
    // miss_detected is asserted, and moves back to IDLE when the 8th data write is done. 
    always @ (state, miss_detected, memory_data_valid, cnt_full)
        casex ({state, miss_detected, memory_data_valid, cnt_full}) 
            4'b0_0_?_?: begin nxtState = 0; fsm_busy = 0; write_tag_array = 0; write_data_array = 0; cnt_en = 0; end // Waiting in IDLE state
            4'b0_1_?_?: begin nxtState = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 0; cnt_en = 1; end // Transition from IDLE to ACTIVE
            4'b1_?_0_0: begin nxtState = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 0; cnt_en = 0; end // Waiting in ACTIVE state
            4'b1_?_0_1: begin nxtState = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 0; cnt_en = 0; end // Waiting in ACTIVE, one write left
            4'b1_?_1_0: begin nxtState = 1; fsm_busy = 1; write_tag_array = 0; write_data_array = 1; cnt_en = 1; end // Data ready to be put in cache
            4'b1_?_1_1: begin nxtState = 0; fsm_busy = 1; write_tag_array = 1; write_data_array = 1; cnt_en = 0; end // Writes completed, go back to IDLE
            default: begin nxtState = 0; fsm_busy = 0; write_tag_array = 0; write_data_array = 0; cnt_en = 0; end
        endcase
    
                    
    
endmodule
