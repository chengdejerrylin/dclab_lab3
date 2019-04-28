module SRAM(
    input             i_clk,
    input             i_rst,            //i_rst = 1 -> reset
    input      [15:0] in_signal,        //from I2S
    output reg [15:0] out_signal,       //to DSP
    output reg [19:0] in_addr,          //record to what addr
    output reg [19:0] out_addr,         //play to what addr
    input             request_out_signal,
    input             in_signal_valid,  
	output reg        out_signal_valid, 
    output reg        full,             
    input      [2:0]  top_state,        //

    //SRAM
    output reg [19:0] SRAM_ADDR,
    inout      [15:0] SRAM_DQ,
    output reg        SRAM_CE_N,
    output reg        SRAM_OE_N,
    output reg        SRAM_WE_N,
    output reg        SRAM_UB_N,
    output reg        SRAM_LB_N
);
	
    logic [15:0] w_out_signal;
    logic [19:0] w_in_addr, w_out_addr;
    logic        w_out_signal_valid;
    logic        w_full;

    logic [19:0] w_SRAM_ADDR;
    logic [15:0] w_SRAM_DQ;
    logic [15:0] r_SRAM_DQ;
    logic        w_SRAM_CE_N;
    logic        w_SRAM_OE_N;
    logic        w_SRAM_WE_N;
    logic        w_SRAM_UB_N;
    logic        w_SRAM_LB_N;

    logic        w_in_start_addr, w_out_start_addr;
    logic        r_in_start_addr, r_out_start_addr;

    logic        w_addr_follow; 
    logic        r_addr_follow;

    assign SRAM_Q = r_SRAM_DQ;

	always_comb begin
        if( top_state[2] == 1 & top_state != 3'b101 ) begin //record, write
            if( in_signal_valid ) w_in_start_addr = in_addr; //remember the addr when first recording
            else w_in_start_addr = r_in_start_addr;

            case( top_state[1:0] ) 
                //RECORD_STOP
                2'b00: begin        
                    w_SRAM_DQ = 16'b0;
                    w_in_addr = in_addr;   
                    w_addr_follow = r_in_start_addr;       
                    w_SRAM_ADDR = SRAM_ADDR;    
                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx;
                end

                //RECORD_RECORD
                2'b10: begin  
                    w_SRAM_DQ = in_signal;

                    if( r_addr_follow == r_in_start_addr ) begin
                        w_in_addr = r_in_start_addr;   
                        w_addr_follow = r_in_start_addr;       
                        w_SRAM_ADDR = r_in_start_addr; 
                    end
                    else begin   
                        w_in_addr = in_addr + 1'b1;   
                        w_addr_follow = r_addr_follow + 1'b1;       
                        w_SRAM_ADDR = SRAM_ADDR + 1'b1; 
                    end 
                       
                    w_SRAM_CE_N = 1'b0;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'b0;
                    w_SRAM_UB_N = 1'b0;
                    w_SRAM_LB_N = 1'b0;
                end

                //RECORD_PAUSE
                2'b11: begin        
                    w_SRAM_DQ = 16'b0;
                    w_in_addr = in_addr;   
                    w_addr_follow = r_addr_follow;       
                    w_SRAM_ADDR = SRAM_ADDR;    
                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx;
                end

                default: begin
                    w_SRAM_DQ = 16'b0;
                    w_in_addr = in_addr;   
                    w_addr_follow = r_addr_follow;       
                    w_SRAM_ADDR = SRAM_ADDR;    
                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx;
                end
            endcase

            //unchanged
            w_out_signal = 16'b0;
            w_out_addr = out_addr;
            w_out_signal_valid = out_signal_valid;
            w_out_start_addr = r_out_start_addr;

            if( top_state[2] == 1 & top_state != 3'b101 & w_in_addr == 20'b1 ) begin   //write full
                w_full = 1'b1;
            end
            else begin
                //unchanged
                w_full = 1'b0;
            end
        end
        else if( top_state[2] == 0 ) begin //play, read
            if( request_out_signal ) w_out_start_addr = out_addr; //remember the addr when first playing
            else w_out_start_addr = r_out_start_addr;

            case( top_state[1:0] ) 
                //PLAY_STOP
                2'b00: begin        
                    w_out_signal_valid = 1'b0;       
                    w_out_signal = 16'b0;
                    w_SRAM_DQ = 16'bz; 

                    w_addr_follow = r_out_start_addr;
                    w_out_addr = out_addr;
                    w_SRAM_ADDR = SRAM_ADDR; 

                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx;
                end

                //PLAY_RECORD
                2'b10: begin  
                    w_out_signal_valid = 1'b1;
                    w_out_signal = SRAM_DQ;
                    w_SRAM_DQ = 16'bz;

                    if( r_addr_follow == r_out_start_addr ) begin
                        w_addr_follow = r_out_start_addr;
                        w_out_addr = r_out_start_addr;
                        w_SRAM_ADDR = r_out_start_addr; 
                    end
                    else begin   
                        w_addr_follow =r_addr_follow + 1'b1;
                        w_out_addr = out_addr + 1'b1;
                        w_SRAM_ADDR = SRAM_ADDR + 1'b1;
                    end 
                       
                    w_SRAM_CE_N = 1'b0;
                    w_SRAM_OE_N = 1'b0;
                    w_SRAM_WE_N = 1'b1;
                    w_SRAM_UB_N = 1'b0;
                    w_SRAM_LB_N = 1'b0;
                end

                //PLAY_PAUSE
                2'b11: begin 
                    w_out_signal_valid = 1'b0;       
                    w_out_signal = 16'b0;
                    w_SRAM_DQ = 16'bz; 

                    w_addr_follow =r_addr_follow;
                    w_out_addr = out_addr;
                    w_SRAM_ADDR = SRAM_ADDR; 

                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx;
                end

                default: begin
                    w_out_signal_valid = 1'b0;       
                    w_out_signal = 16'b0;
                    w_SRAM_DQ = 16'bz; 

                    w_addr_follow = r_addr_follow;
                    w_out_addr = out_addr;
                    w_SRAM_ADDR = SRAM_ADDR; 

                    w_SRAM_CE_N = 1'b1;
                    w_SRAM_OE_N = 1'bx;
                    w_SRAM_WE_N = 1'bx;
                    w_SRAM_UB_N = 1'bx;
                    w_SRAM_LB_N = 1'bx; 
                end
            endcase

            

            //unchanged
            w_in_addr = in_addr;
            w_in_start_addr = r_in_start_addr;

            if( top_state[2] == 0 & w_in_addr == w_out_addr ) begin   //read full
                w_full = 1'b1;
            end
            else begin
                //unchanged
                w_full = 1'b0;
            end
        end
        else begin
            //add by Cheng-De Lin
            w_in_start_addr = r_in_start_addr;
            w_out_start_addr = r_out_start_addr;
            w_addr_follow = r_addr_follow;

            //origin
            w_out_signal = 16'b0;
            w_in_addr = in_addr;
            w_out_addr = out_addr;
            w_out_signal_valid = 1'b0;
            w_full = full;
            w_SRAM_ADDR = SRAM_ADDR;
            w_SRAM_DQ = SRAM_DQ;
            w_SRAM_CE_N = 1'b1;
            w_SRAM_OE_N = 1'bx;
            w_SRAM_WE_N = 1'bx;
            w_SRAM_UB_N = 1'bx;
            w_SRAM_LB_N = 1'bx;
        end
	end


	always_ff@(posedge i_clk or negedge i_rst) begin
        if(~i_rst) begin
            out_signal       <= 16'b0;
            in_addr          <= 20'b0;
            out_addr         <= 20'b0;
            out_signal_valid <= 1'b0;
            full             <= 1'b0;

            r_in_start_addr <= 1'b0;
            r_out_start_addr <= 1'b0;
            r_addr_follow <= 1'b0;

            SRAM_ADDR <= 20'b0;
            r_SRAM_DQ <= 16'b0; 
            SRAM_CE_N <= 1'b1;
            SRAM_OE_N <= 1'bx;
            SRAM_WE_N <= 1'bx;
            SRAM_UB_N <= 1'bx;
            SRAM_LB_N <= 1'bx;
        end
        else begin
            out_signal       <= w_out_signal;
            in_addr          <= w_in_addr; 
            out_addr         <= w_out_addr;
            out_signal_valid <= w_out_signal_valid;
            full             <= w_full;

            r_in_start_addr <= w_in_start_addr;
            r_out_start_addr <= w_out_start_addr;
            r_addr_follow <= w_addr_follow;

            SRAM_ADDR <= w_SRAM_ADDR;
            r_SRAM_DQ <= w_SRAM_DQ; 
            SRAM_CE_N <= w_SRAM_CE_N;
            SRAM_OE_N <= w_SRAM_OE_N;
            SRAM_WE_N <= w_SRAM_WE_N;
            SRAM_UB_N <= w_SRAM_UB_N;
            SRAM_LB_N <= w_SRAM_LB_N;
            
        end
	end

endmodule // SRAM
