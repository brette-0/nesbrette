; uncertain
.macro ld __typed_reg__, value
    .if xmatch(.left(1, __typed_reg__), A)
        .if xmatch(.right(1, __typed_reg__), i)
            lda #value
        .elseif xmatch(.right(1, __typed_reg__), zp)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lda value
        .elseif xmatch(.right(1, __typed_reg__), wabs)
            lda value
        .elseif xmatch(.right(1, __typed_reg__), abs)
            lda (value | $800)
        .elseif xmatch(.right(1, __typed_reg__), zpx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lda value, x
        .elseif xmatch(.right(1, __typed_reg__), zpy)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lda value, y
        .elseif xmatch(.right(1, __typed_reg__), wabsx)
            lda value, x
        .elseif xmatch(.right(1, __typed_reg__), wabsy)
            lda value, y
        .elseif xmatch(.right(1, __typed_reg__), absx)
            lda (value | $800), x
        .elseif xmatch(.right(1, __typed_reg__), absy)
            lda (value | $800), y
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lda (value, x)
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lda (value), y
        .else
            .fatal "Unknown Memory Address Mode"
        .endif
    .elseif xmatch(.left(1, __typed_reg__), X)
        .if xmatch(.right(1, __typed_reg__), i)
            ldx #value
        .elseif xmatch(.right(1, __typed_reg__), zp)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            ldx value
        .elseif xmatch(.right(1, __typed_reg__), wabs)
            ldx value
        .elseif xmatch(.right(1, __typed_reg__), abs)
            ldx (value | $800)
        .elseif xmatch(.right(1, __typed_reg__), zpx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), zpy)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            ldx value, y
        .elseif xmatch(.right(1, __typed_reg__), wabsx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), wabsy)
            ldx value, y
        .elseif xmatch(.right(1, __typed_reg__), absx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), absy)
            ldx (value | $800), y
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .fatal "Unknown Memory Address Mode"
        .else
            .fatal "Unknown Memory Address Mode"
        .endif
    .elseif xmatch(.left(1, __typed_reg__), Y)
        .if xmatch(.right(1, __typed_reg__), i)
            ldy #value
        .elseif xmatch(.right(1, __typed_reg__), zp)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            ldy value
        .elseif xmatch(.right(1, __typed_reg__), wabs)
            ldy value
        .elseif xmatch(.right(1, __typed_reg__), abs)
            ldy (value | $800)
        .elseif xmatch(.right(1, __typed_reg__), zpx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            ldy value, x
        .elseif xmatch(.right(1, __typed_reg__), zpy)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), wabsx)
            ldy value, x
        .elseif xmatch(.right(1, __typed_reg__), wabsy)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), absx)
            ldy (value | $800), x
        .elseif xmatch(.right(1, __typed_reg__), absy)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .fatal "Unknown Memory Address Mode"
        .else
            .fatal "Unknown Memory Address Mode"
        .endif
    .elseif xmatch(.left(1, __typed_reg__), AX)
        .if xmatch(.left(1, __typed_reg__), A)
        .if xmatch(.right(1, __typed_reg__), i)
            laxi value
        .elseif xmatch(.right(1, __typed_reg__), zp)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lax value
        .elseif xmatch(.right(1, __typed_reg__), wabs)
            lax value
        .elseif xmatch(.right(1, __typed_reg__), abs)
            lax (value | $800)
        .elseif xmatch(.right(1, __typed_reg__), zpx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), zpy)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lax value, y
        .elseif xmatch(.right(1, __typed_reg__), wabsx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), wabsy)
            lax value, y
        .elseif xmatch(.right(1, __typed_reg__), absx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), absy)
            lax (value | $800), y
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .fatal "Unknown Memory Address Mode"
        .elseif xmatch(.right(1, __typed_reg__), indx)
            .if (value > $ff)
                .fatal "Target is not Zeropage"
            .endif
            lax (value), y
        .else
            .fatal "Unknown Memory Address Mode"
        .endif
    .else
        .fatal "No valid register provided"
    .endif
.endmacro