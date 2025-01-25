; untested

; idtable macros

.macro adx
    adc IDTABLE, x
.endmacro

.macro ady
    adc IDTABLE, y
.endmacro

.macro sbx
    sbc IDTABLE, x
.endmacro

.macro sby
    sbc IDTABLE, y
.endmacro

.macro orax
    ora IDTABLE, x
.endmacro

.macro oray
    ora IDTABLE, y
.endmacro

.macro andx
    and IDTABLE, x
.endmacro

.macro andy
    and IDTABLE, y
.endmacro

.macro eorx
    eor IDTABLE, x
.endmacro

.macro eory
    eor IDTABLE, y
.endmacro

.macro biti __imm__
    bit IDTABLE + __imm__
.endmacro

.macro xcmp
    cmp IDTABLE, x
.endmacro

.macro ycmp
    cmp IDTABLE, y
.endmacro

.macro xcpy
    cpx IDTABLE, y
.endmacro

.macro ycpx
    cpy IDTABLE, x
.endmacro

.macro txy
    ldy IDTABLE, x
.endmacro

.macro tyx
    ldx IDTABLE, y
.endmacro

.macro sev
    biti $40
    .endmacro