__author__ = 'Raullen'

IR = 1
key_a = 0
key_b = 1

def num2bits(num, bitlength):
    bits = []
    for i in range(bitlength):
        bits.append(num & 1)
        num >>= 1
    return bits

def bits2num(bits):
    num = 0
    for i, x in enumerate(bits):
        assert x == 0 or x == 1
        num += (x << i)
    return num

class KATAN():
    def __init__(self, version = 32):

        self.version = version

        self.LEN_L1 = 13
        self.LEN_L2 = 19
        self.X = (None, 12, 7, 8, 5, 3) # so that x0 = None and x1 = 12 
        self.Y = (None, 18, 7, 12, 10, 8, 3)

    def one_round_enc(self):

        # calculate f_a and f_b
        self.f_a = self.L1[self.X[1]] ^ self.L1[self.X[2]]\
                   ^ (self.L1[self.X[3]] & self.L1[self.X[4]])\
                   ^ (self.L1[self.X[5]] & IR)\
        ^ key_a

        self.f_b = self.L2[self.Y[1]] ^ self.L2[self.Y[2]]\
                   ^ (self.L2[self.Y[3]] & self.L2[self.Y[4]])\
                   ^ (self.L2[self.Y[5]] & self.L2[self.Y[6]])\
        ^ key_b

        # shift L1 and L2 and append the result of f_a and f_b to the LSB
        self.L1.pop()
        self.L1.insert(0, self.f_b)

        self.L2.pop()
        self.L2.insert(0, self.f_a)

    def enc(self, plaintext):
        self.plaintext_bits = num2bits(plaintext, self.version)
        # print(self.plaintext_bits)

        # LSB [0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1,* L2 ends - L1 begins * 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0]MSB
        self.L2 = self.plaintext_bits[:self.LEN_L2] # first half of the bits: because we have bits lined up from right to left in array here(->)
        self.L1 = self.plaintext_bits[:self.LEN_L1] # second half of the bits

        # self.L2 = self.plaintext_bits 
        # self.L1 = self.plaintext_bits

        self.one_round_enc()
        print("Cipher = ", hex(bits2num(self.L1)), hex(bits2num(self.L2)))
        
        return bits2num(self.L2 + self.L1)

if __name__ == '__main__':
  
    plaintext = 0x12345678
    print('Plaintext =', hex(plaintext))

    myKATAN = KATAN()
    encrypted = myKATAN.enc(plaintext)
    # print ('encrypted =', hex(encrypted))
