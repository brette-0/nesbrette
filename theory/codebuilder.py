"""

    Codebuilder | Brette
    --------------------

    This script is used to build performant code based upon immediate values

"""

def __main__(imm : int) -> None:
    
    stackptr : int = 0
    output : str = str()
    output += f".macro imult_{imm}"
    while(imm):
        if (imm & 1):
            output += "pha"
            stackptr += 1

        output += "asl"
        imm >>= 1
        
    while (stackptr):
        if (stackptr): output += "sta $00"
        output += "pla"
        output += "adc $00"
        stackptr -= 1
    
    output += "    .endmacro"
    return

if __name__ == "__main__": __main__()