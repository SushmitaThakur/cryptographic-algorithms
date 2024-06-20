__author__ = 'Sushmita Thakur'

from collections import deque

class RECTANGLE():

    def __init__(self, plaintext, key) -> None:

        temp = format(plaintext, '064b')
        self.a0 = int(temp[48:64] , 2)
        self.a1 = int(temp[32:48], 2)
        self.a2 = int(temp[16:32], 2)
        self.a3 = int(temp[0:16], 2)

        temp = format(key, '064b')
        self.k0 = int(temp[48:64] , 2)
        self.k1 = int(temp[32:48], 2)
        self.k2 = int(temp[16:32], 2)
        self.k3 = int(temp[0:16], 2)

        # print(hex(self.a0), "\t",hex(self.a1),"\t", hex(self.a2), "\t", hex(self.a3))
        

    def add_round_key(self) -> None:
        
        self.a0 ^= self.k0
        self.a1 ^= self.k1
        self.a2 ^= self.k2
        self.a3 ^= self.k3

        # print(hex(self.a0), "\t",hex(self.a1),"\t", hex(self.a2), "\t", hex(self.a3))
    
    def sbox(self) -> int:
        
        # xor-ing with 0xffff and not operand with python results into 'true'/'false' not 1/0 
        t1 = self.a1 ^ 0xffff
        t2 = self.a0 & t1
        t3 = self.a2 ^ self.a3
        b0 = t2 ^ t3
        t5 = self.a3 | t1
        t6 = self.a0 ^ t5
        b1 = self.a2 ^ t6
        t8 = self.a1 ^ self.a2
        t9 = t3 & t6
        b3 = t8 ^ t9
        t11 = b0 | t8
        b2 = t6 | t11

        return b0, b1, b2, b3

    def shift_rows(self, b0: int, b1: int, b2: int, b3: int) -> int:

        c0 = b0
        c1 = deque([x for x in format(b1, "016b")])
        c1.rotate(-1)

        c2 = deque([x for x in format(b2, "016b")])
        c2.rotate(-12)

        c3 = deque([x for x in format(b3, "016b")])
        c3.rotate(-13)

        c1 = "".join([x for x in c1])
        c2 = "".join([x for x in c2])
        c3 = "".join([x for x in c3])

        return c0, int(c1, 2), int(c2, 2), int(c3, 2)

if __name__ == '__main__':

    plaintext = 0x1234567812345678
    # key = 0xffffffffffffffff

    key = 0x00000000ffffffff
    
    print("\n\nPlain text: ", hex(plaintext), "\n", "Key:", hex(key))
    # print(format(plaintext, '064b'))

    rec = RECTANGLE(plaintext, key)

    rec.add_round_key()
    print("\nAfter Add round key: ", hex(rec.a0) ,hex(rec.a1), hex(rec.a2), hex(rec.a3))

    b0, b1, b2, b3 = rec.sbox()
    print("\nAfter S-Box: ", hex(b0), hex(b1), hex(b2), hex(b3))

    c0, c1, c2, c3 = rec.shift_rows(b0, b1, b2, b3)
    print("\nAfter Shift Rows: (cipher) ", hex(c0), hex(c1), hex(c2), hex(c3), "\n\n")