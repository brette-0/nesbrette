# use ./tablemaker.py json.json ouputdir/
from json import load, dump
from sys import argv, exit
from os import system
from math import sin, cos, tan, asin, acos, atan, pi

def is_prime(n):
    if n == 2 or n == 3: return True
    if n < 2 or n%2 == 0: return False
    if n < 9: return True
    if n%3 == 0: return False
    r = int(n**0.5)
  # since all primes > 3 are of the form 6n ± 1
  # start with f=5 (which is prime)
  # and test f, f+2 for being prime
  # then loop by 6. 
    f = 5
    while f <= r:
        print('\t',f)
        if n % f == 0: return False
        if n % (f+2) == 0: return False
        f += 6
    return True  

class main:
    
    def main():
        with open(argv[1], "rb") as f:
            generator = load(f)
        for bank in generator:
            output = ""
            for table in generator[bank]:
                output += eval(f"main.{table}(**{generator[bank][table]})")

            with open(f"{argv[2]}/{bank}.asm", "w") as f:
                f.write(output)
    
        return
    

    def trig(table : object, **kw : dict) -> str:
        valid_args = {"lossy", "circle", "index_width", "element_width", "signed", "space_efficient"}

        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")
 
        output = f"""\n;   {table.__name__.upper()} TABLE
{table.__name__.upper()}_Lossy   = {kw["lossy"]}
{table.__name__.upper()}_InWidth = {kw["index_width"]}
{table.__name__.upper()}_OutWidth= {kw["element_width"]}
{table.__name__.upper()}_Circle  = {kw["circle"]}
{table.__name__.upper()}_Signed  = {kw["signed"]}
{table.__name__.upper()}_Concise = {kw["space_efficient"]}
{table.__name__.upper()}:"""
            
        for hi in range(kw["index_width"] << (kw["space_efficient"] >> (table.__name__ == "tan"))):
            output += "\n.byte "
            for lo in range(16):
                num = (2 ** kw["element_width"]) * table(2 * pi * ((hi * 16) + lo) / (2 ** kw["index_width"]))
                if num < 0: 
                    num = (2 ** kw["element_width"]) + num
                num = int(num)
                for _ in range(kw["element_width"] >> 3):
                    output += f"${abs(num) & 0xff:02x}, "
                    num >>= 8
            output = output[:-2]
        return output

    def sin(**kw):
        return main.trig(sin, **kw)
    
    def cos(**kw):
        return main.trig(cos, **kw)
    
    def tan(**kw):
        return main.trig(tan, **kw)

    def primes(**kw):
        valid_args = {"digits"}

        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")

        result = "PRIME_TABLE:\n   .addr "

        for x in range(kw["digits"]):
            result += f"@PRIME_DIGS_{x}, "

        result = result[:-2] + "@PRIME_DIGS_END:\n"

        c = 2
        nums = []
        for x in range(kw["digits"]):
            while not is_prime(z): c += 1
            z = f"{z:x}"
            y : str = ".byte "
            while len(z):
                y += f"${z[-2:]}, "
                z = z[:-2]
            y = y[:-2] + "\n"
            result += f"@PRIME_DIGS_{x}:\n"
            result += y
        result += "@PRIME_DIGS_END:\n"
        return result
    
    def tens(**kw):
        valid_args = {"digits"}

        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")

        result = "PO10_TABLE:\n   .addr "

        for x in range(kw["digits"]):
            result += f"@PO10_DIGS_{x}, "
        
        result = result[:-2] + "@PO10_DIGS_END:\n"

        for x in range(kw["digits"]):
            z = f"{2**x:x}"
            y : str = ".byte "
            while len(z):
                y += f"${z[-2:]}, "
                z = z[:-2]
            y = y[:-2] + "\n"
            result += f"@PO10_DIGS_{x}:\n"
            result += y
        result += "@PO10_DIGS_END:\n"
        return result
    
    def reciprocal(**kw):
        valid_args = {"lossy", "circle", "index_width", "element_width", "signed", "space_efficient"}

        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")

        output = f"""\n;   RECIPROCAL TABLE
RECIPROCAL_Lossy   = {kw["lossy"]}
RECIPROCAL_InWidth = {kw["index_width"]}
RECIPROCAL_OutWidth= {kw["element_width"]}
RECIPROCAL_Signed  = {kw["signed"]}
RECIPROCAL:"""
        
    def idtables(**kw):
        valid_args = {"reversed"}
        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")

        output = f"""\n;   {"R" if kw["revsersed"] else "ID"}TABLE
{"R" if kw["revsersed"] else "ID"}TABLE:"""
        output += "".join(
            [".byte ".join([f"${(i << 4) + j:02x}, " for j in range(16)][::(-1 if kw["revsersed"] else 1)]) + "\n"
              for i in range(16)][::(-1 if kw["revsersed"] else 1)]
            )

if __name__ == "__main__": main.main()