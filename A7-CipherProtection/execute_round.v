module execute_round (input [127:0] in, input [127:0] round_key, output wire [127:0] out);

    wire [127:0] sub_out, shift_out, mix_out;

    sub_bytes a1(.data_in(in), .data_out(sub_out));
    shift_rows a2(.in(sub_out), .out(shift_out));
    mix_column a3(.in(shift_out), .out(mix_out));

    assign out = mix_out ^ round_key;

endmodule