# Description: 

This assembly implementation of KATAN encryption algorithm creates cipher for one round. Which are stored in register x10(a0) and x11(a1).

# Input/Output Register: x10, x11 (aka a0 and a1) 
Both register L1 and L2 (x10 and x11 respectively) are initialized with value 0x12345678. After the execution the same registers also reflect the acquired cipher.

Note: The relevent part of bits in both registers are the 16 bits LSB.

plaintext: 
L1 == x10 == 0x12345678
L2 == x11 == 0x12345678

cipher: 0xcf1 0xacf0
where L1 == x10 == 0x2468 acf1		
where L2 == x11 == 0x2468 acf0
Relevant part of the cipher = 0xcf1 0xacf0

The same format output will also be presented upon execution of the python verifier file.

# Highlevel python Verifier -
The pyhton code used to verify the assembly implementation is modified to reflect the specific criterias of this particular implementation. The github link to the original source code is provided below.
Github Repository: https://gist.github.com/raullenchai/2662701
Customised file: KATAN_verifier.py