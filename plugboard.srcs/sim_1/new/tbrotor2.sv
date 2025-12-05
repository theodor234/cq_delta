`timescale 1ns/1ps

module rotor_II_tb;

    // Semnale pentru DUT
    logic        clk;
    logic        reset;
    logic        step;
    logic        notch_in;
    logic [4:0]  letter_in;
    logic [4:0]  starting_position;
    logic [1:0]  rotor_type;
    logic [4:0]  letter_out;
    logic        notch_out;

    // Instan?ierea rotorului
    rotor_II dut (
        .clk(clk),
        .reset(reset),
        .step(step),
        .notch_in(notch_in),
        .letter_in(letter_in),
        .starting_position(starting_position),
        .rotor_type(rotor_type),
        .letter_out(letter_out),
        .notch_out(notch_out)
    );

    // Generare clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // perioada 10ns
    end

    // Test scenario
    initial begin
        $display("=== Test Rotor II ===\n");

        // Init
        reset = 1;
        step = 0;
        notch_in = 0;
        letter_in = 5'd0;       // A
        starting_position = 5'd0; // Pozi?ia A
        rotor_type = 2'b01;     // Rotor II

        @(posedge clk);
        reset = 0;
        @(posedge clk);

        // -------------------------
        // TEST 1: Stepping normal
        // -------------------------
        $display("--- TEST 1: Stepping normal ---");

        for (int i = 0; i < 5; i++) begin
            step = 1;
            letter_in = i;  // litere A, B, C...
            @(posedge clk);
            $display("Pas %0d: letter_in=%c, letter_out=%c, position=%0d, notch_out=%b",
                     i+1, letter_in+65, letter_out+65, dut.position, notch_out);
            step = 0;
            @(posedge clk);
        end

        // -------------------------
        // TEST 2: Double stepping
        // -------------------------
        $display("\n--- TEST 2: Double Stepping ---");

        // Set?m rotorul aproape de notch (E = 4)
        starting_position = 5'd3; // D
        reset = 1;
        @(posedge clk);
        reset = 0;
        @(posedge clk);

        // Pas 1: rotorul ajunge pe notch
        step = 1;
        notch_in = 1; // rotor precedent trimite semnal
        letter_in = 5'd0;
        @(posedge clk);
        $display("Pas 1: letter_out=%c, position=%0d, notch_out=%b (notch_in=1)",
                 letter_out+65, dut.position, notch_out);
        step = 0;
        notch_in = 0;
        @(posedge clk);

        // Pas 2: rotor II trebuie s? roteasc? din nou (double step)
        step = 1;
        @(posedge clk);
        $display("Pas 2: letter_out=%c, position=%0d, notch_out=%b (double step)",
                 letter_out+65, dut.position, notch_out);
        step = 0;
        @(posedge clk);

        $display("\n=== Test complet ===");
        #50;
        $finish;
    end

    // Monitorizare
    initial begin
        $monitor("T=%0t: step=%b, notch_in=%b, pos=%0d, letter_in=%c, letter_out=%c, notch_out=%b",
                 $time, step, notch_in, dut.position, letter_in+65, letter_out+65, notch_out);
    end

endmodule
