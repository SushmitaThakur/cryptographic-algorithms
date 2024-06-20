This is implementation of aes with Dual Mode spatial redundancy (DMR) with parity check that executes 10 rounds of algorithm with 128 bits plaintext, key and ciphertext for two instances. 

Dual Modular Redundancy (DMR): In DMR, two identical modules are used to execute the same task, and the output of each module is compared to detect errors. If an error occurs in one module, the output of the other module is used as the correct output. DMR provides a higher level of redundancy than a single module and can detect and correct single errors.

In this implementation, three identical instances of aes are executed and the output of the first two instances are XORed to check parity, if the parity is 0 then the output is the ciphertext from these instances otherwise the output from the third instance is given as final ciphertext.

The folder contains implementation modules of AES, a testbench, a redundancy module and the yosys script file and gtkwave file.

## Implementation -
Redundancy module - aes_redundancy.v 
Control module: aes.v 
Testbench: tb_aes.v

For Test-case: 
plaintext = 11111111111111111111111111111111, 
key = 3c4fcf098815f7aba5d2ae2816157e2b, 
ciphertext = a13c4dcf3859ff78076bda87fc1856b5

### Execution steps - 
# Compile - 

iverilog tb_aes.v aes_redundancy.v aes.v generate_key.v execute_round.v execute_last_round.v mix_column.v sbox.v shift_rows.v sub_bytes.v

# Run - 
vvp a.out