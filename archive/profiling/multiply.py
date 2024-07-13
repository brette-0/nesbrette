from sys import argv

def multiply(hi : tuple, lo : tuple, il, ol):

    a = 4
    for x in range(il-1, -1, -1):
        a += 10
        if hi[x]:
            a += 1
            break
    else:
        a += 10
        a += 8 * ol
        return a
    
    for x in range(il-1, -1, -1):
        a += 10
        if lo[x]:
            a += 1
            break
    else:
        a += 10
        a += 8 * ol
        return a
    
    a += 13
    a += 16 * ol

    a += il * 24
    a += 2

    if 
    return a 