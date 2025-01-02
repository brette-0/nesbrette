def MSSB_1(n : int) -> int:
    c : int = 7
    a : int = n
    while True:
        c += 4
        a >>= 1
        c += 2
        if not a: break

    return c


def MSSB_2(n : int) -> int:
    if not n:
        return 5
    
    c : int = 7
    a : int = n

    while True:
        c += 9
        carry = a & 0x80
        a = (a << 1) & 0xff

        if carry: break

    return c