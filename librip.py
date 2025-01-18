"""

librip - NES Library 'Ripper' by Brette (2024)


"""

import os, sys






def __main__() -> None:
    print("librip - NES Library 'Ripper' by Brette (2024)")
    if len(sys.argv) == 1:
        raise Exception("librip requires at least one file")

    with open(sys.argv[1], "r") as f:
        target = f.read()

    




if __name__ == "__main__": __main__()