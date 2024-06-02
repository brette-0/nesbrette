import math

for r in range(16):
    if r: print(".byte       " + "".join([f"${math.floor(256 / ((r << 4) + c)):02x}, " for c in range(16)])[:-2])
    else: print(".byte       $ff, $ff, " + "".join([f"${math.floor(256 / ((r << 4) + c)):02x}, " for c in range(2, 16)])[:-2])