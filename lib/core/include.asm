.feature c_comments

/*

    libcore.include

    contains:
        preproc directives
        macpack includes
        libroot
        __libinclude__
        __libroot__
        include
        includefrom

    dev:
        __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN

*/


/*

    TODO: Globally including procedures shoulld have a warning circumstance

*/

.setcpu "6502x"


.feature force_range
.feature line_continuations
.feature string_escapes
.feature underline_in_numbers
.feature bracket_as_indirect
.feature dollar_in_identifiers

; sets libroot define path and includes libcore
.macro __libroot__ __path__
    .define libroot __path__

    .include .concat(libroot, "/core/warn.asm")
    .include .concat(libroot, "/core/gpr.asm")
    .include .concat(libroot, "/core/qol.asm")
    .include .concat(libroot, "/core/enums.asm")
    .include .concat(libroot, "/core/typing.asm")
    .include .concat(libroot, "/core/header.asm")
.endmacro


.macro __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN
    .fatal "includefrom requires valid feature token"
.endmacro

.macro include __token__
    .if     .xmatch(__token__, math)        ; include math
        ; include all math
    .elseif .xmatch(__token__, math_trig)   ; include math.trig
        ; check for trig tables define
        ; include trig features
    .elseif .xmatch(__token__, math_const)  ; include only constant math features
        ; include all math that doesn't call to assembled code body
    .elseif .xmatch(__token__, memory)      ; include memory
        ; include all memory
    .else
        .include .concat(libroot, __token__); raw include
    .endif

.endmacro

.macro includefrom __moduletok__, __feature__

    module  .set 0
    feature .set 0

    .if     .xmatch(__moduletok__, math)    ; include math
        module .set 0   ; math has id 0
    .elseif .xmatch(__moduletok__, memory)  ; include memory
        module .set 1   ; memory has id 1
    .else
        .fatal "includefrom requires valid parent module"
    .endif

    .if     module = 0  ; math
        .if     .xmatch(__feature__, add)       ; (add, sub)
        .elseif .xmatch(__feature__, cmult)     ; (cmult)
        .elseif .xmatch(__feature__, mult)      ; (mult)
        .elseif .xmatch(__feature__, constdiv)  ; (cdiv)
        .elseif .xmatch(__feature__, div)       ; (div)
        .elseif .xmatch(__feature__, trig)      ; (trig)
        .else
            __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN
        .endif
    .elseif module = 1  ; memory
        .if     .xmatch(__feature__, mlsusb)    ; (mssb, lssb, msub, lsub, mssbyte, msubyte, lssbyte, lsubyte, MSSB, LSSB, MSUB, LSUB)
        .elseif .xmatch(__feature__, shift)     ; (lshift, rshift)
        .elseif .xmatch(__feature__, flush)     ; (stz, ldz)
            .include .concat(libroot, "/memory/flush.asm")
        .elseif .xmatch(__feature__, generic)   ; (memcpy, evaluate, compare, juggle)
        .else
            __RAISE_FATAL_INCLUDEFROM_BAD_TOKEN
        .endif
    .endif

.endmacro