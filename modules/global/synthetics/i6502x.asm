; untested

; illegal idtable macros

.macro laxi __imm__
    lax (IDTABLE + __imm__)
    .endmacro

.macro tyxa
    lax IDTABLE, y
    .endmacro