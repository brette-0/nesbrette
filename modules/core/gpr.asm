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
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        tyx
    .elseif __target__ = ar
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro txr __target__
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
    .local mao, treg
    detype __typed_reg__, mao

    .if mao = imp || mao = inabs
        .fatal "Invalid Memory Address Mode for Load A/X/Y/AX"
    .endif
    
    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mao = imm || mao = zp || mao = zpx || mao = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            lda #__value__
            .exitmacro
        .elseif mao = abs
            lda __value__ | $800
        .elseif mao = absy
            lda __value__ | $800, y
        .elseif mao = absx
            lda __value__ | $800, x
        .elseif mao = zp || mao = wabs
            lda __value__
        .elseif mao = zpy || mao = wabsy
            lda __value__, y
        .elseif mao = zpx || mao = wabsx
            lda __value__, x
        .elseif mao = inabsy
            lda [__value__], y
        .elseif mao = inabsx
            lda [__value__, x]
        .endif
    .elseif treg = yr
        .if mao = zpy || mao = wabsy || mao = absy || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Load Y"
        .endif

        .if (mao = imm || mao = zp || mao = zpx) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            ldy #__value__
            .exitmacro
        .elseif mao = abs
            ldy __value__ | $800
        .elseif mao = absx
            ldy __value__ | $800, x
        .elseif mao = zp || mao = wabs
            ldy __value__
        .elseif mao = zpx || mao = wabsx
            ldy __value__, x
        .endif
    .elseif treg = xr
        .if mao = zpx || mao = wabsx || mao = absx || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Load X"
        .endif

        .if (mao = imm || mao = zp || mao = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            ldy #__value__
            .exitmacro
        .elseif mao = abs
            ldx __value__ | $800
        .elseif mao = absy
            ldx __value__ | $800, x
        .elseif mao = zp || mao = wabs
            ldx __value__
        .elseif mao = zpy || mao = wabsy
            ldx __value__, y
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

.endmacro

.macro str __typed_reg__, __value__
    .local mao, treg
    detype __typed_reg__, mao

    ; USE HEADER TO DETERMINE ROM SPACE, BLOCK DIRECT STORES INTO ROM

    .if mao = imp || mao = inabs || mao = imm
        .fatal "Invalid Memory Address Mode for Store A/X/Y"
    .endif
    
    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mao = imm || mao = zp || mao = zpx || mao = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = abs
            sta __value__ | $800
        .elseif mao = absy
            sta __value__ | $800, y
        .elseif mao = absx
            sta __value__ | $800, x
        .elseif mao = zp || mao = wabs
            sta __value__
        .elseif mao = zpy || mao = wabsy
            sta __value__, y
        .elseif mao = zpx || mao = wabsx
            sta __value__, x
        .elseif mao = inabsy
            sta [__value__], y
        .elseif mao = inabsx
            sta [__value__, x]
        .endif
    .elseif treg = yr
        .if mao = zpy || mao = wabsy || mao = wabsx || mao = absy || mao = absx || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Store Y"
        .endif

        .if (mao = zp || mao = zpx) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = abs
            sty __value__ | $800
        .elseif mao = zp || mao = wabs
            sty __value__
        .elseif mao = zpx
            sty __value__, x
        .endif
    .elseif treg = xr
        .if mao = zpx || mao = wabsx || mao = wabsy || mao = absx || mao = absy || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Store X"
        .endif

        .if (mao = zp || mao = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = abs
            stx __value__ | $800
        .elseif mao = zp || mao = wabs
            stx __value__
        .elseif mao = zpy
            stx __value__, y
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

    ; block confirmable direct writes to ROM
    .if target >= $8000 && (mao = abs || mao = wabs || mao = absx || mao = absy || mao = wabsy || mao = wabsx)
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
    .local mao, treg
    detype __typed_reg__, mao

    .if mao = imp || mao = inabs
        .fatal "Invalid Memory Address Mode for Compare A/X/Y"
    .endif
    
    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mao = imm || mao = zp || mao = zpx || mao = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            cmp #__value__
            .exitmacro
        .elseif mao = abs
            cmp __value__ | $800
        .elseif mao = absy
            cmp __value__ | $800, y
        .elseif mao = absx
            cmp __value__ | $800, x
        .elseif mao = zp || mao = wabs
            cmp __value__
        .elseif mao = zpy || mao = wabsy
            cmp __value__, y
        .elseif mao = zpx || mao = wabsx
            cmp __value__, x
        .elseif mao = inabsy
            cmp [__value__], y
        .elseif mao = inabsx
            cmp [__value__, x]
        .endif
    .elseif treg = yr
        .if mao = zpy || mao = wabsy || mao = wabsx || mao = absx || mao = zpx || mao = absy || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Compare Y"
        .endif

        .if (mao = imm || mao = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            cpy #__value__
            .exitmacro
        .elseif mao = abs
            cpy __value__ | $800
        .elseif mao = zp || mao = wabs
            cpy __value__
        .endif
    .elseif treg = xr
        .if mao = zpx || mao = wabsx || mao = wabsy || mao = absy || mao = zpy || mao = absx || mao = inabsy || mao = inabsx
            .fatal "Invalid Memory Address Mode for Compare X"
        .endif

        .if (mao = imm || mao = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mao = imm
            cpx #__value__
            .exitmacro
        .elseif mao = abs
            cpx __value__ | $800
        .elseif mao = zp || mao = wabs
            cpx __value__
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

.endmacro