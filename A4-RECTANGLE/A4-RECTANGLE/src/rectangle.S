.section .text
.global rectangle

rectangle:

// Initialize 64 bit plain text - each register is 32 bits here so we will only be using 16bits LSB from each register
// plaintext - 0x1234567812345678 --> 1234(a3), 5678(a2), 1234(a1), 5678(a0)
li a0, 0x56785678;
li a1, 0x12341234;
li a2, 0x56785678;
li a3, 0x12341234;


// Initialize 64 bit key
li x5, 0xffffffff
li x6, 0xffffffff
li x7, 0xffffffff
li x8, 0xffffffff

// XOR plain text and key, row1(text)^row1(key).... row3(text)^row3(key)
xor a0, a0, x5
xor a1, a1, x6
xor a2, a2, x7
xor a3, a3, x8

// s-box circuit implementation
// 1. T1(t0) = NOT A1;
// 2. T2(t1) = A0 AND T1,
// 3. T3(t2) = A2 XOR A3,
// 4. B0(x14) = T2 XOR T3
not t0, a1
and t1, a0, t0
xor t2, a2, a3
xor x14, t1, t2

// 5. T5(t3) = A3|T1
// 6. T6(t4) = A0^T5
// 7. B1(x15) = A2^T6

or t3, a3, t0
xor t4, a0, t3
xor x15, a2, t4

// 8. T8(t5) = a1 xor a2
// 9. T9(t6) = T3 and T6
// 10. B3(x17)= T8 xor T9

xor t5, a1, a2
and t6, t2, t4
xor x17, t5, t6

// 11. T11(t0) = B0 or T8
// 12. B2(x16) = T6 or T11
or t0, x14, t5
or x16, t4, t0

// the results of s-box circuit B0,B1,B2,B3 = x14,x15,x16,x17

// shift rows (rotated shifts)

//TODO: mask the first 16 bits

// C0 = B0 = x14, no operation needed
or a0, x14, x0

// C1 =B1 << 1;
slli t0, x15, 1
srli x15, x15, 32-1
xor a1, x15, t0

// C2 =B2 << 12
slli t0, x16, 12
srli x16, x16, 32-12
xor a2, x16, t0

// C3 =B3 << 13
slli t0, x17, 13
srli x17, x17, 32-13
xor a3, x17, t0

// Final cipher
//a0 = 4448, a1 = ffff, a2 = c567, a3 = 8000

ret;
