from time import time

output = "NESBRETTE function::logic::sum_bits_8 all mode profiling\n\n"
for num in range(256):
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
    output += f"{num} --> {a} cycles\n"

with open("sum_bits_8.txt", "w") as f:
    f.write(output)