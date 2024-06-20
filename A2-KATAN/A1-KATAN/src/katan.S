.section .text
.global katan
katan:

// initialize L1 and L2
li x10, 0x12345678;
li x11, 0x12345678;

/*** fa : L1: x10 ***/
//1
//mask x12
 li t0, 0x1000
 AND t1, x10, t0
 srli t1, t1, 12

//mask x7
 li t0, 0x80
 AND t2, x10, t0
 srli t2, t2, 7

XOR x12, t1, t2

//2
//mask x8
 li t0, 0x100
 AND t3, x10, t0
 srli t3, t3, 8

//mask x5
 li t0, 0x20
 AND t4, x10, t0
 srli t4, t4, 5

AND x13, t3, t4

//3 : IR=1
//mask x3
 li t0, 0x8
 AND t1, x10, t0
 srli t1, t1, 3

ANDi x14, t1, 0x1

//4 : XOR 1,2
XOR x12, x12, x13

//5 : XOR 3,4
XOR x12, x14, x12

//6 : XOR 5, ka
// load ka=0 or XORi
XORi x12, x12, 0x0;

/*** fb ***/
//1
//mask y18
 li t0, 0x40000
 AND t1, x11, t0
 srli t1, t1, 18

//mask y7
 li t0, 0x80
 AND t2, x11, t0
 srli t2, t2, 7

XOR x15, t1, t2

// 2
// 0001 0010 0011 0100 0101 0110 0111 1000
//mask y12
 li t0, 0x1000
 AND t3, x11, t0
 srli t3, t3, 12

//mask y10
 li t0, 0x400
 AND t4, x11, t0
 srli t4, t4, 10

AND x16, t3, t4

//3
//mask y8
 li t0, 0x100
 AND t1, x11, t0
 srli t1, t1, 8

//mask y3
 li t0, 0x8
 AND t2, x11, t0
 srli t2, t2, 3

AND x17, t1, t2

//4
XOR x15, x15, x16
//5
XOR x15, x15, x17
//6 : XOR kb=1
XORi x15, x15, 0x1;

// x15 has the result of fb which needs to be shifted to LSB of L1:x10
// x12 has the result of fa which needs to be shifted to LSB of L2:x11

//L1 = x10 -> fb= x15
slli x10, x10, 1
ADD x10, x10, x15

//L2 = x11 -> fa= x12
slli x11, x11, 1
ADD x11, x11, x12

ret;
