# use ./tablemaker.py json.json ouputdir/
from json import load, dump
from sys import argv, exit
from os import system
from math import sin, cos, tan, asin, acos, atan, pi

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
    

if __name__ == "__main__": main.main()