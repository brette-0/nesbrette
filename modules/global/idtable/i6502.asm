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

.macro xset
    ora IDTABLE, x
.endmacro

.macro yset
    ora IDTABLE, y
.endmacro

.macro xmask
    and IDTABLE, x
.endmacro

.macro ymask
    and IDTABLE, y
.endmacro

.macro xflip
    eor IDTABLE, x
.endmacro

.macro yflip
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

