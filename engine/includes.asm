INCLUDES_NESBRETTE_LOGIC_LSSB                   = 0
INCLUDES_NESBRETTE_LOGIC_MSSB                   = 0
INCLUDES_NESBRETTE_LOGIC_LSHIFT                 = 1
INCLUDES_NESBRETTE_LOGIC_RSHIFT                 = 1


INCLUDES_NESBRETTE_MATH_ADD                     = 1
INCLUDES_NESBRETTE_MATH_SUB                     = 1
INCLUDES_NESBRETTE_MATH_CMULT                   = 1
INCLUDES_NESBRETTE_MATH_MULT                    = 0

INCLUDES_NESBRETTE_MATH_TRIG_SIN                = 0
INCLUDES_NESBRETTE_MATH_TRIG_COS                = 0
INCLUDES_NESBRETTE_MATH_TRIG_TAN                = 0
INCLUDES_NESBRETTE_MATH_TRIG_CSC                = 0
INCLUDES_NESBRETTE_MATH_TRIG_COT                = 0
INCLUDES_NESBRETTE_MATH_TRIG_SEC                = 0

INCLUDES_NESBRETTE_PREP_ALIGNED                 = 0
INCLUDES_NESBRETTE_PREP_COLLECTION              = 1
INCLUDES_NESBRETTE_PREP_EVAL                    = 0
INCLUDES_NESBRETTE_PREP_RLOAD                   = 0

INCLUDES_NESBRETTE_MEMORY_COMPARE               = 0
INCLUDES_NESBRETTE_MEMORY_EVAL                  = 0
INCLUDES_NESBRETTE_MEMORY_FLUSH                 = 1
INCLUDES_NESBRETTE_MEMORY_JUGGLE                = 0
INCLUDES_NESBRETTE_MEMORY_MEMCPY                = 1
INCLUDES_NESBRETTE_MEMORY_MSSB                  = 0
INCLUDES_NESBRETTE_MEMORY_MSSByte               = 0
INCLUDES_NESBRETTE_MEMORY_LSSB                  = 0
INCLUDES_NESBRETTE_MEMORY_LSSByte               = 1
INCLUDES_NESBRETTE_MEMORY_MSUB                  = 0
INCLUDES_NESBRETTE_MEMORY_MSUByte               = 0
INCLUDES_NESBRETTE_MEMORY_LSUB                  = 0
INCLUDES_NESBRETTE_MEMORY_LSUByte               = 0

INCLUDES_NESBRETTE_SYNTH_INSTRUCTIONS           = 0
INCLUDES_NESBRETTE_SYNTH_IDTABLE                = 0
INCLUDES_NESBRETTE_SYNTH_ILLEGAL_ID             = 0
INCLUDES_NESBRETTE_SYNTH_STACK                  = 0

; DO NOT REMOVE THE BELOW
.ifndef ___libinclude___
    .macro ___libinclude___
        .setcpu "6502x"
        
        .feature c_comments
        .feature force_range
        .feature line_continuations
        .feature string_escapes
        .feature underline_in_numbers
        .feature bracket_as_indirect

        ; if core installed
        .ifndef insert_header
            .include .concat(libroot, "core/header.asm")    ; header and ROM info code
            .include .concat(libroot, "core/typing.asm")    ; variable types
            .include .concat(libroot, "core/enums.asm")     ; enums for nonconst reg|mao
            .include .concat(libroot, "core/null.asm")      ; null handling
            .include .concat(libroot, "core/register.asm")  ; reg validation
            .include .concat(libroot, "core/gpr.asm")       ; reg nondiscriminate synths
        .endif

        .include .concat(template, "constants.asm")         ; immutable elements
        .include .concat(template, "addresses.asm")         ; immutable 'targets' for functions
        .include .concat(template, "warnings.asm")          ; suppressable warnings
        .include .concat(template, "includer.asm")          ; minimal include system
    .endmacro
.endif