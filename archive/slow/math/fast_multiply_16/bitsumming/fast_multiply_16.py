from time import time

FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY = True

m = 0
v = 0

def bit_sum_8(num):
    val = num
    a = 2
    while val:
        a += 2
        if (val) & 1:
            a += 5
        else:
            a += 3
        val >>= 1

    a += 11 if num & 0x80 else 10
    return a

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

        if FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY:
            # two calcs for bit sum 8
            a += bit_sum_8(lo)
            a += bit_sum_8(hi)

            if lo > hi:
                e, t = t, e
                a += 39
            a += 22

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