// Mix clolumn is peformed by calculating the polynomial eqautions on each 32bit row
module mix_column(input [127:0] in, output wire [127:0] out);
   
    wire [31:0] col1, col2, col3, col4;
    wire [31:0] out1, out2, out3, out4;

    assign col1 = in[127:96];
    assign col2 = in[95:64];
    assign col3 = in[63:32];
    assign col4 = in[31:0];

    // perform multiplication on each row (32bits each) 
    compute_polynomial_32 p1(.in(col1), .out(out1));
    compute_polynomial_32 p2(.in(col2), .out(out2));
    compute_polynomial_32 p3(.in(col3), .out(out3));
    compute_polynomial_32 p4(.in(col4), .out(out4));

    assign out = { out1, out2, out3, out4 };

endmodule

// Procedure: Return the multiplication for 32 bits
module compute_polynomial_32(input [31:0] in, output wire [31:0] out);

    wire [7:0] temp1, temp2, temp3, temp4;
    // temporary storage for polynomial eqautions
    wire [7:0] a0, a1, a2, a3;

    // temporary storage for multiplication results on rows
    wire [7:0] m2_out1, m2_out2, m2_out3, m2_out4;
    wire [7:0] m3_out1, m3_out2, m3_out3, m3_out4;

    assign temp1 = in[31:24];
    assign temp2 = in[23:16];
    assign temp3 = in[15:8];
    assign temp4 = in[7:0];

    multiply_by_2 m1( .m_in(temp1), .m_out(m2_out1) );
    multiply_by_2 m2( .m_in(temp2), .m_out(m2_out2) );
    multiply_by_2 m3( .m_in(temp3), .m_out(m2_out3) );
    multiply_by_2 m4( .m_in(temp4), .m_out(m2_out4) );

    multiply_by_3 m5( .m_in(temp1), .m_out(m3_out1) );
    multiply_by_3 m6( .m_in(temp2), .m_out(m3_out2) );
    multiply_by_3 m7( .m_in(temp3), .m_out(m3_out3) );
    multiply_by_3 m8( .m_in(temp4), .m_out(m3_out4) );

    // Mix column matrix  => Polynomial Eqautions
    // a0 = [02 03 01 01] => (2 * s1) ^ (3 * s2) ^ s3 ^ s4
    // a1 = [01 02 03 01] => s5 ^ (2 * s6) ^ (3 * s7) ^ s8
    // a2 = [01 01 02 03] => s9 ^ s10 ^ (2 * s11) ^ (3 * s12)
    // a3 = [03 01 01 02] => (3 * s13) ^ s14 ^ s15 ^ (2 * s16)

    assign a0 = m2_out1 ^ m3_out2 ^ temp3 ^ temp4;
    assign a1 = temp1 ^ m2_out2 ^ m3_out3 ^ temp4;
    assign a2 = temp1 ^ temp2 ^ m2_out3 ^ m3_out4;
    assign a3 = m3_out1 ^ temp2 ^ temp3 ^ m2_out4;

    assign out = {a0, a1, a2, a3};

endmodule

// Procedure: multiply 8 bit word by 2
module multiply_by_2( input [7:0] m_in, output wire [7:0] m_out);

    assign m_out = { m_in[6:0],1'b0} ^ (8'h1b & {8{m_in[7]}});

endmodule

// Procedure: multiply 8 bit word by 3 
module multiply_by_3(input [7:0] m_in, output wire [7:0] m_out);

    wire [7:0] temp;

    multiply_by_2 m1(.m_in(m_in), .m_out(temp));
    assign m_out = m_in ^ temp;

endmodule