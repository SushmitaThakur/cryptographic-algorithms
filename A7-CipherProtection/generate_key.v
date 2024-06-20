module generate_key(input [127:0] key_in, output wire [127:0] key1, key2, key3, key4, key5, key6, key7, key8, key9, key10);

    wire [31:0] rc1, rc2, rc3, rc4, rc5, rc6, rc7, rc8, rc9, rc10;

	assign rc1 =  32'h01000000;
	assign rc2 =  32'h02000000; 
	assign rc3 =  32'h04000000;
	assign rc4 =  32'h08000000;
	assign rc5 =  32'h10000000;
	assign rc6 =  32'h20000000;
	assign rc7 =  32'h40000000;
	assign rc8 =  32'h80000000;
	assign rc9 =  32'h1b000000;
	assign rc10 = 32'h36000000;

    compute_round_key c1( .r_const(rc1), .key(key_in), .round_key(key1));
    compute_round_key c2( .r_const(rc2), .key(key1), .round_key(key2));
    compute_round_key c3( .r_const(rc3), .key(key2), .round_key(key3));
    compute_round_key c4( .r_const(rc4), .key(key3), .round_key(key4));
    compute_round_key c5( .r_const(rc5), .key(key4), .round_key(key5));
    compute_round_key c6( .r_const(rc6), .key(key5), .round_key(key6));
    compute_round_key c7( .r_const(rc7), .key(key6), .round_key(key7));
    compute_round_key c8( .r_const(rc8), .key(key7), .round_key(key8));
    compute_round_key c9( .r_const(rc9), .key(key8), .round_key(key9));
    compute_round_key c10( .r_const(rc10), .key(key9), .round_key(key10));    

endmodule

module compute_round_key(input [31:0] r_const, input [127:0] key, output wire [127:0] round_key);

wire [31:0] w0, w1, w2, w3, r_const, rotate_out, sbox_out, xor_out;
wire [7:0] top, bottom, subword0, subword1, subword2, subword3;
wire [31:0] new_key0, new_key1, new_key2, new_key3;
    
	assign w0 = key[127:96];
	assign w1 = key[95:64];
	assign w2 = key[63:32];
	assign w3 = key[31:0];

    // rotate
    // w3 = ab cd ef 12 -> cd ef 12 ab -> bit [31:24 23:16 15:8 7:0] -> rotate =  [23:16 15:8 7:0 31:24]
    assign rotate_out = {w3[23:0], w3[31:24]};

    // sbox - 8bits input/output
    sbox s0(.byte_in(rotate_out[31:24]), .byte_out(subword0));
    sbox s1(.byte_in(rotate_out[23:16]), .byte_out(subword1));
    sbox s2(.byte_in(rotate_out[15:8]), .byte_out(subword2));
    sbox s3(.byte_in(rotate_out[7:0]), .byte_out(subword3));

    assign sbox_out = { subword0, subword1, subword2, subword3 };

    // xor with round constant
    assign xor_out = sbox_out ^ r_const;

    assign new_key0 = w0 ^ xor_out;
    assign new_key1 = new_key0 ^ w1;
    assign new_key2 = new_key1 ^ w2;
    assign new_key3 = new_key2 ^ w3;

    // return the round key
    assign round_key = {new_key0, new_key1, new_key2, new_key3};
endmodule