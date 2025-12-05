module top_tb;

    // -------------------------------------
    // Semnale TB → TOP
    // -------------------------------------
    logic clk;
    logic rst;
    logic rxd;

    logic mode;
    logic set;

    logic [4:0] plugboard_config [0:25];
    logic [4:0] starting_position [0:2];
    logic [1:0] rotor_type [0:2];

    logic [4:0] litera_out;

    // -------------------------------------
    // Instantiere DUT (Device Under Test)
    // -------------------------------------
    top dut (
        .clk(clk),
        .rst(rst),
        .rxd(rxd),
        .plugboard_config(plugboard_config),
        .starting_position(starting_position),
        .rotor_type(rotor_type),
        .mode(mode),
        .set(set),
        .litera_out(litera_out)
    );

    // -------------------------------------
    // Clock 100 MHz
    // -------------------------------------
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz → perioada 10ns

    // -------------------------------------
    // Task pentru trimiterea unui BYTE prin UART la 115200 baud
    // -------------------------------------
    task uart_send_byte(input [7:0] data);
        int i;
        real bit_time = 1e9 / 115200; // ns pe bit (~8680 ns)

        begin
            // start bit (0)
            rxd = 0;
            #(bit_time);

            // data bits (LSB first)
            for (i = 0; i < 8; i++) begin
                rxd = data[i];
                #(bit_time);
            end

            // stop bit (1)
            rxd = 1;
            #(bit_time);
        end
    endtask

    // -------------------------------------
    // Setup inițial
    // -------------------------------------
    initial begin
        integer i;

        // initializează linii
        rxd = 1; // UART idle
        mode = 1;
        set = 0;

        // Reset global
        rst = 1;
        repeat (10) @(posedge clk);
        rst = 0;
        repeat (10) @(posedge clk);

        // Configurăm plugboard ca identitate
        for (i = 0; i < 26; i++)
            plugboard_config[i] = i;

        // Setăm rotor positions
        starting_position[0] = 0;
        starting_position[1] = 0;
        starting_position[2] = 0;

        // tipurile rotorului (I, II, III)
        rotor_type[0] = 0;
        rotor_type[1] = 1;
        rotor_type[2] = 2;

        // Trimitem litere prin UART
        $display("\n--- Trimit 'A' prin UART ---");
        uart_send_byte(8'h41);
        repeat (20000) @(posedge clk);
        $display("Litera criptată = %0d (0=A, 1=B...)", litera_out);

        $display("\n--- Trimit 'B' prin UART ---");
        uart_send_byte(8'h42);
        repeat (20000) @(posedge clk);
        $display("Litera criptată = %0d", litera_out);

        // Închide simularea
        repeat (1000) @(posedge clk);
        $finish;
    end

endmodule
