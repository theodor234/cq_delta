module top (
    // Clock / reset / UART
    input  logic          clk,
    input  logic          rst,            // reset global
    input  logic          rxd,            // UART RX

    // Plugboard config: 26 intr?ri (0..25)
    input  logic [4:0]    plugboard_config [0:25],

    // Rotor params: 3 rotoare, indexate 0..2
    input  logic [4:0]    starting_position [0:2],
    input  logic [1:0]    rotor_type        [0:2],

    // Control for plugboard config mode / set pulse
    input  logic          mode,           // 0 = config, 1 = encode
    input  logic          set,            // pulse pentru setarea cfg

    // Output
    output logic [4:0]    litera_out
);

    // ------------------------
    // Baud / UART
    // ------------------------
    logic baud_tick_16x;
    logic notch1;
    baud_rate_generator #(
        .CLK_FREQ_HZ(100_000_000),
        .BAUD_RATE(115_200)
    ) baud_gen_inst (
        .clk(clk),
        .reset(rst),                  // aten?ie: numele semnalului de reset este rst
        .baud_tick_16x(baud_tick_16x)
    );

    logic [4:0] uart_o;
    logic       data_ready;            // semnal de ready de la UART (folosit ca "step")

    uart_rx uart_rx_inst (
        .clk(clk),
        .reset(rst),
        .baud_tick_16x(baud_tick_16x),
        .rxd(rxd),
        .data_out(uart_o),
        .data_ready(data_ready)
    );

    // step = când primim un caracter (po?i redenumi/filtra dup? nevoie)
    logic step;
    assign step = data_ready;

    // ------------------------
    // Plugboard (înainte)
    // ------------------------
    logic [4:0] plug_o;

    plugboard #(
        .DATA_WIDTH(5),
        .ALPHABET_SIZE(26)
    ) plugboard_inst (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(uart_o),               // intrare vine din UART
        .cfg_in(plugboard_config),
        .set(set),
        .data_out(plug_o)
    );

    // ------------------------
    // Forward path through rotors
    // ------------------------
    logic [4:0] or1, or2, or3;           // outputs forward
    logic       notch1, notch2, notch3; // notch outputs for stepping chain

    // Rotor 1 (rightmost rotor)
    rotor_I rotor1 (
        .clk(clk),
        .reset(rst),
        .step(step),
        .letter_in(plug_o),
        .starting_position(starting_position[0]),
        .rotor_type(rotor_type[0]),
        .letter_out(or1),
        .notch(notch1)
    );

    // Rotor 2 (middle)
    rotor_II rotor2 (
        .clk(clk),
        .reset(rst),
        .step(step),
        .notch_in(notch1),               // chain stepping
        .letter_in(or1),
        .starting_position(starting_position[1]),
        .rotor_type(rotor_type[1]),
        .letter_out(or2),
        .notch_out(notch2)
    );

    // Rotor 3 (leftmost)
    rotor_III rotor3 (
        .clk(clk),
        .reset(rst),
        .step(step),
        .notch_in(notch2),
        .letter_in(or2),
        .starting_position(starting_position[2]),
        .rotor_type(rotor_type[2]),
        .letter_out(or3)
        
    );

    // ------------------------
    // Reflector
    // ------------------------
    logic [4:0] reflector_out;

    // p?strez o instan?? de reflector (UKW)
    ukw_b reflector_inst (
        .clk(clk),
        .in(or3),
        .out(reflector_out)
    );

    // ------------------------
    // Reverse path through rotors (reflect -> back)
    // folose?te module "rotor_reflector" pentru maparea invers?
    // ------------------------
    logic [4:0] rref3, rref2, rref1;

    rotor_reflector rotor_ref3 (
        .letter_in(reflector_out),
        .refl_type(rotor_type[2]),
        .letter_out(rref3)
    );

    rotor_reflector rotor_ref2 (
        .letter_in(rref3),
        .refl_type(rotor_type[1]),
        .letter_out(rref2)
    );

    rotor_reflector rotor_ref1 (
        .letter_in(rref2),
        .refl_type(rotor_type[0]),
        .letter_out(rref1)
    );

    // ------------------------
    // Plugboard (after)
    // ------------------------
    plugboard #(
        .DATA_WIDTH(5),
        .ALPHABET_SIZE(26)
    ) plugboard_inst2 (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(rref1),
        .cfg_in(plugboard_config),
        .set(set),
        .data_out(litera_out)
    );

endmodule
