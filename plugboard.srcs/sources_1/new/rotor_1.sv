module rotor1 #(
    parameter DATA_WIDTH    = 5,        // 5 biti pt codare A-Z
    parameter ALPHABET_SIZE = 26
)(
    input  logic [DATA_WIDTH-1:0] data_in,      // litera intrata din plugboard (0-25)
    input  logic [DATA_WIDTH-1:0] rot_pos,      // pozitia rotorului (0-25) = offset
    output logic [DATA_WIDTH-1:0] data_out      // litera iesita dupa rotor
);

    // ----------------------------
    // Wiring-ul clasic pentru Rotor I
    // E K M F L G D Q V Z N T O W Y H X U S P A I B R C J
    // Indicii: A=0, B=1, ...
    // ----------------------------
    localparam logic [DATA_WIDTH-1:0] wirings [0:ALPHABET_SIZE-1] = '{
        4, 10, 12, 5, 11, 6, 3, 16, 21, 25,
        13, 19, 14, 22, 24, 7, 23, 20, 18, 15,
        0, 8, 1, 17, 2, 9
    };

    logic [DATA_WIDTH-1:0] shifted_in;
    logic [DATA_WIDTH-1:0] wired_out;

    // Aplic?m offset circular
    assign shifted_in = (data_in + rot_pos) % ALPHABET_SIZE;

    // Trecerea prin rotor (lookup)
    assign wired_out = wirings[shifted_in];

    // Scoatem offsetul
    assign data_out = (wired_out + ALPHABET_SIZE - rot_pos) % ALPHABET_SIZE;

endmodule
