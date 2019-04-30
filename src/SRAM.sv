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
    input      [2:0]  top_state,
    input             reverse,

    //SRAM
    output reg [19:0] SRAM_ADDR,
    inout      [15:0] SRAM_DQ,
    output reg        SRAM_CE_N,
    output            SRAM_OE_N,
    output reg        SRAM_WE_N,
    output            SRAM_UB_N,
    output            SRAM_LB_N
);
	
    //input  output
    logic [15:0] n_out_signal;
    logic [19:0] n_in_addr, n_out_addr;
    logic n_out_sigal_valid, n_full;

    logic [19:0] n_SRAM_ADDR;
    logic [15:0] _SRAM_DQ, n_SRAM_DQ;
    logic SRAM_DQ_z, n_SRAM_DQ_z;
    logic n_SRAM_CE_N, n_SRAM_WE_N;
    assign SRAM_DQ = SRAM_DQ_z ? 16'dz : _SRAM_DQ;
    assign SRAM_UB_N = 1'd0;
    assign SRAM_LB_N = 1'd0;
    assign SRAM_OE_N = 1'd0;

    //state
    logic isRead, n_isRead;
    logic [19:0] record_ptr, n_record_ptr;

    always_comb begin
        if (top_state[2]) n_full =  (record_ptr == 20'hfffff);
        else n_full = reverse ? (out_addr == 20'd0) : (out_addr == in_addr);
    end

    //out_addr
    always_comb begin
        if (top_state[2]) n_out_addr = reverse ? in_addr : 20'd0;
        else begin
            case (top_state[1:0])
                2'b00 : n_out_addr = reverse ? in_addr : 20'd0;
                2'b01 : n_out_addr = reverse ? in_addr : 20'd0;
                2'b10 : begin
                    if (request_out_signal & (~isRead) & (~out_signal_valid)) n_out_addr = reverse ? out_addr - 20'd1 : out_addr + 20'd1;
                    else n_out_addr = out_addr;
                end
                2'b11 : n_out_addr = out_addr;
            endcase // top_state[1:0]
        end
    end

    //in_addr
    always_comb begin
        if(~top_state[2]) begin
            n_in_addr = in_addr;
            n_record_ptr = 20'd0;
        end else begin
            case (top_state[1:0])
                2'b10 : begin 
                    if(in_signal_valid) begin
                        n_in_addr = record_ptr + 20'd1;
                        n_record_ptr = record_ptr + 20'd1;
                    end else begin
                        n_in_addr = record_ptr;
                        n_record_ptr = record_ptr;
                    end
                end

                2'b11 : begin
                    n_in_addr = in_addr;
                    n_record_ptr = record_ptr;
                end

                //2'b00 2'b01
                default : begin
                    n_in_addr = in_addr;
                    n_record_ptr = 20'd0;
                end
                
            endcase
        end
    
    end

    //state && SRAM
    always_comb begin
        if(top_state[1:0] != 2'b10 ) begin
            n_isRead = 1'd0;
            n_SRAM_CE_N = 1'd1;
            n_SRAM_WE_N = 1'd0;
            n_SRAM_ADDR = SRAM_ADDR;
            n_SRAM_DQ = 16'd0;
            n_SRAM_DQ_z = 1'd1;
        end else if (in_signal_valid) begin
            n_isRead = 1'd0;
            n_SRAM_CE_N = 1'd0;
            n_SRAM_WE_N = 1'd0;
            n_SRAM_ADDR = in_addr;
            n_SRAM_DQ = in_signal;
            n_SRAM_DQ_z = 1'd0;
        end else if (request_out_signal & (~isRead) & (~out_signal_valid)) begin
            n_isRead = 1'd1;
            n_SRAM_CE_N = 1'd0;
            n_SRAM_WE_N = 1'd1;
            n_SRAM_ADDR = out_addr;
            n_SRAM_DQ = 16'd0;
            n_SRAM_DQ_z = 1'd1;
        end else begin
            n_isRead = 1'd0;
            n_SRAM_CE_N = 1'd1;
            n_SRAM_WE_N = 1'd0;
            n_SRAM_ADDR = SRAM_ADDR;
            n_SRAM_DQ = 16'd0;
            n_SRAM_DQ_z = 1'd1;
        end
    end

    //output
    always_comb begin
        if(isRead) begin
            n_out_signal = SRAM_DQ;
            n_out_sigal_valid = 1'd1;
        end else begin
            n_out_signal = out_signal;
            n_out_sigal_valid = 1'd0;
        end
    
    end

    always_ff @(posedge i_clk or negedge i_rst) begin
        if(~i_rst) begin
            //input output
            out_signal <= 16'd0;
            in_addr <= 20'd0;
            out_addr <= 20'd0;
            out_signal_valid <= 1'd0;
            full <= 1'd1;

            SRAM_ADDR <= 20'd0;
            SRAM_CE_N <= 1'd1;
            SRAM_WE_N <= 1'd0;
            _SRAM_DQ <= 16'd0;
            SRAM_DQ_z <= 1'd1;

            //state
            isRead <= 1'd0;
            record_ptr <= 20'd0;


        end else begin
            //input output
            out_signal <= n_out_signal;
            in_addr <= n_in_addr;
            out_addr <= n_out_addr;
            out_signal_valid <= n_out_sigal_valid;
            full <= n_full;

            SRAM_ADDR <= n_SRAM_ADDR;
            SRAM_CE_N <= n_SRAM_CE_N;
            SRAM_WE_N <= n_SRAM_WE_N;
            _SRAM_DQ <= n_SRAM_DQ;
            SRAM_DQ_z <= n_SRAM_DQ_z;

            //state
            isRead <= n_isRead;
            record_ptr <= n_record_ptr;

        end
    end

endmodule // SRAM
