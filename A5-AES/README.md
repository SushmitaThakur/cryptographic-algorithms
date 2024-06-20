This is full clocked implementation of aes that executes 10 rounds of algorithm with 128 bits plaintext, key and ciphertext. The folder contains full implementation modules of AES, a testbench and the yosys script file.

### Part 1
## Without clock implementation -
The control module: aes_no_clk.v 
Testbench: tb_aes_no_clk.v

For Test-case: 
plaintext = 11111111111111111111111111111111, 
key = 3c4fcf098815f7aba5d2ae2816157e2b, 
ciphertext = a13c4dcf3859ff78076bda87fc1856b5

### Part 2
## With clock implementation - 

The control module: aes.v 
Testbench: tb_aes.v

For Test-case: 
plaintext = 128'h11111111111111111111111111111111;
key = 128'h3C4FCF098815F7ABA5D2AE2816157E2B;
Expected Ciphertext: a13c4dcf3859ff78076bda87fc1856b5 

Upon execution the ciphertext output are -
ciphertext = 00000000000000000000000000000000
ciphertext = a13c4dcf3859ff78076bda87fc1856b5
ciphertext = 00000000000000000000000000000000

One of the output is the expected which round 10 of the execution and for other rounds ciphertext is 0 as specified in aes.v.

### Part 3
## Area without clock

Chip area for top module '\aes': 104144.320000 μm^2
cell (NAND2_X1) area : 0.798000

Number of GE = Total Occupied Chip Area / Area of a Single NAND2_X1 Gate
Number of GE = 104144.320000 μm^2 / 0.798000 μm^2 
Number of GE = 130506.66 μm^2


## Area with clock
Chip area for top module '\aes': 40733.910000
GE = (40733.910000 / 0.798000) = 51000.52 μm^2


## ------------------------ Full steps for execution--------------------------------------------

## Compile - 

# without clk - 
iverilog tb_aes_no_clk.v aes_no_clk.v generate_key.v execute_round.v execute_last_round.v mix_column.v sbox.v shift_rows.v sub_bytes.v
# with clk - 
iverilog tb_aes.v aes.v generate_key.v execute_round.v execute_last_round.v mix_column.v sbox.v shift_rows.v sub_bytes.v
 
## Run -
vvp a.out

## Wave - 
gtkwave tb_aes_waves.vcd

## Synthesis with Yosys - 

# short way:
    yosys aes_yosys.tcl

# long way:
1. read -sv aes.v generate_key.v sbox.v sub_bytes.v shift_rows.v mix_column.v execute_round.v execute_last_round.v 
2. synth -top aes
3. dfflibmap -liberty stdcells.lib
4. abc -liberty stdcells.lib
(use ABC for technology mapping)
5. clean 
(removes unused wires)
6. stat -liberty stdcells.lib
(gives the total occupied chip area in μm^2)
7. write_verilog aes_mapped.v
(saves the synthesyzed netlist to aes_mapped.v)

## Gate-level simulation
iverilog stdcells.v aes_mapped.v
