INCLUDES_NESBRETTE_HEADER                   = 1

INCLUDES_NESBRETTE_LOGIC_LSSB               = 1
INCLUDES_NESBRETTE_LOGIC_MSSB               = 1


INCLUDES_NESBRETTE_MATH_ISPO2               = 1
INCLUDES_NESBRETTE_MATH_ADD                 = 1
INCLUDES_NESBRETTE_MATH_SUB                 = 1
INCLUDES_NESBRETTE_MATH_CMULT               = 1

INCLUDES_NESBRETTE_MATH_TRIG_SIN            = 0
INCLUDES_NESBRETTE_MATH_TRIG_COS            = 0

INCLUDES_NESBRETTE_IDTABLE_INSTRUCTIONS     = 0
INCLUDES_NESBRETTE_IDTABLE_ILLEGAL          = 0

INCLUDES_NESBRETTE_LOGIC_LSHIFT             = 1
INCLUDES_NESBRETTE_LOGIC_RSHIFT             = 1
; DO NOT REMOVE THE BELOW
.ifndef ___libinclude___
    .macro ___libinclude___
            .include .concat(template, "constants.asm")
            .include .concat(template, "addresses.asm")
            .include .concat(template, "warnings.asm")
            .include .concat(template, "includer.asm")
        .endmacro
    .endif