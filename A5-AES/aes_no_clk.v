`timescale 1 ns / 10 ps

module aes_no_clk ( 
    input wire [127:0] plaintext_in,
    input wire [127:0] key_in,
    output wire [127:0] ciphertext_out);

    // Initialise temporary storage for round keys
    wire [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10;

    // Initialise temporary storage for the output cipher in each round
    wire [127:0] r0_out, r1_out, r2_out, r3_out, r4_out, r5_out, r6_out, r7_out, r8_out, r9_out, r10_out;

    // output from each round is the input text for next round 
    assign r0_out = plaintext_in ^ key_in;

    // pre-generate all the round keys (each 128 bits)
    generate_key a0( .key_in(key_in), .key1(key1), .key2(key2), .key3(key3), .key4(key4), .key5(key5), .key6(key6), .key7(key7), .key8(key8), .key9(key9), .key10(key10));

    // Execute the first 9 rounds
    // Format - execute_round( clock, input, key, output )
    execute_round r1( .in(r0_out), .round_key(key1), .out(r1_out) );
    execute_round r2( .in(r1_out), .round_key(key2), .out(r2_out) );
    execute_round r3( .in(r2_out), .round_key(key3), .out(r3_out) );
    execute_round r4( .in(r3_out), .round_key(key4), .out(r4_out) );
    execute_round r5( .in(r4_out), .round_key(key5), .out(r5_out) );
    execute_round r6( .in(r5_out), .round_key(key6), .out(r6_out) );
    execute_round r7( .in(r6_out), .round_key(key7), .out(r7_out) );
    execute_round r8( .in(r7_out), .round_key(key8), .out(r8_out) );
    execute_round r9( .in(r8_out), .round_key(key9), .out(r9_out) );

    // last (10th) round
    execute_last_round r10(.in(r9_out), .round_key(key10), .out(r10_out));

    assign ciphertext_out = r10_out;

endmodule