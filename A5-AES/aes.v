module aes (    
    input wire clk,
    input wire rst_n,
    input wire [127:0] plaintext_in,
    input wire [127:0] key_in,
    output wire [127:0] ciphertext_out);

    // Initialise temporary storage for round keys
    wire [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10;
    reg [3:0] round_counter; 
    reg [127:0] r_in, r_rk_in, r_out_reg, last_r_out_reg;
    wire [127:0] r_out, final_out;


    // pre-generate all the round keys (each 128 bits)
    generate_key a0( .key_in(key_in), .key1(key1), .key2(key2), .key3(key3), .key4(key4), .key5(key5), .key6(key6), .key7(key7), .key8(key8), .key9(key9), .key10(key10));

    // execute round 1 to 9 with mix column
    execute_round r( .in(r_in), .round_key(r_rk_in), .out(r_out) );
    // execute round 10 without mix column
    execute_last_round rl(.in(r_in), .round_key(r_rk_in), .out(final_out));

    // update round key after each round
    always @ * begin

        r_rk_in = key1;
        if (round_counter == 4'd1)
            r_rk_in = key2;
        else if (round_counter == 4'd2)
            r_rk_in = key3;
        else if (round_counter == 4'd3)
            r_rk_in = key4;
        else if (round_counter == 4'd4)
            r_rk_in = key5;
        else if (round_counter == 4'd5)
            r_rk_in = key6;
        else if (round_counter == 4'd6)
            r_rk_in = key7;
        else if (round_counter == 4'd7)
            r_rk_in = key8;
        else if (round_counter == 4'd8)
            r_rk_in = key9;
        else if (round_counter == 4'd9)
            r_rk_in = key10;

    end

    // update round counter after each round
    always @ (posedge clk) begin
        if(!rst_n) 
            round_counter <= 4'd0;
        else if (round_counter < 4'd10)
            round_counter <= round_counter + 1;
        else 
            round_counter <= 4'd10;
    end

    // update the input 
    always @ * begin
        r_in = plaintext_in ^ key_in;

        if (round_counter != 4'd0)
            r_in = r_out_reg;
    end

    // store the output after each round in an output register
    always @ (posedge clk) begin
        if (!rst_n)
            r_out_reg <= 0;
        else
            r_out_reg <= r_out;
    end

    // store the output of the last round in a register
    always @ (posedge clk) begin
        if (!rst_n)
            last_r_out_reg <= 0;
        else
            last_r_out_reg <= final_out;
    end

    // if it is the last round, store the ciphertext 
    assign ciphertext_out = (round_counter == 4'd10) ? last_r_out_reg  : 0;

endmodule