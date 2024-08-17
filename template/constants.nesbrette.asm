; Do not change
    Debug   = 0
    Release = 1


; Change at your leisure

Build       = Debug

OPTIMISE_DIVISION_MULTIPLICANT_OF_TWO = (Build = Release)
OPTIMISE_DIVISION_POWER_OF_TWO        = (Build = Release)


FUNCTION_MATH_ADDITION_LITTLE_ENDIAN    = 1
FUNCTION_MATH_SUBTRACTION_LITTLE_ENDIAN = 1




; ines2 Module
PRG_ROM_AMT = 1 ; x16
CHR_ROM_AMT = 1 ; x8
.ifdef ines2 
    CONSOLE_TYPE = ines2::CONTOLE_TYPES::NES
    REGION       = ines2::REGIONS::NTSC
.else
    CONSOLE_TYPE = 0
    REGION       = 0
.endif