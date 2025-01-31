import matplotlib.pyplot as plt

"""

    This code is only designed to test accumulator mode, a test is needed for address mode.

"""

def biased_complexity(n : int) -> int:
    c : int = 1
    r : int = 0
    while n:
        if n & 1:
            r += c
        n >>= 1
        c += 1
    return r 

def mssb(n : int) -> int:
    for i in range(8):
        if n >> (7 - i): return 7 - i

def lssb(n : int) -> int:
    for i in range(8):
        if n & (1 << i): return i


def cmult(m : int) -> int:
    retval : int = int()
    if m:
        retval += lssb(m) * 2
        
        if not ((m - 1) & m): return retval
        retval += 5

        retval += (mssb(m) - lssb(m)) * 5
        retval += bin(m >> lssb(m)).count("1") * 3
        return retval
    else: return 2

def __main__():
    data = [cmult(m) for m in range(256)]
    with open("profiling/math/cmult_results/cmult_accumulator_mode_profiling.txt", "w") as f:
        f.write("".join(f"{r}, " for r in range(256))[:-2])

    plt.style.use('dark_background')
    plt.figure(figsize=(8, 6))

    plt.scatter([x for x in range(256)], data, c="blue", marker="o")
    plt.xlim(0, 256)
    plt.ylim(0, 64)
    plt.xticks(range(0, 257, 32))
    plt.yticks(range(0, 65, 8))
    plt.xlabel("Constant Multiplier")
    plt.ylabel("CPU Time in cycles")
    plt.title("cmult macro profiling")
    plt.grid(True)
    plt.grid(color='gray', linestyle='--', linewidth=0.5)
    plt.savefig("profiling/math/cmult_results/cmult_accumulator_mode_multiplier_profiling.png", dpi=300, bbox_inches='tight')
    plt.show()

    plt.scatter([data[x].bit_count() for x in range(256)], data, c="blue", marker="o")
    plt.xlim(0, 6)
    plt.ylim(0, 64)
    plt.xticks(range(0, 6, 1))
    plt.yticks(range(0, 65, 8))
    plt.xlabel("Constant Multiplier Unbiased Complexity")
    plt.ylabel("CPU Time in cycles")
    plt.title("cmult macro profiling")
    plt.grid(True)
    plt.grid(color='gray', linestyle='--', linewidth=0.5)
    plt.savefig("profiling/math/cmult_results/cmult_accumulator_mode_unbiased_complexity_profiling.png", dpi=300, bbox_inches='tight')
    plt.show()

    plt.scatter([biased_complexity(data[x]) for x in range(256)], data, c="blue", marker="o")
    plt.xlim(0, 20)
    plt.ylim(0, 64)
    plt.xticks(range(0, 20, 1))
    plt.yticks(range(0, 65, 8))
    plt.xlabel("Constant Multiplier Biased Complexity")
    plt.ylabel("CPU Time in cycles")
    plt.title("cmult macro profiling")
    plt.grid(True)
    plt.grid(color='gray', linestyle='--', linewidth=0.5)
    plt.savefig("profiling/math/cmult_results/cmult_accumulator_mode_biased_complexity_profiling.png", dpi=300, bbox_inches='tight')
    plt.show()
if __name__ == "__main__": __main__()