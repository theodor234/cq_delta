module UART_RX #(
    parameter CLK_FREQ = 100000000,  
    parameter BAUD_RATE = 9600,       
    
    parameter CLKS_PER_BIT = CLK_FREQ / BAUD_RATE 
)
(
    input clk,
    input reset,
    input RXD,               
    output reg [7:0] data_out, 
    output reg data_valid     
);

    
    localparam [2:0] 
        IDLE        = 3'b000,
        START_BIT   = 3'b001,
        DATA_BITS   = 3'b010,
        STOP_BIT    = 3'b011,
        CLEANUP     = 3'b100;
        
    reg [2:0] rx_state;
    
    
    reg [16:0] clk_count;
    reg [3:0] bit_index;
    
    
    reg [7:0] data_buffer;

    
    localparam CLKS_PER_SAMPLE = CLKS_PER_BIT / 2;
    reg sample_tick;



    always @(posedge clk) begin
        if (reset) begin
            clk_count <= 0;
            sample_tick <= 0;
        end else begin
            if (rx_state != IDLE) begin
                if (clk_count == (CLKS_PER_BIT - 1)) begin
                    clk_count <= 0;
                    sample_tick <= 1;
                end else begin
                    clk_count <= clk_count + 1;
                    sample_tick <= 0;
                end
            end else begin
                
                if (~RXD) begin 
                    clk_count <= CLKS_PER_SAMPLE; 
                end else begin
                    clk_count <= 0;
                end
                sample_tick <= 0;
            end
        end
    end


    always @(posedge clk) begin
        if (reset) begin
            rx_state <= IDLE;
            data_valid <= 0;
            data_out <= 0;
        end else begin
            data_valid <= 0; 
            
            case (rx_state)
                IDLE: begin
                    bit_index <= 0;
                    if (~RXD) begin 
                        rx_state <= START_BIT;
                    end
                end
                
                START_BIT: begin
                    if (sample_tick) begin
                        if (~RXD) begin 
                            rx_state <= DATA_BITS;
                        end else begin
                            rx_state <= IDLE; 
                        end
                    end
                end
                
                DATA_BITS: begin
                    if (sample_tick) begin
                        
                        data_buffer[bit_index] <= RXD;
                        
                        if (bit_index == 7) begin
                            bit_index <= 0;
                            rx_state <= STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end
                end
                
                STOP_BIT: begin
                    if (sample_tick) begin
                        if (RXD) begin 
                            rx_state <= CLEANUP;
                        end else begin
                            rx_state <= IDLE; 
                        end
                    end
                end
                
                CLEANUP: begin
                    data_out <= data_buffer; 
                    data_valid <= 1;         
                    rx_state <= IDLE;
                end
                
                default: rx_state <= IDLE;
            endcase
        end
    end

endmodule