# Description:
For this assembly implementation of PRESENT (merged SP), all the keys are generated first using highlevel C code and stored in the memory in the assembly code with label `key_1` and `key_2` (option (a) in the assignment).

key_1 corresponds to initial key value = {0,0,0,0,0,0,0,0,0,0}
key_2 corresponds to initial key value = {255,255,255,255,255,255,255,255,255,255}

The four look up tables for SP layer are sbox_0, sbox_1, sbox_2, sbox_3 are also stored in the memory.

The test cases are numbered in  same the order as presented in the PRESENT paper appendix I.

# Input/Output:
The assembly code executes 31 rounds with the for_loop and then performs a final XOR between the final round_key and cipher.  
The initial plaintext and final cipher text are stored in the registers - s2 to s9 (refered as x18 to x25 in the assembly code)

# Test cases: 
TC #1 (key_1)
const uint8_t plain[8] = {0,0,0,0,0,0,0,0};
const uint8_t key[10] = {0,0,0,0,0,0,0,0,0,0};
OUTPUT(cipher) in register s2-s9: 55 79 C1 38 7B 22 84 45

TC #2 (key_2)
const uint8_t plain[8] = {0,0,0,0,0,0,0,0};
const uint8_t key[10] = {255,255,255,255,255,255,255,255,255,255}
OUTPUT(cipher) in register s2-s9: E7 2C 46 C0 F5 94 50 49

TC #3 (key_1)
const uint8_t plain[8] = {255,255,255,255,255,255,255,255};
const uint8_t key[10] = {0,0,0,0,0,0,0,0,0,0};
OUTPUT(cipher) in register s2-s9: A1 12 FF C7 2F 68 41 7B

TC #4 (key_2)
const uint8_t plain[8] = {255,255,255,255,255,255,255,255};
const uint8_t key[10] = {255,255,255,255,255,255,255,255,255,255};
OUTPUT(cipher) in register s2-s9: 33 33 DC D3 21 32 10 D2