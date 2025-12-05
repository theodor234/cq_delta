// ukw_b.v
// Reflector UKW B for Enigma (combinational)
// Maps 0..25 (A..Z) according to "AY BR CU DH EQ FS GL IP JX KN MO TZ VW"

module ukw_b (
    input  logic       clk,   // ADDED: clock input
    input  logic [4:0] in,    // 0..25 -> A..Z
    output logic [4:0] out
);

    logic [4:0] out_next;

    // combinational map (same functionality, comments preserved)
    always_comb begin
        case (in)
            5'd0:  out_next = 5'd24; // A -> Y
            5'd1:  out_next = 5'd17; // B -> R
            5'd2:  out_next = 5'd20; // C -> U
            5'd3:  out_next = 5'd7;  // D -> H
            5'd4:  out_next = 5'd16; // E -> Q
            5'd5:  out_next = 5'd18; // F -> S
            5'd6:  out_next = 5'd11; // G -> L
            5'd7:  out_next = 5'd3;  // H -> D
            5'd8:  out_next = 5'd15; // I -> P
            5'd9:  out_next = 5'd23; // J -> X
            5'd10: out_next = 5'd13; // K -> N
            5'd11: out_next = 5'd6;  // L -> G
            5'd12: out_next = 5'd14; // M -> O
            5'd13: out_next = 5'd10; // N -> K
            5'd14: out_next = 5'd12; // O -> M
            5'd15: out_next = 5'd8;  // P -> I
            5'd16: out_next = 5'd4;  // Q -> E
            5'd17: out_next = 5'd1;  // R -> B
            5'd18: out_next = 5'd5;  // S -> F
            5'd19: out_next = 5'd25; // T -> Z
            5'd20: out_next = 5'd2;  // U -> C
            5'd21: out_next = 5'd22; // V -> W
            5'd22: out_next = 5'd21; // W -> V
            5'd23: out_next = 5'd9;  // X -> J
            5'd24: out_next = 5'd0;  // Y -> A
            5'd25: out_next = 5'd19; // Z -> T
            default: out_next = in;  // passthrough pentru valori >25 (nu folosit)
        endcase
    end

    // synchronous output register
    always_ff @(posedge clk) begin
        out <= out_next;
    end

endmodule
