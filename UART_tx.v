//module UART_tx(clk, rst, start_tx, data, tx_out, tx_done);
//
//	input clk, rst, start_tx;
//	input [7:0] data ;
//	output reg tx_out, tx_done;
//	
//	parameter IDL = 2'b00;
//	parameter start = 2'b01;
//	parameter txing = 2'b10;
//	parameter stop = 2'b11;
//	
//	reg set;
//	
//	reg [1:0] current_state, next_state;
//	reg [2:0] bit_count;
//	reg baud;
//	
////	baud_gen clk1(
////		.baud_tick(baud),
////		.clk(clk),
////		.rst(rst)
////	);
//	
//	always @(posedge clk or posedge rst) begin
//	
//		if(rst)
//			begin
//				current_state = IDL;
//				bit_count <= 3'b000;
//			end
//		else 
//			begin
//				current_state = next_state;
//				if(current_state == start)
//						bit_count <= 3'b000;
//						set <= 1'b0;
//					end
//
//				else if(current_state == txing && set == 1'b1)
//					bit_count <= bit_count + 1'b1;
//					
//				else 
//					set <= 1'b1;
//					
//			end
//
//	end
//	
//	
//	always @(*) begin 
//		
//		case(current_state)
//			
//			IDL : 
//				begin
//					if(start_tx)
//						next_state = start;
//					else
//						next_state = IDL;
//				end
//			
//			start : 
//				begin
//					next_state = txing;
//				end
//			
//			txing :
//				begin
//					if(bit_count == 3'b111)
//						next_state = stop;		
//					else 
//						begin
//							next_state = txing;
//						end
//				end
//						
//			stop :
//				begin
//					next_state = IDL;
//				end
//				
//		endcase
//	
//	end
//	
//	
////	always @(posedge clk or posedge rst) begin
////	
////		if(rst)
////			 
////
////		 else begin
////
////			  
////		 end
////	end
//	
//	
//	always @(*) begin 
//
//		
//		tx_out = 1'b1;
//		tx_done = 1'b1;
//		
//		case(current_state)
//		
//			IDL : 
//				begin
//					tx_out = 1'b1;
//					tx_done = 1'b0;
//				end
//				
//			start : 
//				begin 
//					tx_out = 1'b0;
//					tx_done = 1'b0;
//				end
//				
//			txing :
//				begin	
//					tx_out = data[bit_count];
//					tx_done = 1'b0;
//				end
//			
//			stop : 
//				begin
//					tx_out = 1'b1;
//					tx_done = 1'b1;
//				end
//			
//		endcase
//		
//	end
//	
//	
//endmodule
//
//			
//			
//			
//					
//	
//	
//	
//	
//	
//	
//	


module UART_tx(
    input clk, 
    input rst, 
    input start_tx, 
    input [7:0] data, 
    output reg tx_out, 
    output reg tx_done
);

    // State definitions
    parameter IDL   = 2'b00;
    parameter start = 2'b01;
    parameter txing = 2'b10;
    parameter stop  = 2'b11;
    
    reg [1:0] current_state, next_state;
    reg [2:0] bit_count;
    
    // Wire to connect the baud generator output
    wire baud_tick; 
    
    // -------------------------------------------------------------------------
    // 1. Module Instantiation (Connecting the Baud Generator)
    // -------------------------------------------------------------------------
    baud_gen_tx my_baud_clock (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );
    
    // -------------------------------------------------------------------------
    // 2. Sequential Logic (State Memory & Counters)
    // -------------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            current_state <= IDL;       
            bit_count     <= 3'b000;
        end
        else begin
            current_state <= next_state; 
            
            if(current_state == start) begin
                bit_count <= 3'b000;
            end
            else if(current_state == txing) begin
                // ONLY increment the bit counter when the baud timer ticks!
                if(baud_tick) begin
                    bit_count <= bit_count + 1'b1; 
                end
            end
        end
    end
    
    // -------------------------------------------------------------------------
    // 3. Combinational Logic (Next State Routing)
    // -------------------------------------------------------------------------
    always @(*) begin 
        next_state = current_state; 
        
        case(current_state)
            IDL : begin
                if(start_tx)
                    next_state = start;
            end
            
            start : begin
                // Wait for a baud tick so the start bit lasts for 1 full baud period
                if(baud_tick)
                    next_state = txing;
            end
            
            txing : begin
                // Wait until the 8th bit has finished its full baud period
                if(baud_tick && bit_count == 3'b111)
                    next_state = stop;        
            end
                    
            stop : begin
                // Wait for a baud tick so the stop bit lasts for 1 full baud period
                if(baud_tick)
                    next_state = IDL;
            end
        endcase
    end
    
    // -------------------------------------------------------------------------
    // 4. Combinational Logic (Outputs)
    // -------------------------------------------------------------------------
    always @(*) begin 
        tx_out  = 1'b1;
        tx_done = 1'b0;
        
        case(current_state)
            IDL : begin
                tx_out  = 1'b1;
                tx_done = 1'b0;
            end
                
            start : begin 
                tx_out  = 1'b0; 
                tx_done = 1'b0;
            end
                
            txing : begin    
                tx_out  = data[bit_count]; 
                tx_done = 1'b0;
            end
            
            stop : begin 
                tx_out  = 1'b1; 
                tx_done = 1'b1; 
            end
        endcase
    end
    
endmodule
