`timescale 1ns / 1ps

module uart_rx_tb;

    // Parametrii (Trebuie sa se potriveasca cu cei din modulul UART_RX)
    parameter CLK_FREQ  = 100000000;  // 100 MHz
    parameter BAUD_RATE = 9600;
    parameter CLK_PERIOD = 10;        // 10ns pentru 100 MHz
    
    // Calculam timpul in nanosecunde pentru un bit (pentru simulare)
    parameter BIT_TIME_NS = 1000000000 / BAUD_RATE; // (de ex. 104167 ns pentru 9600 baud)
    
    // Semnale de intrare (Reg)
    reg clk;
    reg reset;
    reg RXD_tb; // Pinul de receptie in testbench

    // Semnale de iesire (Wire)
    wire [7:0] received_data;
    wire data_valid;

    // Variabile interne
    integer i;

// ----------------------------------------------------
// 1. Instantierea Modulului de Testat (DUT - Device Under Test)
// ----------------------------------------------------
    UART_RX #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE)) DUT (
        .clk(clk),
        .reset(reset),
        .RXD(RXD_tb),
        .data_out(received_data),
        .data_valid(data_valid)
    );

// ----------------------------------------------------
// 2. Generarea Ceasului (100 MHz)
// ----------------------------------------------------
    initial begin
        clk = 1'b0;
        // Ceasul alterneaza la fiecare jumatate de perioada
        forever #(CLK_PERIOD / 2) clk = ~clk;
    end

// ----------------------------------------------------
// 3. Task pentru Transmiterea Seriala a unui Caracter
// ----------------------------------------------------
    task transmit_byte;
        input [7:0] tx_data;
        reg [7:0] temp_data;
        reg [3:0] bit_count;
        
        begin
            temp_data = tx_data;
            
            // 1. IDLE/Start: Asiguram ca linia e HIGH (IDLE)
            RXD_tb = 1'b1;
            #(BIT_TIME_NS); 

            // 2. START BIT (LOW - 0)
            $display("Timpul %0t: Transmitere START BIT (0)", $time);
            RXD_tb = 1'b0;
            #(BIT_TIME_NS); 

            // 3. DATA BITS (8 biti, LSB primul)
            for (bit_count = 0; bit_count < 8; bit_count = bit_count + 1) begin
                RXD_tb = temp_data[bit_count];
                $display("Timpul %0t: Transmitere BIT %0d: %b", $time, bit_count, RXD_tb);
                #(BIT_TIME_NS); 
            end

            // 4. STOP BIT (HIGH - 1)
            $display("Timpul %0t: Transmitere STOP BIT (1)", $time);
            RXD_tb = 1'b1;
            #(BIT_TIME_NS * 2); // Asteptam 2 intervale pentru a ne asigura ca RXD ajunge in IDLE
        end
    endtask

// ----------------------------------------------------
// 4. Secventa de Testare (Stimuli)
// ----------------------------------------------------
    initial begin
        // 1. Initializare
        reset = 1'b1;
        RXD_tb = 1'b1;
        $display("START Testbench. Frecventa Ceasului: %d MHz, Baud Rate: %d", CLK_FREQ/1000000, BAUD_RATE);
        
        // 2. Scoatere din Reset
        #100; // Asteptam putin dupa pornire
        reset = 1'b0;
        $display("Timpul %0t: Reset scos.", $time);
        
        // 3. Trimitem Caracterul 'A' (ASCII 8'h41)
        #2000;
        $display("Timpul %0t: ---------- Incepe Transmisia 'A' (0x41) ----------", $time);
        transmit_byte(8'h41); 
        
        // 4. Asteptam rezultatul si il afisam
        #5000;
        
        // 5. Trimitem un al doilea caracter (optional, pentru testarea resetarii)
        $display("Timpul %0t: ---------- Incepe Transmisia 'B' (0x42) ----------", $time);
        transmit_byte(8'h42); 
        
        #5000;
        
        // 6. Terminare simulare
        $finish;
    end

// ----------------------------------------------------
// 5. Monitorizare Rezultate
// ----------------------------------------------------
    always @(posedge clk) begin
        if (data_valid) begin
            $display("Timpul %0t: DATE RECEPTIONATE! ASCII: 0x%h, Caracter: %c", $time, received_data, received_data);
            
            // Verificare
            if (received_data == 8'h41) begin
                $display("VERIFICARE: 'A' receptionat corect!");
            end else if (received_data == 8'h42) begin
                 $display("VERIFICARE: 'B' receptionat corect!");
            end else begin
                $display("VERIFICARE: Eroare la receptie!");
            end
        end
    end

endmodule