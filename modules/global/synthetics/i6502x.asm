; untested

; illegal idtable macros

.macro laxi __imm__
    lax (IDTABLE + __imm__)
.endif

.macro tyxa
    lax IDTABLE, y
.endif