module tb_rotor_I;

    // Semnale pentru DUT (Device Under Test)
    logic        clk;
    logic        reset;
    logic        step;
    logic [4:0]  letter_in;
    logic [4:0]  starting_position;
    logic [1:0]  rotor_type;
    logic [4:0]  letter_out;
    logic        notch;

    // Instan?iere modul rotor_I
    rotor_I dut (
        .clk(clk),
        .reset(reset),
        .step(step),
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
        $display("\n=== Test Rotor_I Enigma ===\n");
        
        // Ini?ializare
        reset = 1;
        step = 0;
        letter_in = 0;
        starting_position = 0;
        rotor_type = 2'b00; // Rotor I
        
        #20;
        reset = 0;
        #10;

        //---------------------------------------
        // Test 1: Rotor I - pozi?ie ini?ial? 0, f?r? rota?ie
        //---------------------------------------
        $display("Test 1: Rotor I - pozi?ie 0, f?r? rota?ie");
        rotor_type = 2'b00;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        // Test?m primele 10 litere
        $display("  Liter? In -> Liter? Out");
        for (int i = 0; i < 10; i++) begin
            letter_in = i;
            #10;
            $display("  %s (%2d) -> %s (%2d)", 
                     letter_to_char(letter_in), letter_in, 
                     letter_to_char(letter_out), letter_out);
        end

        //---------------------------------------
        // Test 2: Verificare mecanism step (rota?ie cu step)
        //---------------------------------------
        $display("\nTest 2: Rota?ie rotor I cu step");
        reset = 1;
        starting_position = 5'd0;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0; // Trimitem mereu 'A'
        $display("  Trimitem mereu A, rotim rotorul cu step:");
        for (int i = 0; i < 5; i++) begin
            $display("  Pozi?ie: %2d, A -> %s, Notch: %b", 
                     dut.position, letter_to_char(letter_out), notch);
            step = 1;
            #10;
            step = 0;
            #10;
        end

        //---------------------------------------
        // Test 3: Verificare notch - Rotor I (pozi?ie Q=16)
        //---------------------------------------
        $display("\nTest 3: Verificare notch Rotor I (la pozi?ia Q=16)");
        rotor_type = 2'b00;
        starting_position = 5'd14; // Începem de la pozi?ia 14
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0;
        for (int i = 0; i < 5; i++) begin
            $display("  Pozi?ie: %2d (%s), Notch: %b %s", 
                     dut.position, 
                     letter_to_char(dut.position),
                     notch,
                     (notch) ? "<-- NOTCH ACTIV!" : "");
            step = 1;
            #10;
            step = 0;
            #10;
        end

        //---------------------------------------
        // Test 4: Rotor II - pozi?ie 0
        //---------------------------------------
        $display("\nTest 4: Rotor II - pozi?ie 0");
        rotor_type = 2'b01;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        $display("  Liter? In -> Liter? Out");
        for (int i = 0; i < 8; i++) begin
            letter_in = i;
            #10;
            $display("  %s (%2d) -> %s (%2d)", 
                     letter_to_char(letter_in), letter_in, 
                     letter_to_char(letter_out), letter_out);
        end

        //---------------------------------------
        // Test 5: Rotor II - verificare notch (pozi?ie E=4)
        //---------------------------------------
        $display("\nTest 5: Verificare notch Rotor II (la pozi?ia E=4)");
        rotor_type = 2'b01;
        starting_position = 5'd2; // Începem de la pozi?ia 2
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0;
        for (int i = 0; i < 5; i++) begin
            $display("  Pozi?ie: %2d (%s), Notch: %b %s", 
                     dut.position, 
                     letter_to_char(dut.position),
                     notch,
                     (notch) ? "<-- NOTCH ACTIV!" : "");
            step = 1;
            #10;
            step = 0;
            #10;
        end

        //---------------------------------------
        // Test 6: Rotor III - pozi?ie 0
        //---------------------------------------
        $display("\nTest 6: Rotor III - pozi?ie 0");
        rotor_type = 2'b10;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        $display("  Liter? In -> Liter? Out");
        for (int i = 0; i < 8; i++) begin
            letter_in = i;
            #10;
            $display("  %s (%2d) -> %s (%2d)", 
                     letter_to_char(letter_in), letter_in, 
                     letter_to_char(letter_out), letter_out);
        end

        //---------------------------------------
        // Test 7: Rotor III - verificare notch (pozi?ie V=21)
        //---------------------------------------
        $display("\nTest 7: Verificare notch Rotor III (la pozi?ia V=21)");
        rotor_type = 2'b10;
        starting_position = 5'd19; // Începem de la pozi?ia 19
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0;
        for (int i = 0; i < 5; i++) begin
            $display("  Pozi?ie: %2d (%s), Notch: %b %s", 
                     dut.position, 
                     letter_to_char(dut.position),
                     notch,
                     (notch) ? "<-- NOTCH ACTIV!" : "");
            step = 1;
            #10;
            step = 0;
            #10;
        end

        //---------------------------------------
        // Test 8: Secven?? complet? A-Z pe Rotor I
        //---------------------------------------
        $display("\nTest 8: Secven?? complet? A-Z pe Rotor I (pozi?ie fix? 0)");
        rotor_type = 2'b00;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        $display("  Mapare complet? cablaj:");
        for (int i = 0; i < 26; i++) begin
            letter_in = i;
            #10;
            $display("  %s -> %s", letter_to_char(letter_in), letter_to_char(letter_out));
        end

        //---------------------------------------
        // Test 9: Rota?ie complet? 0-25 cu step
        //---------------------------------------
        $display("\nTest 9: Rota?ie complet? a rotorului (0-25) cu A ca intrare");
        rotor_type = 2'b00;
        starting_position = 5'd0;
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0; // Trimitem mereu 'A'
        $display("  Pozi?ie -> A devine:");
        for (int i = 0; i < 26; i++) begin
            #10;
            $display("  Poz %2d (%s): A -> %s, Notch=%b", 
                     dut.position, letter_to_char(dut.position),
                     letter_to_char(letter_out), notch);
            step = 1;
            #10;
            step = 0;
        end

        //---------------------------------------
        // Test 10: Verificare wrap-around (pozi?ie 25 -> 0)
        //---------------------------------------
        $display("\nTest 10: Verificare wrap-around (pozi?ie 25 -> 0)");
        rotor_type = 2'b00;
        starting_position = 5'd24; // Începem de la 24
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        letter_in = 5'd0;
        for (int i = 0; i < 4; i++) begin
            $display("  Pozi?ie: %2d, A -> %s", dut.position, letter_to_char(letter_out));
            step = 1;
            #10;
            step = 0;
            #10;
        end

        $display("\n=== Teste completate cu succes ===\n");
        #100;
        $finish;
    end

    // Dump pentru vizualizare în GTKWave
    initial begin
        $dumpfile("rotor_I_tb.vcd");
        $dumpvars(0, tb_rotor_I);
    end

endmodule