"""

    nesbrette table constructor, use *once* and include *however* you choose, remember that page alligned reads run zero risk of additional access cycles

"""


from sys import argv, exit
import math
from json import dump, load
from os import system

class main:
    def main()-> None:
        if len(argv) < 2:
            system("Usage : table_constructor.py table_constructor.json\nFor more information refer to the enclosed documentation.")
            system("pause")
            exit()                  # ftr this *should* be system.exit

    
    data = load(argv[1])        # read arg as path into local for json handling
    for entry in data:
        output = string()
        with open(f"./tables/{entry}.asm", "w") as f:
            for table in data[entry]:   # read each table request, within this bank
                task(eval(table.key), table.items())

    return

    @trig
    def sin(radians : float) -> float:
        return math.sin(radians)

    @trig
    def cos(radians : float) -> float:
        return math.cos(radians)

    @trig
    def tan(radians : float) -> float:
        return math.tan(radians)

    @task
    def reciprocal(**kw) -> None:
        nonlocal output
        return

    @task
    def trig(task : object, **kw) -> None:
        nonlocal output

        output += f"""; {object.__str__.upper()} LUT
; Width  : {kw.width}
; Splits : {kw.splits}
; Lossy  : {kw.lossy}
; Circle : {kw.angle}
{task.__str__.upper()}:"""
        for x in range(kw.splits * kw.width >> 4):
            output += "\n   .byte "
            for y in range(16 / kw.width):
                if (x << 4) + y > kw.splits: break

                num = int(task((pi / splits * 2 * (kw.angle * 0.25)) * ((x << 4) + y)) * ({
                    "sin" : 256, "cos" : 256, "tan" : 256, "asin" : 1, "acos" : 1, "atan" : 1
                }[task.__str__()] ** width))

                for x in range(width):
                    output += f"${(num & 0xff):02x}, "
                    num >>= 8           # write little endian
            output = output[:-2]
        return
        
    def task(table : object, **kw) -> None:
        nonlocal f, output
        args = {sin : {"width", "splits", "angle", "lossy"},
                cos : {"width", "splits", "angle", "lossy"},
                tan : {"width", "splits", "angle", "lossy"},
                asin : {"width", "splits", "angle", "lossy"},
                acos : {"width", "splits", "angle", "lossy"},
                atan : {"width", "splits", "angle", "lossy"},
                reciprocal : {"width", "entries"}
        }

        # check if all kws are met with no extra
        if any(tuple(k not in args[object] for k, w in kw)) or any(tuple(k not in kw.keys() for k, w in args[object])):
            raise KeyError("Insufficient or inappropriate keywords.")
            system("pause")
            exit()
        
        table(kw)
        f.write(output)
        return

if __name__ == "__main__":
    main.main()