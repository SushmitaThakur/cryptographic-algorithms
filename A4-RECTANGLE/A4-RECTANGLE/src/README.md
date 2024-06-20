# Description: 
The following describes an implement of a single round of the RECTANGLE cipher using the the bitsliced representation and the circuit of Appendix D: of the paper - The RECTANGLE cipher by Wentao Zhang et al. https://eprint.iacr.org/2014/084.pdf


# Input/Output:
Both assembly and the high level code perform one round of the RECTANGLE encryption algorithm. The 64bit plaintext is sliced into 4 - 16bits chunks and is XORed with key which has also been sliced up in the same fashion. The output is then passed through the 12 gate boolean circuit and then finally shifted as described in appendix-D.

In assembly code registers (a0, a1, a2, a3) contain the 4 parts of the 64bit plaintext in form of repeated 4 digits(in hex) to account for the 32 bits size registers of RISCV.

# Test case - 1
plainttext - 0x12345687812345678
(stating from LSB) -> a0 = 5678, a1 = 1234, a2 = 5678, a3 = 1234 

Registers (x5, x6, x7, x8) store the 64bit key.
key - 0xffffffffffffffff
(starting from LSB) -> x5 = ffff, x6 = ffff, x7 = ffff, x8 = ffff

final cipher is stored in registers (a0, a1, a2, a3) and for the above test case outputs : 0x4448ffffc5678000
a0 = 0x4448, a1 = 0xffff, a2 = 0xc567, a3 = 0x8000

# Test case - 2
plainttext - 0x12345687812345678
(stating from LSB) -> a0 = 5678, a1 = 1234, a2 = 5678, a3 = 1234 

Registers (x5, x6, x7, x8) store the 64bit key.
key - 0x0000ffffffff
(starting from LSB) -> x5 = ffff, x6 = ffff, x7 = 0000, x8 = 0000

final cipher is stored in registers (a0, a1, a2, a3) and for the above test case outputs : 0x4448db97bfff7776 
a0 = 0x4448, a1 = 0xdb97, a2 = 0xbfff, a3 = 0x7776

# Verifier: RECTANGLE_verifier.py
The python program used to verify the assembly code also implements bit sliced RECTANGLE with the 12 gate circuit for sbox and executes one round. All code is my own, finding an adequate RECTANGLE implementation and customizing it was taking way too much time. 
