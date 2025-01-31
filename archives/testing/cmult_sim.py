lssb : object = lambda n: f"{n:08b}"[::-1].index("1")
mssb : object = lambda n: 7 - f"{n:08b}".index("1")

def cmult(a : int, c : int) -> int:
    t : int
    if mssb(c) != lssb(c):
        t = a
        for i in range(0, mssb(c) - lssb(c)):
            t <<= 1
            if (c >> (i + lssb(c))) & 1:
                a += t

    return (a << lssb(c)) & 0xff


def __main__():
    print(cmult(3, 6))


if __name__ == "__main__": __main__()