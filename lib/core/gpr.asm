.macro inr __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        inx
    .elseif __target__ = yr
        iny
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro der __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        dex
    .elseif __target__ = yr
        dey
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro tar __target__
    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif
    
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        tax
    .elseif __target__ = yr
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; tyx/txy is documented as i6502 (NOT CA65 MACPACK OR STACK METHOD)
.macro tyr __target__
    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr && INCLUDES_NESBRETTE_SYNTH_IDTABLE
        tyx
    .elseif __target__ = ar
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro txr __target__
    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        txa
    .elseif __target__ = yr
        txy
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro tra __target__
    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txa
    .elseif __target__ = yr
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro trx __target__
    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        tax
    .elseif __target__ = yr
        tyx
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro try __target__

    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txy
    .elseif __target__ = ar
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro ldr __typed_reg__, __value__
    .local mode, treg
    detype __typed_reg__, mode

    .if mode = imp || mode = inabs
        .fatal "Invalid Memory Address Mode for Load A/X/Y/AX"
    .endif

    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE && !( isconst treg ) && !(isconst ( ilabel __typed_reg__ ))
        .fatal "Identity table must be included in order to perform this action."
    .endif

    
    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mode = imm || mode = zp || mode = zpx || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            lda #__value__
            .exitmacro
        .elseif mode = abs
            lda __value__ | $800
        .elseif mode = absy
            lda __value__ | $800, y
        .elseif mode = absx
            lda __value__ | $800, x
        .elseif mode = zp || mode = wabs
            lda __value__
        .elseif mode = zpy || mode = wabsy
            lda __value__, y
        .elseif mode = zpx || mode = wabsx
            lda __value__, x
        .elseif mode = inabsy
            lda [__value__], y
        .elseif mode = inabsx
            lda [__value__, x]
        .endif
    .elseif treg = yr
        .if mode = zpy || mode = wabsy || mode = absy || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Load Y"
        .endif

        .if (mode = imm || mode = zp || mode = zpx) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            ldy #__value__
            .exitmacro
        .elseif mode = abs
            ldy __value__ | $800
        .elseif mode = absx
            ldy __value__ | $800, x
        .elseif mode = zp || mode = wabs
            ldy __value__
        .elseif mode = zpx || mode = wabsx
            ldy __value__, x
        .endif
    .elseif treg = xr
        .if mode = zpx || mode = wabsx || mode = absx || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Load X"
        .endif

        .if (mode = imm || mode = zp || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            ldy #__value__
            .exitmacro
        .elseif mode = abs
            ldx __value__ | $800
        .elseif mode = absy
            ldx __value__ | $800, x
        .elseif mode = zp || mode = wabs
            ldx __value__
        .elseif mode = zpy || mode = wabsy
            ldx __value__, y
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

.endmacro

.macro str __typed_reg__, __value__
    .local mode, treg
    detype __typed_reg__, mode

    ; USE HEADER TO DETERMINE ROM SPACE, BLOCK DIRECT STORES INTO ROM

    .if mode = imp || mode = inabs || mode = imm
        .fatal "Invalid Memory Address Mode for Store A/X/Y"
    .endif

    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE && !( isconst treg ) && !(isconst ( ilabel __typed_reg__ ))
        .fatal "Identity table must be included in order to perform this action."
    .endif


    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mode = imm || mode = zp || mode = zpx || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = abs
            sta __value__ | $800
        .elseif mode = absy
            sta __value__ | $800, y
        .elseif mode = absx
            sta __value__ | $800, x
        .elseif mode = zp || mode = wabs
            sta __value__
        .elseif mode = zpy || mode = wabsy
            sta __value__, y
        .elseif mode = zpx || mode = wabsx
            sta __value__, x
        .elseif mode = inabsy
            sta [__value__], y
        .elseif mode = inabsx
            sta [__value__, x]
        .endif
    .elseif treg = yr
        .if mode = zpy || mode = wabsy || mode = wabsx || mode = absy || mode = absx || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Store Y"
        .endif

        .if (mode = zp || mode = zpx) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = abs
            sty __value__ | $800
        .elseif mode = zp || mode = wabs
            sty __value__
        .elseif mode = zpx
            sty __value__, x
        .endif
    .elseif treg = xr
        .if mode = zpx || mode = wabsx || mode = wabsy || mode = absx || mode = absy || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Store X"
        .endif

        .if (mode = zp || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = abs
            stx __value__ | $800
        .elseif mode = zp || mode = wabs
            stx __value__
        .elseif mode = zpy
            stx __value__, y
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

    ; block confirmable direct writes to ROM
    .if target >= $8000 && (mode = abs || mode = wabs || mode = absx || mode = absy || mode = wabsy || mode = wabsx)
        .if ::HEADER == header_mapper_mmc5
            .exitmacro
        .endif

        .if ::HEADER == header_mapper_mmc5
            .exitmacro
        .endif

        .if ::HEADER == header_mapper_mmc1
            .exitmacro
        .endif

        .if ::HEADER == header_mapper_fme7
            .exitmacro
        .endif

        .fatal "Attempted to write to ROM"
    .endif


.endmacro

.macro cpr __typed_reg__, __value__
    .local mode, treg
    detype __typed_reg__, mode

    .if mode = imp || mode = inabs
        .fatal "Invalid Memory Address Mode for Compare A/X/Y"
    .endif

    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE && !( isconst treg ) && !(isconst ( ilabel __typed_reg__ ))
        .fatal "Identity table must be included in order to perform this action."
    .endif

    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mode = imm || mode = zp || mode = zpx || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cmp #__value__
            .exitmacro
        .elseif mode = abs
            cmp __value__ | $800
        .elseif mode = absy
            cmp __value__ | $800, y
        .elseif mode = absx
            cmp __value__ | $800, x
        .elseif mode = zp || mode = wabs
            cmp __value__
        .elseif mode = zpy || mode = wabsy
            cmp __value__, y
        .elseif mode = zpx || mode = wabsx
            cmp __value__, x
        .elseif mode = inabsy
            cmp [__value__], y
        .elseif mode = inabsx
            cmp [__value__, x]
        .endif
    .elseif treg = yr
        .if mode = zpy || mode = wabsy || mode = wabsx || mode = absx || mode = zpx || mode = absy || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Compare Y"
        .endif

        .if (mode = imm || mode = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cpy #__value__
            .exitmacro
        .elseif mode = abs
            cpy __value__ | $800
        .elseif mode = zp || mode = wabs
            cpy __value__
        .endif
    .elseif treg = xr
        .if mode = zpx || mode = wabsx || mode = wabsy || mode = absy || mode = zpy || mode = absx || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Compare X"
        .endif

        .if (mode = imm || mode = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cpx #__value__
            .exitmacro
        .elseif mode = abs
            cpx __value__ | $800
        .elseif mode = zp || mode = wabs
            cpx __value__
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

.endmacro