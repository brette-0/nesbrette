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
    
    def id(**kw):
        valid_args = {}
        if any(tuple(arg not in valid_args for arg in kw)) or any (arg not in kw for arg in valid_args):
            print(f"Invalid arguements found")
        return """ID_TABLE:
    .byte $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    .byte $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f
    .byte $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f
    .byte $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f
    .byte $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f
    .byte $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f
    .byte $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f
    .byte $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f
    .byte $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f
    .byte $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f
    .byte $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af
    .byte $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf
    .byte $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf
    .byte $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df
    .byte $e0, $e1, $e2, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $ee, $ef
    .byte $f0, $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff
"""


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