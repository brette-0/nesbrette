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
            .include "constants.nesbrette.asm"
            .include "addresses.nesbrette.asm"
            .include "warnings.nesbrette.asm"
            .include "includer.nesbrette.asm"
        
            ; not for user use
            .undef ___includeif___
            .undef ___libinclude___
        .endmacro
    .endif