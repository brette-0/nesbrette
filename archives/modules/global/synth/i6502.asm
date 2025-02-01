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

.macro cmpx
    cmp IDTABLE, x
.endmacro

.macro cmpy
    cmp IDTABLE, y
.endmacro

.macro cpxy
    cpx IDTABLE, y
.endmacro

.macro cpyx
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

.macro trr __src__, __tar__
    .if __src__ = __tar__
        .exitmacro
    .endif

    .if    __src__ = ar
        tar __tar__
    .elseif __src__ = xr
        txr __tar__
    .elseif __src__ = yr
        tyr __tar__
    .else
         .fatal "Invalid register specified"
    .endif
.endmacro


.macro rcp __src__, __tar__
    .if __src__ = __tar__
        .exitmacro
    .endif

    .if __tar__ = ar
        .fatal
    .if ( isconst __src__ ) && (isconst __tar__ )
        .if __tar__ = xr
            .if __src__ = ar
                cmpx
            .else
                cpyx
            .endif
        .elseif __tar__ = yr
            .if __src__ = ar
                cmpy
            .else
                cpxy
            .endif
        .endif

        .exitmacro
    .endif

    .if     __src__ = ar
        cpr ar: __tar__
    .elseif __src__ = xr
        cpr xr: __tar__
    .elseif __src__ = yr
        cpr yr: __tar__
    .else
         .fatal "Invalid register specified"
    .endif
.endmacro


