module plugboard #(
    parameter DATA_WIDTH = 5,
    parameter ALPHABET_SIZE = 26
)(
    input  logic                     clk,
    input  logic                     rst,

    input  logic                     mode,
    input  logic [DATA_WIDTH-1:0]    data_in,
    input  logic [DATA_WIDTH-1:0]    cfg_in        [ALPHABET_SIZE],
    input  logic                     set,

    output logic [DATA_WIDTH-1:0]    data_out
);

    logic [DATA_WIDTH-1:0] plug_map [ALPHABET_SIZE];

    // NUMAR MAXIM DE 10 PERMUTARI
    logic [4:0] pair_count; // *** AD?UGAT: contor pentru maxim 10 perechi ***

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            integer i;
            for (i = 0; i < ALPHABET_SIZE; i++)
                plug_map[i] <= i[DATA_WIDTH-1:0];
            pair_count <= 0; // *** AD?UGAT: reset contor ***
        end
        else if (mode == 1'b0 && set && pair_count < 10) begin
            integer j;
            for (j = 0; j < ALPHABET_SIZE; j++)
                plug_map[j] <= cfg_in[j];
            pair_count <= pair_count + 1; // *** AD?UGAT: incrementeaz? pe fiecare configurare ***
        end
    end

    always_comb begin
        if (mode == 1'b1)
            data_out = plug_map[data_in];
        else
            data_out = data_in;
    end

endmodule


