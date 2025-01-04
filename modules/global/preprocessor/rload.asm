.macro rload __reg__ __mode__ __value__
    .if __reg__ = a + x
        .if __mode__ = immediate
            .ifndef laxi
                .fatal "lax immediate is unstable, include synthetic instructions"
            .endif
            laxi __value__
        .elseif __mode__ = indirect_indexed && value < $100
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lax (__value__), y 
        .elseif __mode__ = indexed_indirect && value < $100
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lax (__value__, x)
        .elseif __mode__ = absolute_x
            .fatal "there exists no instruction with lax behavior with x register addressing"
        .elseif __mode__ = absolute_y
            .if (__value__ < $100)
                lax (__value__ | $800), y
            .else
                lax __value__, y
            .endif
        .elseif __mode__ = absolute
            .if (__value__ < $100)
                lax (__value__ | $800)
            .else
                lax __value__
            .endif
        .elseif __mode__ = zp_x
            .fatal "there exists no instruction with lax behavior with x register addressing"
        .elseif __mode__ = zp_y
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lax __value__, y
        .elseif __mode__ = zp
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lax __value__, x
        .else
            .fatal "memory addressing mode unknown"
        .endif
    .elseif __reg__ = a
        .if __mode__ = immediate
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda #__value__
        .elseif __mode__ = indirect_indexed && value < $100
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda (__value__), y 
        .elseif __mode__ = indexed_indirect && value < $100
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda (__value__, x)
        .elseif __mode__ = absolute_x
            .if (__value__ < $100)
                lda (__value__ | $800), x
            .else
                lda __value__, x
            .endif
        .elseif __mode__ = absolute_y
            .if (__value__ < $100)
                lda (__value__ | $800), y
            .else
                lda __value__, y
            .endif
        .elseif __mode__ = absolute
            .if (__value__ < $100)
                lda (__value__ | $800)
            .else
                lda __value__
            .endif
        .elseif __mode__ = zp_x
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda __value__, x
        .elseif __mode__ = zp_y
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda __value__, y
        .elseif __mode__ = zp
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            lda __value__, x
        .else
            .fatal "memory addressing mode unknown"
        .endif
    .elseif __reg__ = x
        .if __mode__ = immediate
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldx #__value__
        .elseif __mode__ = indirect_indexed && value < $100
            .fatal "there exists no instruction with ldx behavior with indirect addressing"
        .elseif __mode__ = indexed_indirect && value < $100
            .fatal "there exists no instruction with ldx behavior with indirect addressing"
        .elseif __mode__ = absolute_x
            .fatal "there exists no instruction with ldx behavior with x register addressing"
        .elseif __mode__ = absolute_y
            .if (__value__ < $100)
                ldx (__value__ | $800), y
            .else
                ldx __value__, y
            .endif
        .elseif __mode__ = absolute
            .if (__value__ < $100)
                ldx (__value__ | $800)
            .else
                ldx __value__
            .endif
        .elseif __mode__ = zp_x
            .fatal "there exists no instruction with ldx behavior with x register addressing"
        .elseif __mode__ = zp_y
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldx __value__, y
        .elseif __mode__ = zp
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldx __value__, x
        .else
            .fatal "memory addressing mode unknown"
        .endif
    .elseif __reg__ = y
        .if __mode__ = immediate
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldy #__value__
        .elseif __mode__ = indirect_indexed && value < $100
            .fatal "there exists no instruction with ldy behavior with indirect addressing"
        .elseif __mode__ = indexed_indirect && value < $100
            .fatal "there exists no instruction with ldy behavior with indirect addressing"
        .elseif __mode__ = absolute_y
            .fatal "there exists no instruction with ldy behavior with y register addressing"
        .elseif __mode__ = absolute_x
            .if (__value__ < $100)
                ldy (__value__ | $800), x
            .else
                ldy __value__, x
            .endif
        .elseif __mode__ = absolute
            .if (__value__ < $100)
                ldy (__value__ | $800)
            .else
                ldy __value__
            .endif
        .elseif __mode__ = zp_y
            .fatal "there exists no instruction with ldy behavior with y register addressing"
        .elseif __mode__ = zp_x
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldy __value__, x
        .elseif __mode__ = zp
            .if __value__ > $ff
                .fatal "This operand can only handle 1 byte as operand"
            .endif
            ldy __value__, x
        .else
            .fatal "memory addressing mode unknown"
        .endif
    .else
        .fatal "registers unknown"
    .endif

    .endmacro