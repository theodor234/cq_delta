module rotor_III (
    input  logic        clk,
    input  logic        reset,
    input  logic        step,               // avansare la liter? nou?
    input  logic        notch_in,           // semnal de la rotorul precedent care determin? rotirea
    input  logic [4:0]  letter_in,          // litera intrare (0..25)
    input  logic [4:0]  starting_position,  // pozi?ia ini?ial? rotor
    input  logic [1:0]  rotor_type,         // 00->Rotor I, 01->Rotor II, 10->Rotor III
    output logic [4:0]  letter_out       // litera ie?ire (0..25)
    
);
// pozi?ia curent? a rotorului
    logic [4:0] position;

    // tabel wiring ?i notch
    logic [4:0] wiring [0:25];
    logic [4:0] notch_pos;

    // setare wiring + notch în func?ie de tipul rotorului
    always_comb begin
        case(rotor_type)
            2'b00: begin // Rotor I
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
        notch_pos = 5'd16; // Q

            end
            2'b01: begin // Rotor II
                 wiring[ 0] = 5'd0;  // A -> A 
    wiring[ 1] = 5'd9;  // B -> J
    wiring[ 2] = 5'd3;  // C -> D
    wiring[ 3] = 5'd10; // D -> K
    wiring[ 4] = 5'd18; // E -> S
    wiring[ 5] = 5'd8;  // F -> I
    wiring[ 6] = 5'd17; // G -> R
    wiring[ 7] = 5'd20; // H -> U
    wiring[ 8] = 5'd23; // I -> X
    wiring[ 9] = 5'd1;  // J -> B
    wiring[10] = 5'd11; // K -> L
    wiring[11] = 5'd7;  // L -> H
    wiring[12] = 5'd22; // M -> W
    wiring[13] = 5'd19; // N -> T
    wiring[14] = 5'd12; // O -> M
    wiring[15] = 5'd2;  // P -> C
    wiring[16] = 5'd16; // Q -> Q
    wiring[17] = 5'd6;  // R -> G
    wiring[18] = 5'd25; // S -> Z
    wiring[19] = 5'd13; // T -> N
    wiring[20] = 5'd15; // U -> P
    wiring[21] = 5'd24; // V -> Y
    wiring[22] = 5'd5;  // W -> F
    wiring[23] = 5'd21; // X -> V
    wiring[24] = 5'd14; // Y -> O
    wiring[25] = 5'd4;  // Z -> E
    notch_pos = 5'd4;  // E

            end
            2'b10: begin // Rotor III
                wiring[ 0] = 5'd1;  // A -> B 
    wiring[ 1] = 5'd3;  // B -> D
    wiring[ 2] = 5'd5;  // C -> F
    wiring[ 3] = 5'd7;  // D -> H
    wiring[ 4] = 5'd9;  // E -> J
    wiring[ 5] = 5'd11; // F -> L
    wiring[ 6] = 5'd2;  // G -> C
    wiring[ 7] = 5'd15; // H -> P
    wiring[ 8] = 5'd17; // I -> R
    wiring[ 9] = 5'd19; // J -> T
    wiring[10] = 5'd23; // K -> X
    wiring[11] = 5'd21; // L -> V
    wiring[12] = 5'd25; // M -> Z
    wiring[13] = 5'd13; // N -> N
    wiring[14] = 5'd24; // O -> Y
    wiring[15] = 5'd4;  // P -> E
    wiring[16] = 5'd8;  // Q -> I
    wiring[17] = 5'd22; // R -> W
    wiring[18] = 5'd6;  // S -> G
    wiring[19] = 5'd0;  // T -> A
    wiring[20] = 5'd10; // U -> K
    wiring[21] = 5'd12; // V -> M
    wiring[22] = 5'd20; // W -> U
    wiring[23] = 5'd18; // X -> S
    wiring[24] = 5'd16; // Y -> Q
    wiring[25] = 5'd14; // Z -> O
    notch_pos = 5'd21; // V

            end
            default: begin
                wiring = '{default:5'd0};
                notch_pos = 5'd0;
            end
        endcase
    end

always_ff @(posedge clk or posedge reset) begin
    if (reset)
        position <= starting_position;
    else if (step && notch_in)  
        position <= (position + 1) % 26;
end

logic [4:0] shifted_in;
    logic [4:0] shifted_out;

    always_comb begin
        shifted_in  = (letter_in + position) % 26;
        shifted_out = wiring[shifted_in];
        letter_out  = (shifted_out + 26 - position) % 26;
    end

endmodule