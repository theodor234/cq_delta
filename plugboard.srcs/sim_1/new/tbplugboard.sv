
module tbplugboard;

    
    localparam DATA_WIDTH    = 5;
    localparam ALPHABET_SIZE = 26;

    logic clk;
    logic rst;

    logic mode;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    logic [DATA_WIDTH-1:0] cfg_in [ALPHABET_SIZE];
    logic cfg_valid;

    
    plugboard #(
        .DATA_WIDTH(DATA_WIDTH),
        .ALPHABET_SIZE(ALPHABET_SIZE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(data_in),
        .cfg_in(cfg_in),
        .cfg_valid(cfg_valid),
        .data_out(data_out)
    );

   
    always #5 clk = ~clk;   // 10ns perioada (100 MHz)

    
    // Procedura de test
   
    initial begin
        integer i;

        $display("=== TB PLUGBOARD START ===");

        // Init
        clk = 0;
        rst = 1;
        mode = 0;
        cfg_valid = 0;
        data_in = 0;

        #20;
        rst = 0;

       
        // CONFIGURARE PLUGBOARD
       
        for (i = 0; i < ALPHABET_SIZE; i++)
            cfg_in[i] = i[DATA_WIDTH-1:0];   

        cfg_in[0] = 5'd1;  // A -> B
        cfg_in[1] = 5'd0;  // B -> A
        cfg_in[2] = 5'd3;  // C -> D
        cfg_in[3] = 5'd2;  // D -> C

        mode = 0;  // remote config mode
        cfg_valid = 1;
        #10 cfg_valid = 0;

        $display("[TB] Configuratia plugboard a fost incarcata!");

        #20;

        
        // TEST OPERARE (mode = 1)
        
        mode = 1;

        // Test A
        data_in = 5'd0; #10;
        $display("A(0) -> %0d (asteptat 1)", data_out);

        // Test B
        data_in = 5'd1; #10;
        $display("B(1) -> %0d (asteptat 0)", data_out);

        // Test C
        data_in = 5'd2; #10;
        $display("C(2) -> %0d (asteptat 3)", data_out);

        // Test D
        data_in = 5'd3; #10;
        $display("D(3) -> %0d (asteptat 2)", data_out);

        // Test E (neschimbat)
        data_in = 5'd4; #10;
        $display("E(4) -> %0d (asteptat 4)", data_out);

        #50;

        $display("=== TB PLUGBOARD END ===");
        $finish;
    end

endmodule
