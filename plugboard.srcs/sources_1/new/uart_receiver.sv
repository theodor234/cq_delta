module uart_rx 
(
    input  wire         clk,
    input  wire         reset,
    input  wire         baud_tick_16x,  // Semnalul de sincronizare de 16x Baud Rate
    input  wire         rxd,            // Linia de recep?ie fizic?
    
    output wire [7:0]   data_out,       // Octetul ASCII primit (litera)
    output wire         data_ready      // Puls care indic? disponibilitatea octetului
);

    // St?ri pentru Ma?ina de St?ri (FSM)
    localparam STATE_IDLE      = 3'd0; // A?teapt? bit de START (RXD = '1')
    localparam STATE_START_BIT = 3'd1; // Detectat bit de START ('0')
    localparam STATE_DATA_BITS = 3'd2; // Recep?ioneaz? cei 8 bi?i de date
    localparam STATE_STOP_BIT  = 3'd3; // A?teapt? bit de STOP ('1')
    
    reg [2:0] current_state = STATE_IDLE;
    
    // Contor de e?antionare în cadrul unui bit (num?r? 16 tick-uri)
    reg [3:0] sample_count = 0; 
    // Contor de bi?i (0 la 7)
    reg [2:0] bit_count = 0;
    
    // Registru de stocare temporar? a datelor primite
    reg [7:0] rx_data_reg = 8'h00;
    reg       data_ready_reg = 0;
    
    // Registru pentru detectarea tranzi?iei de la '1' la '0' (Start Bit)
    reg rxd_prev = 1; 

    // Asign?ri de ie?ire
    assign data_out   = rx_data_reg;
    assign data_ready = data_ready_reg;

    // Procesul de tranzi?ie a st?rilor
    always @(posedge clk) begin
        if (reset) begin
            current_state  <= STATE_IDLE;
            data_ready_reg <= 0;
            rxd_prev       <= 1;
        end else begin
            data_ready_reg <= 0; // Pulsul se ?terge automat la urm?toarea tactare

            // Detectarea tranzi?iei de la IDLE ('1') la START ('0')
            if (current_state == STATE_IDLE && rxd_prev == 1 && rxd == 0) begin
                current_state <= STATE_START_BIT;
                sample_count  <= 0; // Începem num?rarea tick-urilor
            end
            rxd_prev <= rxd; // Actualiz?m starea anterioar? a liniei RXD

            // Logic? declan?at? de tick-ul de baud rate (16x)
            if (baud_tick_16x) begin
                case (current_state)
                    
                    STATE_IDLE: begin
                        // A?teapt? tranzi?ia 1 -> 0 (logica de tranzi?ie este deasupra)
                    end
                    
                    STATE_START_BIT: begin
                        // A?teapt? 8 tick-uri pentru a ajunge în mijlocul bitului de START
                        if (sample_count == 4'd7) begin 
                            sample_count <= 0;
                            bit_count    <= 0;
                            current_state <= STATE_DATA_BITS; // Trecem la recep?ia datelor
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                    
                    STATE_DATA_BITS: begin
                        // A?teapt? 16 tick-uri pentru a ajunge în mijlocul urm?torului bit de date
                        if (sample_count == 4'd15) begin
                            // Salveaz? bitul curent (LSB first)
                            rx_data_reg[bit_count] <= rxd; 
                            
                            if (bit_count == 3'd7) begin // Ultimul bit de date (bitul 7)
                                sample_count  <= 0;
                                current_state <= STATE_STOP_BIT;
                            end else begin
                                sample_count  <= 0;
                                bit_count     <= bit_count + 1;
                            end
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                    
                    STATE_STOP_BIT: begin
                        // A?teapt? 16 tick-uri pentru a citi bitul de STOP
                        if (sample_count == 4'd15) begin
                            // Am citit bitul de STOP (care ar trebui s? fie '1')
                            if (rxd == 1) begin
                                data_ready_reg <= 1; // Semnal?m c? octetul este valid ?i gata
                                current_state  <= STATE_IDLE;
                            end else begin
                                // Eroare de framing (bitul de STOP nu este '1'), dar revenim la IDLE
                                current_state  <= STATE_IDLE; 
                            end
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                    
                endcase
            end
        end
    end
    endmodule