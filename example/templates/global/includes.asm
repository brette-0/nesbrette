INCLUDES_NESBRETTE_HEADER                       = 1

INCLUDES_NESBRETTE_LOGIC_LSSB                   = 0
INCLUDES_NESBRETTE_LOGIC_MSSB                   = 0
INCLUDES_NESBRETTE_LOGIC_LSHIFT                 = 0
INCLUDES_NESBRETTE_LOGIC_RSHIFT                 = 0


INCLUDES_NESBRETTE_MATH_ADD                     = 1
INCLUDES_NESBRETTE_MATH_SUB                     = 0
INCLUDES_NESBRETTE_MATH_CMULT                   = 0
INCLUDES_NESBRETTE_MATH_MULT                    = 0

INCLUDES_NESBRETTE_MATH_TRIG_SIN                = 0
INCLUDES_NESBRETTE_MATH_TRIG_COS                = 0
INCLUDES_NESBRETTE_MATH_TRIG_TAN                = 0
INCLUDES_NESBRETTE_MATH_TRIG_CSC                = 0
INCLUDES_NESBRETTE_MATH_TRIG_COT                = 0
INCLUDES_NESBRETTE_MATH_TRIG_SEC                = 0

INCLUDES_NESBRETTE_PREPROCESSOR_ALIGNED         = 0
INCLUDES_NESBRETTE_PREPROCESSOR_COLLECTION      = 0
INCLUDES_NESBRETTE_PREPROCESSOR_EVAL            = 0
INCLUDES_NESBRETTE_PREPROCESSOR_NULL            = 0
INCLUDES_NESBRETTE_PREPROCESSOR_RLOAD           = 0
INCLUDES_NESBRETTE_PREPROCESSOR_TYPING          = 1

INCLUDES_NESBRETTE_MEMORY_COMPARE               = 0
INCLUDES_NESBRETTE_MEMORY_EVAL                  = 0
INCLUDES_NESBRETTE_MEMORY_FLUSH                 = 0
INCLUDES_NESBRETTE_MEMORY_JUGGLE                = 0
INCLUDES_NESBRETTE_MEMORY_MEMCPY                = 0
INCLUDES_NESBRETTE_MEMORY_MSSB                  = 0

INCLUDES_NESBRETTE_SYNTHETIC_INSTRUCTIONS       = 0
INCLUDES_NESBRETTE_SYNTHETIC_IDTABLE            = 0
INCLUDES_NESBRETTE_SYNTHETIC_ILLEGAL_ID         = 0
; DO NOT REMOVE THE BELOW
.ifndef ___libinclude___
    .macro ___libinclude___
            .include .concat(template, "constants.asm")
            .include .concat(template, "addresses.asm")
            .include .concat(template, "warnings.asm")
            .include .concat(template, "includer.asm")
        .endmacro
    .endif