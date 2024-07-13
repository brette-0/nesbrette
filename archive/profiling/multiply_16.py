from time import time

FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY = True

m = 0
v = 0

output = "NESBRETTE function::math::fast_multiply_16 all mode profiling\n\n"
for hi in range(256):
    for lo in range(256):
        if not lo:
            output += f"{hi} X 0 --> 20 cycles\n"
            continue
        
        if lo == 1 or not hi:
            output += f"{hi} X 1 --> 29 cycles\n"
            continue

        e = lo
        t = hi
        a = 26

        while e:
            a += 15
            t <<= 1
            if (e & 1):
                a += 30
            else:
                a += 3
            e >>= 1
        a += 5

        output += f"{hi} X {lo} --> {a} cycles\n"

        m = max(a , m)
        v += a

output += f"Max CPU Time : {m} cycles\n"
output += f"Avg CPU Time : {v / 65536} cycles\n"

with open("fast_multiply_16.txt", "w") as f:
    f.write(output)