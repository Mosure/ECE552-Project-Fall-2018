module cache(clk, rst, procDataIn, procDataOut, procAddress, cacheEnable, cacheWrite,
            stall, memDataIn, memDataOut, memEnable, memWrite, memValid, memAddress);
    input clk, rst;             // Standard clock and active-high reset signals
    input cacheEnable;          // Asserted when memory instruction is happening
    input cacheWrite;           // Asserted when memory instruction is a write
    input memValid;             // Asserted when data word coming from MM is valid
    input[15:0] procDataIn;     // data to be written on a write
    input[15:0] procAddress;    // Memory address being read or written to by instruction
    input[15:0] memDataOut;     // Data word coming from MM up to cache
    output stall;               // Stalls pipeline on a cache miss
    output memEnable;           // Enables the main memory for reads or writes
    output memWrite;            // Enables a write to main memory
    output[15:0] procDataOut;   // Data to be read on a read instruction
    output[15:0] memDataIn;     // Data word being written down to memory
    output[15:0] memAddress;    // Address being pulled up from Main memory
    
    
    ////////////////////////////////////
    // Additional Internal Signals ////
    //////////////////////////////////
    
    // Tag Comparison Signals
    wire[5:0] activeTag;        // Tag of the address being processed
    wire[5:0] activeSet;        // The set that the address maps to
    wire[63:0] setSelect;       // One-hot input to address meta data set
    wire[15:0] tagWord;         // The two tags in the active Set
    wire tag1HIT, tag0HIT;      // Flags that are set when a tag is correct
    wire miss_detected;         // Asserted when neither tag hits, i.e. a miss happens
   
    // Components of currently active metaDataArray entry
    wire[5:0] tag0, tag1;       // the two tags
    wire valid0, valid1;        // two valid bits
    wire LRU0, LRU1;            // Two LRU bits for the active set
    
    // Block and Word Select signals, for DataArray indexing
    wire blockLSB;
    wire[6:0] activeBlock;      // Block in the data array that needs to be accessed
    wire[127:0] blockSelect;    // One-hot block input to index data array
    wire[2:0] procWord;         // block word requested by instruction
    wire[2:0] memWord;          // block word requested by fill FSM
    wire[2:0] activeWord;       // block word being indexed
    wire[7:0] wordSelect;       // One-hot word input to index data array
    
    
    // Data and Meta Data array input and write signals
    wire dataWrite;             // Write enable for the data array
    wire metaWrite;             // Write enable for the meta data array
    wire[15:0] arrayDataIn;     // Input to data array
    reg[15:0] newTagWord;       // input to meta data array
    
    // Additional Miss Handler Output signals
    wire dataUpdate;            // Asserted when new word from MM is ready
    wire tagUpdate;            
    // Asserted when new block from MM is done updating
    
    
    /////////////////////
    // Sub-modules /////
    ///////////////////
    
    // Data Array holds 64 2-way sets of 16 bytes each
    DataArray data(.clk(clk), .rst(rst), .DataIn(arrayDataIn), .Write(dataWrite), 
                   .BlockEnable(blockSelect), .WordEnable(wordSelect), .DataOut(procDataOut));
    
    // Meta Data Array holds the tag, valid bit, and LRU bit for each line in data array
    MetaDataArray meta(.clk(clk), .rst(rst), .DataIn(newTagWord), 
                       .Write(metaWrite), .SetEnable(setSelect), .DataOut(tagWord));
    
    // Miss Handler that interfaces with MM to bring up memory blocks when misses occurs
    cache_fill_FSM missHandler(.clk(clk), .rst(rst), .miss_detected(miss_detected), 
                               .miss_address(procAddress), .fsm_busy(stall), 
                               .write_data_array(dataUpdate), .write_tag_array(tagUpdate), 
                               .memory_address(memAddress), .memory_data_valid(memValid));
    
    
    ///////////////////////////////////////////
    // Tag Comparison/ Hit Detection Logic ///
    /////////////////////////////////////////
    
    // Tag that needs to be looked up
    assign activeTag = procAddress[15:10];
    
    // Set that should be checked for the block
    assign activeSet = procAddress[9:4];
    
    // Determine the two tags that need to be checked 
    decoder_6_64 setFinder(.in(activeSet), .out(setSelect));
    assign {LRU1, valid1, tag1, LRU0, valid0, tag0} = tagWord;
  
    // Check for a hit on either tag
    assign tag1HIT = (tag1 == activeTag) & valid1;
    assign tag0HIT = (tag0 == activeTag) & valid0;
    
    assign miss_detected = !(tag1HIT | tag0HIT) & cacheEnable;
    
    
    //////////////////////////////
    // Block Select Logic  //////
    ////////////////////////////
       
    // On a miss, block to update is decided by valid and LRU bits,
    // On a hit, block 2 is used if tag2 is hit, else block 1 is used
    assign blockLSB = miss_detected ? ((!valid0) ? 0 : ((!valid1) ? 1 : LRU1)) : tag1HIT;
    
    // The active block is just the active set concatenated with the blockLSB
    assign activeBlock = {activeSet, blockLSB};
    
    // Convert block to one-hot value
    decoder_7_128 blockFinder(.in(activeBlock), .out(blockSelect));
    
    
    //////////////////////////
    // Word Select Logic ////
    ////////////////////////
    
    // Word of block that processor is requesting
    assign procWord = procAddress[3:1];
    
    // Word of block the fill FSM is acting on
    assign memWord = memAddress[3:1];
    
    // On a miss, word to update is the current word coming from memory
    // On a hit, the active word is the word requested by the instruction
    assign activeWord = miss_detected ? memWord : procWord;
    
    // Convert word to one-hot value
    decoder_3_8 wordFinder(.in(activeWord), .out(wordSelect) , .en(1'b1));
    
    
    ///////////////////////
    // memWrite Logic ////
    /////////////////////

    // Main memory is only written to when a write hit occurs
    assign memWrite = cacheEnable & cacheWrite & !miss_detected;
    
    
    /////////////////////////
    // memEnable Logic /////
    ///////////////////////
    
    // Main memory is accessed when writing to the cache (since its write through),
    // or if a miss is being handled and data is being brought up.
    assign memEnable = (!miss_detected & cacheWrite) | (miss_detected);
    
    
    ///////////////////////////
    // Data Write Logic //////
    /////////////////////////
    
    // Update data array on a write hit or when fill FSM says a new word
    // from MM is ready
    assign dataWrite = (cacheWrite & !miss_detected) | dataUpdate;
    
    
    ////////////////////////////
    // Meta Data Write Logic //
    //////////////////////////
    
    // Meta data is updated on every cache hit(LRU bit), and each time a new
    // block is brought into the cache after a miss
    assign metaWrite = (cacheEnable & !miss_detected) | tagUpdate;
    
    
    ///////////////////////////////
    // Meta Array Input Logic ////
    /////////////////////////////
    
    // On hits, the only change to the meta data is the LRU bit
    // On a miss, the tag that changed is updated, and the LRU is updated
    always @ (*) 
        casex({tagUpdate, LRU1})
            2'b0_x: newTagWord = {tag0HIT, valid1, tag1, LRU0, valid0, tag0};
            2'b1_0: newTagWord = {!LRU1, valid0, tag1, LRU0, 1'b1, activeTag};
            2'b1_1: newTagWord = {!LRU1, valid0, activeTag, LRU0, 1'b1, tag0};
        endcase
        
        
    //////////////////////////////
    // Data Array Input Logic ///
    ////////////////////////////
    
    assign dataArrayIn = miss_detected ? memDataOut : procDataIn;
    
endmodule
    