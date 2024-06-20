module sub_bytes( input [127:0] data_in, output wire [127:0] data_out);

    wire [127:0] temp;

    // Each call to sbox module is replacing 8 bits in the 'in'
    // Row 0 - Least signifcant bits of 'in'
    sbox s0(.byte_in(data_in[7:0]), .byte_out(temp[7:0]));
    sbox s1(.byte_in(data_in[15:8]), .byte_out(temp[15:8])); 
    sbox s2(.byte_in(data_in[23:16]), .byte_out(temp[23:16]));
    sbox s3(.byte_in(data_in[31:24]), .byte_out(temp[31:24]));

    // Row 1  
    sbox s4(.byte_in(data_in[39:32]), .byte_out(temp[39:32]));
    sbox s5(.byte_in(data_in[47:40]), .byte_out(temp[47:40]));
    sbox s6(.byte_in(data_in[55:48]), .byte_out(temp[55:48]));
    sbox s7(.byte_in(data_in[63:56]), .byte_out(temp[63:56]));

     // Row 2data 
    sbox s8(.byte_in(data_in[71:64]), .byte_out(temp[71:64]));
    sbox s9(.byte_in(data_in[79:72]), .byte_out(temp[79:72]));
    sbox s10(.byte_in(data_in[87:80]), .byte_out(temp[87:80]));
    sbox s11(.byte_in(data_in[95:88]), .byte_out(temp[95:88]));

    // Row 3 - Most significant bits of 'in'
    sbox s12(.byte_in(data_in[103:96]), .byte_out(temp[103:96]));
    sbox s13(.byte_in(data_in[111:104]), .byte_out(temp[111:104]));   
    sbox s14(.byte_in(data_in[119:112]), .byte_out(temp[119:112]));
    sbox s15(.byte_in(data_in[127:120]), .byte_out(temp[127:120]));
	  
    assign data_out = temp;

	// always@(posedge clk)
	// begin
	//  byte_out <= temp;
	// end

endmodule