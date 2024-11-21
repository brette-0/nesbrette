; illegal idtable macros

.macro laxi __imm__
    lax IDTABLE, __imm__
.endif

.macro laxy
    lax IDTABLE, y
.endif