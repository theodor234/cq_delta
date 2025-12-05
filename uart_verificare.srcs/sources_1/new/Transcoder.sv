module HEX_Decoder (
    input [7:0] ascii_code, 
    output [6:0] segment_out 
);

    

    reg [6:0] segment_pattern;

    always @(*) begin
        case (ascii_code)
           
            
            // 0x41
            8'h41: segment_pattern = 7'b1110111; // 'A'
           
            // 0x43
            8'h43: segment_pattern = 7'b1001110; // 'C' (majuscula)
            
            // 0x45
            8'h45: segment_pattern = 7'b1111001; // 'E'
            // 0x46
            8'h46: segment_pattern = 7'b1110001; // 'F'
            
            // 0x48
            8'h48: segment_pattern = 7'b0110111; // 'H'
            // 0x49
            8'h49: segment_pattern = 7'b0000110; // 'I' (doar c si b)
            // 0x4A
            8'h4A: segment_pattern = 7'b0011110; // 'J'
            // 0x4B
            8'h4B: segment_pattern = 7'b1110101; // 'K' (Reprezentare 'E' sau 'K' stilizat)
            // 0x4C
            8'h4C: segment_pattern = 7'b0001110; // 'L'
            // 0x4D
            8'h4D: segment_pattern = 7'b1000100; // 'M' (Reprezentare 'r' sau 'M' simplificat)
            // 0x4E
            
            // 0x50
            8'h50: segment_pattern = 7'b1110011; // 'P'
            // 0x51
           
            // 0x53
            8'h53: segment_pattern = 7'b1101011; // 'S'
           
            // 0x55
            8'h55: segment_pattern = 7'b0011100; // 'U' (majuscula)
            // 0x56
            8'h56: segment_pattern = 7'b0011100; // 'V' (Reprezentare 'U' sau 'u')
            // 0x57
            8'h57: segment_pattern = 7'b0010100; // 'W' (Reprezentare 'u' simplificat)
            // 0x58
            8'h58: segment_pattern = 7'b1000000; // 'X' (Reprezentare 'r' sau 'o' simplificat)
            // 0x59
            8'h59: segment_pattern = 7'b1101111; // 'Y'
            // 0x5A
            8'h5A: segment_pattern = 7'b1101001; // 'Z' (Reprezentare 'E' sau 'C' simplificat)

            // Daca se primeste altceva (cifra, simbol, litera mica, sau 'A' apasat pe tastatura dar transmis 'a' ASCII):
            default: segment_pattern = 7'b0000000; // Stinge tot (Off)
        endcase
    end
    
    assign segment_out = segment_pattern;

endmodule