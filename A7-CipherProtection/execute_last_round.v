module execute_last_round(input [127:0] in, input [127:0] round_key, output wire [127:0] out);

    wire [127:0] sub_out, shift_out;

    sub_bytes s1(.data_in(in), .data_out(sub_out));
    shift_rows s2(.in(sub_out), .out(shift_out));
    // Last round does not need mix_column

    assign out = shift_out ^ round_key;
    
endmodule