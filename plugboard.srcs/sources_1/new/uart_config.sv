module baud_rate_generator 
#(
    parameter CLK_FREQ_HZ = 100000000, // 100 MHz
    parameter BAUD_RATE   = 115200
)
(
    input  wire         clk,
    input  wire         reset,
    output reg          baud_tick_16x
);

    // Calculul limitei contorului
    localparam COUNT_LIMIT = CLK_FREQ_HZ / (BAUD_RATE * 16);
    
    // Dimensiunea contorului (suficient pentru a num?ra pân? la COUNT_LIMIT)
    localparam COUNTER_WIDTH = $clog2(COUNT_LIMIT); 

    reg [COUNTER_WIDTH-1:0] counter = 0;

    always @(posedge clk) begin
        if (reset) begin
            counter         <= 0;
            baud_tick_16x   <= 0;
        end else begin
            // Verific?m dac? am ajuns la limita (COUNT_LIMIT - 1)
            if (counter == COUNT_LIMIT - 1) begin
                counter         <= 0;             // Reset?m contorul
                baud_tick_16x   <= 1;             // Gener?m un puls (tick)
            end else begin
                counter         <= counter + 1;   // Increment?m contorul
                baud_tick_16x   <= 0;             // F?r? puls
            end
        end
    end

endmodule