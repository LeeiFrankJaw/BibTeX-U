# from itertools import product
# from collections import Counter

# chars = {
    # '拽': 'zhuai4',
    # '睚': 'ya2',
    # '么': 'me5',
    # '麽': 'me5',
    # '龡': 'chui1'
# }

# t_py = list(filter(lambda t: t[1].isascii(),
#                    [(ch, chars.get(ch, pinyin.get(ch, format='strip')))
#                     for ch in map(chr,range(0x4e00,0x9fff+1))]))

# m_py = list(zip(*Counter(t[1] for t in t_py).most_common()))[0]

# py_py = [s[:-1] for s in m_py ]

# d_py = dict(t_py)

# tones = range(224+1,224+5+1)
# finals = range(128,128+64)
# initials = range(128+1,128+32)

# with open('pinyin.txt', 'wb') as f:
#     f.write(bytes(sum(product(tones, finals, initials), ())))
    # f.write(bytes(range(0x00,0x7f)))

with open('utf8.collation.pinyin.txt', 'r') as f, open('utf8.pinyin.txt', 'w') as g:
    chs = f.read().split()
    missing_chs = [(ch, idx) for idx, ch in enumerate(map(chr,range(0x4e00,0x9fff+1))) if ch not in chs]
    chars = [(ch, idx) for idx, ch in enumerate(
        ch for ch in chs
        if len(ch) == 1 and ord(ch) >= 0x4e00 and ord(ch) <= 0x9fff
    )]
    charmap = dict(chars + missing_chs)
    g.write(''.join(chr(0x4e00 + charmap[ch]) for ch in map(chr,range(0x4e00,0x9fff+1))))
