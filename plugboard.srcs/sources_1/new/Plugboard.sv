module plugboard #(
    parameter DATA_WIDTH = 5,        // litere A-Z codate pe 5 bit
    parameter ALPHABET_SIZE = 26
)(
    input  logic                     clk,
    input  logic                     rst,

    input  logic                     mode,         // 0 = remote-config , 1 = direct encoding
    input  logic [DATA_WIDTH-1:0]    data_in,      
    input  logic [DATA_WIDTH-1:0]    cfg_in        [ALPHABET_SIZE],  
    input  logic                     cfg_valid,    

    output logic [DATA_WIDTH-1:0]    data_out
);

    // tabel de mapare intern (plugboard)
    logic [DATA_WIDTH-1:0] plug_map [ALPHABET_SIZE];

    
    // când mode = 0  cfg_valid = 1 incarc noua configuratie
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // identitate implicit?: A->A, B->B,
            integer i;
            for (i = 0; i < ALPHABET_SIZE; i++)
                plug_map[i] <= i[DATA_WIDTH-1:0];
        end
        else if (mode == 1'b0 && cfg_valid) begin
            integer j;
            for (j = 0; j < ALPHABET_SIZE; j++)
                plug_map[j] <= cfg_in[j];
        end
    end

    // --- MODUL DE OPERARE ---
    // când mode = 1, se aplic? maparea
    always_comb begin
        if (mode == 1'b1)
            data_out = plug_map[data_in];
        else
            data_out = data_in; // în modul config, trecem datele direct
    end

endmodule

