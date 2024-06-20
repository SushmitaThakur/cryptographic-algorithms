yosys read -sv aes.v generate_key.v sbox.v sub_bytes.v shift_rows.v mix_column.v execute_round.v execute_last_round.v
yosys synth -top aes
yosys dfflibmap -liberty stdcells.lib
yosys abc -liberty stdcells.lib
yosys clean
yosys stat -liberty stdcells.lib
yosys write_verilog aes_mapped.v
