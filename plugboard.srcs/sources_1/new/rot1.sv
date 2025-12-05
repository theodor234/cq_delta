module rotor_I (
    input  logic        clk,
    input  logic        reset,
    input  logic        step,
    input  logic [4:0]  letter_in,          // litera intrare (0..25)
    input  logic [4:0]  starting_position,  // pozitia initiala rotor
    output logic [4:0]  letter_out          // litera iesire (0..25)
);

    // registru pentru pozi?ia curent?
    logic [4:0] position;

    // tabel wiring Rotor I (forward direction)
    logic [4:0] wiring [0:25];

    // ini?ializare wiring
    initial begin
        // E K M F L G D Q V Z N T O W Y H X U S P A I B R C J
        wiring[ 0] = 4'd4;  // A -> E 
        wiring[ 1] = 4'd10; // B -> K
        wiring[ 2] = 4'd12; // C -> M
        wiring[ 3] = 4'd5;  // D -> F
        wiring[ 4] = 4'd11; // E -> L
        wiring[ 5] = 4'd6;  // F -> G
        wiring[ 6] = 4'd3;  // G -> D
        wiring[ 7] = 4'd16; // H -> Q
        wiring[ 8] = 4'd21; // I -> V
        wiring[ 9] = 4'd25; // J -> Z
        wiring[10] = 4'd13; // K -> N
        wiring[11] = 4'd19; // L -> T
        wiring[12] = 4'd14; // M -> O
        wiring[13] = 4'd22; // N -> W
        wiring[14] = 4'd24; // O -> Y
        wiring[15] = 4'd7;  // P -> H
        wiring[16] = 4'd23; // Q -> X
        wiring[17] = 4'd20; // R -> U
        wiring[18] = 4'd18; // S -> S
        wiring[19] = 4'd15; // T -> P
        wiring[20] = 4'd0;  // U -> A
        wiring[21] = 4'd8;  // V -> I
        wiring[22] = 4'd1;  // W -> B
        wiring[23] = 4'd17; // X -> R
        wiring[24] = 4'd2;  // Y -> C
        wiring[25] = 4'd9;  // Z -> J
    end

    // actualizare pozi?ie: DOAR când step=1
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            position <= starting_position;
        else if (step)
            position <= (position + 1) % 26;
    end


    // logic? transformare forward
    logic [4:0] shifted_in;
    logic [4:0] shifted_out;

    // aplic? offset-ul rotorului
    always_comb begin
        shifted_in  = (letter_in + position) % 26;
        shifted_out = wiring[shifted_in];
        letter_out  = (shifted_out + 26 - position) % 26;
    end

endmodule