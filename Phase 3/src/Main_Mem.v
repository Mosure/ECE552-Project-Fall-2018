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

output reg I_stall, D_stall;

wire[15:0] MM_data_out;
wire MM_valid;
reg MM_Enable, MM_write;
reg[15:0] MM_address, MM_data_in;

reg waiting;											// Asserted when one cache is waiting while other's request is being handled 

reg[1:0] nxt_state;
wire[1:0] state;

/**************************************
******* Instantiate Main Memory *******
**************************************/

memory4c iMM(.clk(clk), .rst(rst), .enable(MM_Enable), .wr(MM_write), .addr(MM_address),
					  .data_in(MM_data_in), .data_out(MM_data_out), .data_valid(MM_valid));			

/**************************************
********** Infer a State flop *********
**** 00: IDLE *************************
**** 01: Service the I-cache miss *****
**** 10: Service the D-cache miss *****
**** 11: Not valid ********************
**************************************/

dff stateFlop0(.clk(clk), .rst(rst), .d(nxt_state[0]), .q(state[0]), .wen(1'b1));
dff stateFlop1(.clk(clk), .rst(rst), .d(nxt_state[1]), .q(state[1]), .wen(1'b1)); 	

/**************************************
***** Next state and Output logic *****
**************************************/

always@(*) begin

	case(state)
	
	2'b00:	begin
				MM_Enable = (I_filling) ? I_MM_Enable :
							(D_filling) ? D_MM_Enable : 1'b0;
				MM_write = (I_filling) ? I_MM_write :
						   (D_filling) ? D_MM_write : 1'b0;
				MM_address = (I_filling) ? I_MM_address :
							 (D_filling) ? D_MM_address : 16'h0000;
				MM_data_in = (I_filling) ? I_MM_data_in :
							 (D_filling) ? D_MM_data_in : 16'h0000;
				nxt_state = (I_filling) ? 2'b01 :								// I-cache given preference over D-cache		
							(D_filling) ? 2'b10 : 2'b00;
				waiting = (I_filling && D_filling);								// Both caches are requesting, so I is handled and D is waiting	
				I_stall = (I_filling) ? 1'b1 : 1'b0;
				D_stall = (D_filling) ? 1'b1 : 1'b0;
			end
			
	2'b01:	begin
				MM_Enable = (I_filling) ? I_MM_Enable :
							(waiting) ? D_MM_Enable : 1'b0;
				MM_write = (I_filling) ? I_MM_write :
						   (waiting) ? D_MM_write : 1'b0;
				MM_address = (I_filling) ? I_MM_address :
							 (waiting) ? D_MM_address : 16'h0000;
				MM_data_in = (I_filling) ? I_MM_data_in :
							 (waiting) ? D_MM_data_in : 16'h0000;
				nxt_state = (I_filling) ? 2'b01 :
							(waiting) ? 2'b10 : 2'b00;
				waiting = (I_filling && D_filling);	
				I_stall = (I_filling) ? 1'b1 : 1'b0;
				D_stall = (waiting) ? 1'b1 : 1'b0;
						  
			end
			
	2'b10:	begin
				MM_Enable = (D_filling) ? D_MM_Enable :
							(waiting) ? I_MM_Enable : 1'b0;
				MM_write = (D_filling) ? D_MM_write :
						   (waiting) ? I_MM_write : 1'b0;
				MM_address = (D_filling) ? D_MM_address :
							 (waiting) ? I_MM_address : 16'h0000;
				MM_data_in = (D_filling) ? D_MM_data_in :
							 (waiting) ? I_MM_data_in : 16'h0000;
				nxt_state = (D_filling) ? 2'b10 :
							(waiting) ? 2'b01 : 2'b00;
				waiting = (I_filling && D_filling);
				I_stall = (waiting) ? 1'b1 : 1'b0;
				D_stall = (D_filling) ? 1'b1 : 1'b0;
			end
			
	default:begin
				MM_Enable = 1'b0;
				MM_write = 1'b0;
				MM_address = 16'h0000;
				MM_data_in = 16'h0000;
				nxt_state = 2'b00;
				waiting = 1'b0;
				I_stall = 1'b0;
				D_stall = 1'b1;
			end

	endcase
end	
	
assign I_MM_data_out = (I_stall) ? MM_data_out : 16'h0000;
assign D_MM_data_out = (D_stall) ? MM_data_out : 16'h0000;
assign I_MM_valid = (I_stall) ? MM_valid : 1'b0;
assign D_MM_valid = (D_stall) ? MM_valid : 1'b0;

endmodule	