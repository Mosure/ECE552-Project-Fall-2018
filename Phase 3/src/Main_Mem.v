module Main_Mem(clk, rst, I_MM_write, D_MM_write, I_MM_Enable , D_MM_Enable, I_MM_data_in, D_MM_data_in, I_MM_address, D_MM_address, I_filling, D_filling,
			   I_MM_data_out, D_MM_data_out, I_MM_valid, D_MM_valid, I_stall, D_stall);

input clk, rst;
input I_MM_write, D_MM_write;	
input I_MM_Enable, D_MM_Enable;											
input[15:0] I_MM_data_in, D_MM_data_in;							
input[15:0] I_MM_address, D_MM_address;
input I_filling, D_filling;

output[15:0] I_MM_data_out, D_MM_data_out;					
output I_MM_valid, D_MM_valid;

output I_stall, D_stall;

wire[15:0] MM_data_out;
wire MM_valid;
wire MM_Enable, MM_write;
wire[15:0] MM_address, MM_data_in;
wire[15:0] D_store_addr;
wire[15:0] D_store_data;
wire D_store_write;
wire D_waiting;
wire I_busy, I_busy_prev;


/**************************************
******* Instantiate Main Memory *******
**************************************/

memory4c iMM(.clk(clk), .rst(rst), .enable(MM_Enable), .wr(MM_write), .addr(MM_address),
					  .data_in(MM_data_in), .data_out(MM_data_out), .data_valid(MM_valid));			

			
    assign I_stall = I_filling;
    assign D_stall = D_filling;
            
	assign I_busy = I_filling;
    assign D_busy = D_filling;
    dff negEdgeI(.d(I_busy), .q(I_busy_prev), .clk(clk), .rst(rst), .wen(1'b1));
    
    
    // If I is stalling, MM will enable whenever I sends a request.
    // If I finishes and D has been waiting, a D request needs to be resent.
    // Otherwise, just pay attention to D_enable
    assign MM_Enable = I_busy ? I_MM_Enable : ((!I_busy & I_busy_prev & D_waiting) ? 1'b1 : D_MM_Enable);
    
    // If I is stalling, MM will use whatever I wants to handle a miss.
    // If I finishes and D has been waiting, the stored address needs to be
    // reactivated and sent to MM. Otherwise, just send D_MM_address
    assign MM_address = I_busy ? I_MM_address : ((!I_busy & I_busy_prev & D_waiting) ? D_store_addr : D_MM_address);
    
    // MM_data_out can be directly connected to both caches,
    // since it will only be accepted when valid is high anyways
    assign I_MM_data_out = MM_data_out;
    assign D_MM_data_out = MM_data_out;
    
    // I miss takes precedence, so when I is busy, valid reads must be going
    // to I cache, otherwise they are going to D cache
    assign I_MM_valid = I_busy ? MM_valid : 1'b0;
    assign D_MM_valid = !I_busy ? MM_valid : 1'b0;
   
    // If a D memory request arrives and the MM is already busy handling an I request, the address and data need
    // to be saved
    dff storeDaddr[15:0](.d(D_MM_address), .q(D_store_addr), .clk(clk), .rst(rst), .wen(I_busy & D_MM_Enable));
    dff storeDdata[15:0](.d(D_MM_data_in), .q(D_store_data), .clk(clk), .rst(rst), .wen(I_busy & D_MM_Enable));
    
    // In addition we need to save whether the request was for a write or for a read.
    dff storeDwrite(.d(D_MM_write), .q(D_store_write), .clk(clk), .rst(rst), .wen(I_busy & D_MM_Enable));
    
    // Only D cache can write to memory, so the data in can be directly connected.
    // However MM_write should only be asserted once an I miss is done being handled
    assign MM_data_in = (!I_busy & I_busy_prev & D_waiting) ? D_store_data : D_MM_data_in;
    assign MM_write = (!I_busy & D_MM_write) | (!I_busy & I_busy_prev & D_waiting & D_store_write);
    
    // D waiting is asserted when a D request arrives and cache is busy. It will be asserted when I is finished
    // being handled
    dff Dwait(.d(~D_waiting), .q(D_waiting), .clk(clk), .rst(rst), .wen((I_busy & D_MM_Enable) | (!I_busy & I_busy_prev & D_waiting)));
    

endmodule