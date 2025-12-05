module tb_rotor_I;

    logic clk = 0;
    logic reset = 1;
    logic [4:0] letter_in;
    logic [4:0] starting_position;
    logic [4:0] letter_out;

   
    rotor_I dut (
        .clk(clk),
        .reset(reset),
        .letter_in(letter_in),
        .starting_position(starting_position),
        .letter_out(letter_out)
    );

   
    always #5 clk = ~clk;

    initial begin
       
        starting_position = 5'd0;

        
        #10 reset = 0;

        
        letter_in = 5'd18;
        

       
        letter_in = 5'd0;
        

        
        letter_in = 5'd1;
        
      
         #100 $finish;
    end

endmodule