from math import sin, pi

output = """; Sin (Right Angle Optimised) --> Sin[x] where 0 <= x < 256 and 256 is pr/2
SIN:"""

for x in range(16):
    output += "\n   .byte "
    for y in range(16):
        output += f"${int(sin((pi / 512) * ((x << 4) + y)) * 256):02x}, "
    output = output[:-2]

with open("tables/sin.asm", "w") as f:
    f.write(output)