import struct, zlib, sys
from pathlib import Path
def bmp(path):
    d = Path(path).read_bytes()
    off, = struct.unpack_from('<I', d, 10); w, h = struct.unpack_from('<ii', d, 18); bpp, = struct.unpack_from('<H', d, 28)
    bpp //= 8; stride = (w * bpp + 3) & ~3; rows = []
    for y in range(abs(h)):
        sy = abs(h) - 1 - y if h > 0 else y
        r = d[off + sy * stride: off + sy * stride + w * bpp]
        rows.append(bytes(b for i in range(w) for b in (r[i*bpp+2], r[i*bpp+1], r[i*bpp])))
    return w, abs(h), rows
def png(path, w, h, rows):
    raw = b''.join(b'\0' + r for r in rows)
    c = lambda t, b: struct.pack('>I', len(b)) + t + b + struct.pack('>I', zlib.crc32(t + b) & 0xffffffff)
    Path(path).write_bytes(b'\x89PNG\r\n\x1a\n' + c(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 2, 0, 0, 0)) + c(b'IDAT', zlib.compress(raw, 9)) + c(b'IEND', b''))
a, b, out, tick = Path(sys.argv[1]), Path(sys.argv[2]), sys.argv[3], sys.argv[4]
scenes = sys.argv[5].split(',')
gap = 6; tiles = []
for s in scenes:
    wa, ha, ra = bmp(a / f'fluid-{s}-{tick}.bmp'); wb, hb, rb = bmp(b / f'fluid-{s}-{tick}.bmp')
    tiles.append([x + b'\x40' * 3 * gap + y for x, y in zip(ra, rb)])
w = len(tiles[0][0]) // 3
rows = []
for t in tiles:
    rows += t + [b'\x40' * 3 * w] * gap
png(out, w, len(rows), rows)
print(w, len(rows))
