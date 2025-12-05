`timescale 1ns / 1ps

module tb_ukw_b;

    logic clk;
    logic [4:0] in;
    logic [4:0] out;

    // instan?iere modul
    ukw_b dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // clock 100MHz
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        in  = 0;

        // aplic?m toate cele 26 de valori
        for (int i = 0; i < 26; i++) begin
            in = i;
            @(posedge clk);  // a?teapt? ie?irea sincron?
        end

        $finish;
    end

endmodule
