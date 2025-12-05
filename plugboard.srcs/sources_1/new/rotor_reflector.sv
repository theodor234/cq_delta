module rotor_reflector (
    input  logic [4:0] letter_in,      // 0..25
    input  logic [1:0] refl_type,      // 00 -> A, 01 -> B, 10 -> C
    output logic [4:0] letter_out
);

    logic [4:0] wiring [0:25];

    always_comb begin
        case (refl_type)

            // ===============================
            // Reflector A
            // ===============================
            2'b00: begin
                wiring[ 0] = 5'd4;  // A <-> E
                wiring[ 1] = 5'd9;  // B <-> J
                wiring[ 2] = 5'd12; // C <-> M
                wiring[ 3] = 5'd25; // D <-> Z
                wiring[ 4] = 5'd0;  // E <-> A
                wiring[ 5] = 5'd11; // F <-> L
                wiring[ 6] = 5'd24; // G <-> Y
                wiring[ 7] = 5'd23; // H <-> X
                wiring[ 8] = 5'd21; // I <-> V
                wiring[ 9] = 5'd1;  // J <-> B
                wiring[10] = 5'd22; // K <-> W
                wiring[11] = 5'd5;  // L <-> F
                wiring[12] = 5'd2;  // M <-> C
                wiring[13] = 5'd17; // N <-> R
                wiring[14] = 5'd16; // O <-> Q
                wiring[15] = 5'd20; // P <-> U
                wiring[16] = 5'd14; // Q <-> O
                wiring[17] = 5'd13; // R <-> N
                wiring[18] = 5'd19; // S <-> T
                wiring[19] = 5'd18; // T <-> S
                wiring[20] = 5'd15; // U <-> P
                wiring[21] = 5'd8;  // V <-> I
                wiring[22] = 5'd10; // W <-> K
                wiring[23] = 5'd7;  // X <-> H
                wiring[24] = 5'd6;  // Y <-> G
                wiring[25] = 5'd3;  // Z <-> D
            end

            // ===============================
            // Reflector B (cel mai folosit)
            // ===============================
            2'b01: begin
                wiring[ 0] = 5'd24; // A <-> Y
                wiring[ 1] = 5'd17; // B <-> R
                wiring[ 2] = 5'd20; // C <-> U
                wiring[ 3] = 5'd7;  // D <-> H
                wiring[ 4] = 5'd16; // E <-> Q
                wiring[ 5] = 5'd18; // F <-> S
                wiring[ 6] = 5'd11; // G <-> L
                wiring[ 7] = 5'd3;  // H <-> D
                wiring[ 8] = 5'd15; // I <-> P
                wiring[ 9] = 5'd23; // J <-> X
                wiring[10] = 5'd13; // K <-> N
                wiring[11] = 5'd6;  // L <-> G
                wiring[12] = 5'd14; // M <-> O
                wiring[13] = 5'd10; // N <-> K
                wiring[14] = 5'd12; // O <-> M
                wiring[15] = 5'd8;  // P <-> I
                wiring[16] = 5'd4;  // Q <-> E
                wiring[17] = 5'd1;  // R <-> B
                wiring[18] = 5'd5;  // S <-> F
                wiring[19] = 5'd25; // T <-> Z
                wiring[20] = 5'd2;  // U <-> C
                wiring[21] = 5'd22; // V <-> W
                wiring[22] = 5'd21; // W <-> V
                wiring[23] = 5'd9;  // X <-> J
                wiring[24] = 5'd0;  // Y <-> A
                wiring[25] = 5'd19; // Z <-> T
            end

            // ===============================
            // Reflector C
            // ===============================
            2'b10: begin
                wiring[ 0] = 5'd5;  // A <-> F
                wiring[ 1] = 5'd21; // B <-> V
                wiring[ 2] = 5'd15; // C <-> P
                wiring[ 3] = 5'd9;  // D <-> J
                wiring[ 4] = 5'd8;  // E <-> I
                wiring[ 5] = 5'd0;  // F <-> A
                wiring[ 6] = 5'd14; // G <-> O
                wiring[ 7] = 5'd24; // H <-> Y
                wiring[ 8] = 5'd4;  // I <-> E
                wiring[ 9] = 5'd3;  // J <-> D
                wiring[10] = 5'd17; // K <-> R
                wiring[11] = 5'd25; // L <-> Z
                wiring[12] = 5'd23; // M <-> X
                wiring[13] = 5'd22; // N <-> W
                wiring[14] = 5'd6;  // O <-> G
                wiring[15] = 5'd2;  // P <-> C
                wiring[16] = 5'd19; // Q <-> T
                wiring[17] = 5'd10; // R <-> K
                wiring[18] = 5'd20; // S <-> U
                wiring[19] = 5'd16; // T <-> Q
                wiring[20] = 5'd18; // U <-> S
                wiring[21] = 5'd1;  // V <-> B
                wiring[22] = 5'd13; // W <-> N
                wiring[23] = 5'd12; // X <-> M
                wiring[24] = 5'd7;  // Y <-> H
                wiring[25] = 5'd11; // Z <-> L
            end

            default: begin
                wiring = '{default: 5'd0};
            end
        endcase
    end

    assign letter_out = wiring[letter_in];

endmodule