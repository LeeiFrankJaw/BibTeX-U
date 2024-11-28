rest = reversed(list(range(0x80, 0xbf+1)))
two = list(range(0xc2,0xdf+1))
three = list(range(0xe1,0xef+1))
four = list(range(0xf0,0xf4))

with open('utf8.txt', 'wb') as f:
    f.write(bytes(sum(zip(two + [0xc3]*34, rest), ())))
    f.write(bytes(sum(((i,0x80,0x80) for i in three), ())))
    f.write(bytes(sum(((i,0x90,0x80,0x80) for i in four), ())))
    f.write(bytes([0xf4,0x80,0x80,0x80]))
