module shift_rows(input [127:0] in, output wire [127:0] out);
	
	// before shift
	// row 0 (bytes 0, 4, 8, 12) is unchanged
	// row 1 (bytes 1, 5, 9, 13) is shifted by 1 byte
	// row 2 (bytes 2, 6, 10, 14) is shifted by 2 bytes
	// row 3 (bytes 3, 7, 11, 15) is shifted by 3 bytes

	// bytes = [127....................................0] 
	// in = [col1 | col2 | col3 | col4 ]
	// in = 0 1 2 3 | 4 5 6 7 | 8 9 10 11 | 12 13 14 15 |
	
	// row 0 (bytes 0, 4, 8, 12) is unchanged
	assign out[127:120] =  in[127:120];
	assign out[95:88] = in[95:88];
	assign out[63:56] = in[63:56];
	assign out[31:24] = in[31:24];

	// row 1 (bytes 1, 5, 9, 13) is shifted by 1 byte
	assign out[119:112] = in[87:80];
	assign out[87:80] = in[55:48];
	assign out[55:48] = in[23:16];
	assign out[23:16] = in[119:112];

	// row 2 (bytes 2, 6, 10, 14) is shifted by 2 bytes
	assign out[111:104] = in[47:40];
	assign out[79:72] = in[15:8];
	assign out[47:40] = in[111:104];
	assign out[15:8] = in[79:72];

	// row 3 (bytes 3, 7, 11, 15) is shifted by 3 bytes
	assign out[103:96] = in[7:0];
	assign out[71:64] = in[103:96];
	assign out[39:32] = in[71:64];
	assign out[7:0] = in[39:32];

	// after shift
	// row 0 (bytes 0, 4, 8, 12) 
	// row 1 (bytes 5, 9, 13, 1) 
	// row 2 (bytes 10, 14, 2, 6) 
	// row 3 (bytes 15, 3, 7, 11) 

	// bytes = [127....................................0] 
	// out = [ col1 | col2 | col3 | col4 ]
	// out = 0 5 10 15 | 4 9 14 3 | 8 13 2 7 | 12 1 6 11 |

endmodule