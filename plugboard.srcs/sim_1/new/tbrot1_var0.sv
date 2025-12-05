module tb_rotor_II;

    // Semnale pentru DUT (Device Under Test)
    logic        clk;
    logic        reset;
    logic        step;
    logic        notch_in;
    logic [4:0]  letter_in;
    logic [4:0]  starting_position;
    logic [1:0]  rotor_type;
    logic [4:0]  letter_out;
    logic        notch;

    // Instan?iere modul rotor
    rotor_II dut (
        .clk(clk),
        .reset(reset),
        .step(step),
        .notch_in(notch_in),
        .letter_in(letter_in),
        .starting_position(starting_position),
        .rotor_type(rotor_type),
        .letter_out(letter_out),
        .notch(notch)
    );

    // Generare clock - 10ns perioada
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Func?ie pentru afi?are litere (A-Z)
    function string letter_to_char(input logic [4:0] val);
        return string'(65 + val); // 65 = 'A' în ASCII
    endfunction

    // Test scenarios
    initial begin
        $display("\n=== Test Rotor Enigma ===\n");
        
        // Ini?ializare
        reset = 1;
        step = 0;
        notch_in = 0;
        letter_in = 0;
        starting_position = 0;
        rotor_type = 2'b00; // Rotor I
        
        #10;
        reset = 0;
        #10;

        //---------------------------------------
        // Test 1: Rotor I - pozi?ie ini?ial? 0
        //---------------------------------------
        $display("Test 1: Rotor I - pozi?ie 0");
        rotor_type = 2'b00;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        // Test?m câteva litere
        for (int i = 0; i < 5; i++) begin
            letter_in = i;
            #10;
            $display("  %s -> %s", letter_to_char(letter_in), letter_to_char(letter_out));
        end

        //---------------------------------------
        // Test 2: Verificare rota?ie rotor
        //---------------------------------------
        $display("\nTest 2: Rota?ie rotor I (notch la Q=16)");
        reset = 1;
        starting_position = 5'd15; // Pozi?ie aproape de notch
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0; // A
        for (int i = 0; i < 3; i++) begin
            notch_in = 1;
            #10;
            notch_in = 0;
            #10;
            $display("  Pozi?ie: %0d, Notch: %b, %s -> %s", 
                     dut.position, notch, letter_to_char(letter_in), letter_to_char(letter_out));
        end

        //---------------------------------------
        // Test 3: Rotor II
        //---------------------------------------
        $display("\nTest 3: Rotor II - pozi?ie 0");
        rotor_type = 2'b01;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        for (int i = 0; i < 5; i++) begin
            letter_in = i;
            #10;
            $display("  %s -> %s", letter_to_char(letter_in), letter_to_char(letter_out));
        end

        //---------------------------------------
        // Test 4: Rotor III
        //---------------------------------------
        $display("\nTest 4: Rotor III - pozi?ie 0");
        rotor_type = 2'b10;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        for (int i = 0; i < 5; i++) begin
            letter_in = i;
            #10;
            $display("  %s -> %s", letter_to_char(letter_in), letter_to_char(letter_out));
        end

        //---------------------------------------
        // Test 5: Verificare notch pozi?iile
        //---------------------------------------
        $display("\nTest 5: Verificare pozi?ii notch");
        
        // Rotor I - notch la Q (16)
        rotor_type = 2'b00;
        starting_position = 5'd16;
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("  Rotor I: pozi?ie %0d (Q), notch = %b (a?teptat 1)", dut.position, notch);
        
        // Rotor II - notch la E (4)
        rotor_type = 2'b01;
        starting_position = 5'd4;
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("  Rotor II: pozi?ie %0d (E), notch = %b (a?teptat 1)", dut.position, notch);
        
        // Rotor III - notch la V (21)
        rotor_type = 2'b10;
        starting_position = 5'd21;
        reset = 1;
        #10;
        reset = 0;
        #10;
        $display("  Rotor III: pozi?ie %0d (V), notch = %b (a?teptat 1)", dut.position, notch);

        //---------------------------------------
        // Test 6: Secven?? complet? A-Z
        //---------------------------------------
        $display("\nTest 6: Secven?? complet? A-Z pe Rotor I");
        rotor_type = 2'b00;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        for (int i = 0; i < 26; i++) begin
            letter_in = i;
            #10;
            $display("  %s -> %s", letter_to_char(letter_in), letter_to_char(letter_out));
        end

        $display("\n=== Test completat ===\n");
        #100;
        $finish;
    end

    // Monitorizare semnale importante
    initial begin
        $monitor("Time=%0t | Rotor=%0d | Pos=%0d | In=%s | Out=%s | Notch=%b", 
                 $time, rotor_type, dut.position, 
                 letter_to_char(letter_in), letter_to_char(letter_out), notch);
    end

    // Generare fi?ier VCD pentru vizualizare
    initial begin
        $dumpfile("rotor_tb.vcd");
        $dumpvars(0, tb_rotor_II);
    end

endmodule