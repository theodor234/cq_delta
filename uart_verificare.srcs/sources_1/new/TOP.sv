module Top_Module (
  
    input CLK_100Mhz,   
    input RST_BTN,      
    input RX_PIN,      
    
  
    output [6:0] SEGMENTS 
);

    // Semnale Interne (Wires)
    wire [7:0] received_ascii_data; // Datele ASCII primite de la UART
    wire data_ready_flag;           // Semnal valid trimis de UART_RX
    wire [6:0] display_segments_logic; // Iesirea logica din decodor (inainte de a fi mapata la pin)


   // 1. INSTANTIEREA MODULULUI UART_RX

    UART_RX rx_unit (
        .clk(CLK_100Mhz),
        .reset(RST_BTN),
        .RXD(RX_PIN),
        .data_out(received_ascii_data),
        .data_valid(data_ready_flag)
    );


    // 2. INSTANTIEREA MODULULUI HEX_DECODER
   
    
    HEX_Decoder decoder_unit (
        
        .ascii_code(received_ascii_data), 
        .segment_out(display_segments_logic)
    );


    // 3. MAPAREA IESIRII LOGICE LA PINII FIZICI
  
    assign SEGMENTS = display_segments_logic;
    
   
    

endmodule