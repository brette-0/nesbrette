.macro __add__body outtype, olabel, outwidth, modtype, mlabel, modwidth
    ; core
    .repeat modwidth, iter
        lda eindex olabel, outwidth, iter, endian outtype
        adc eindex mlabel, modwidth, iter, endian modtype
        sta eindex olabel, outwidth, iter, endian outtype
    .endrepeat

    .if outwidth > modwidth
        bcc @skip
        inc eindex olabel, outwidth, modwidth, endian outtype
        @skip:
    .endif

    ; if types are of differing size and the type of the modifier is signed
    .if (outwidth <> modwidth) && signed modtype
        ; load final (highest) byte of mod
        lda eindex mlabel, modwidth, (modwidth - 1), endian modtype
        bpl @ahead                  ; if positive, value was positive, no need to adjust
            ; if the difference is greater than 1, we have 'borrow' logic to consider
            .if (outwidth - modwidth) > 1
                clc
                .repeat outwidth - modwidth - 1, iter
                    lda eindex olabel, outwidth, (modwidth + iter), endian outtype
                    sbc #$00
                    sta eindex olabel, outwidth, (modwidth + iter), endian outtype
                    bcs @ahead
                .endrepeat
            .endif

            ; since the last permutation would end in a bra condition, we can flesh this out optimally
            dec eindex olabel, outwidth, (outwidth - 1), endian outtype
        @ahead:
    .endif
.endmacro

.macro __sub__body outtype, olabel, outwidth, modtype, mlabel, modwidth
    ; core
    .repeat modwidth, iter
        lda eindex olabel, outwidth, iter, endian outtype
        sbc eindex mlabel, modwidth, iter, endian modtype
        sta eindex olabel, outwidth, iter, endian outtype
    .endrepeat

    .if outwidth > modwidth
        bcc @skip
        dec eindex olabel, outwidth, modwidth, endian outtype
        @skip:
    .endif

    ; if types are of differing size and the type of the modifier is signed
    .if (outwidth <> modwidth) && signed modtype
        ; load final (highest) byte of mod
        lda eindex mlabel, modwidth, (modwidth - 1), endian modtype
        bpl @ahead                  ; if positive, value was positive, no need to adjust
            ; if the difference is greater than 1, we have 'borrow' logic to consider
            .if (outwidth - modwidth) > 1
                sec
                .repeat outwidth - modwidth - 1, iter
                    lda eindex olabel, outwidth, (modwidth + iter), endian outtype
                    adc #$00
                    sta eindex olabel, outwidth, (modwidth + iter), endian outtype
                    bcc @ahead
                .endrepeat
            .endif

            ; since the last permutation would end in a bra condition, we can flesh this out optimally
            inc eindex olabel, outwidth, (outwidth - 1), endian outtype
        @ahead:
    .endif
.endmacro

.macro add __output__, __mod__
    .local skip, ahead, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel

    .ifblank __output__
        .fatal "Add requires output to be typed and specified"
    .endif

    .ifblank __mod__
        .fatal "Add requires modifier to be typed and specified"
    .endif

    .if is_null __output__
        .fatal "Add requires output to have real type"
    .endif

    .if is_null __mod__
        .fatal "Add requires modifier to have real type"
    .endif

    olabel      .set ilabel __output__
    mlabel      .set ilabel __mod__

    detype __output__, outtype
    detype __mod__,    modtype

    modwidth     = modtype & $7ff
    outwidth     = outtype & $7ff

    __add__body outtype, olabel, outwidth, modtype, mlabel, modwidth
.endmacro

.macro __add__body outtype, olabel, outwidth, modtype, mlabel, modwidth
    ; core
    .repeat modwidth, iter
        lda eindex olabel, outwidth, iter, endian outtype
        adc eindex mlabel, modwidth, iter, endian modtype
        sta eindex olabel, outwidth, iter, endian outtype
    .endrepeat

    .if outwidth > modwidth
        bcc @skip
        inc eindex olabel, outwidth, modwidth, endian outtype
        @skip:
    .endif

    ; if types are of differing size and the type of the modifier is signed
    .if (outwidth <> modwidth) && signed modtype
        ; load final (highest) byte of mod
        lda eindex mlabel, modwidth, (modwidth - 1), endian modtype
        bpl @ahead                  ; if positive, value was positive, no need to adjust
            ; if the difference is greater than 1, we have 'borrow' logic to consider
            .if (outwidth - modwidth) > 1
                clc
                .repeat outwidth - modwidth - 1, iter
                    lda eindex olabel, outwidth, (modwidth + iter), endian outtype
                    sbc #$00
                    sta eindex olabel, outwidth, (modwidth + iter), endian outtype
                    bcs @ahead
                .endrepeat
            .endif

            ; since the last permutation would end in a bra condition, we can flesh this out optimally
            dec eindex olabel, outwidth, (outwidth - 1), endian outtype
        @ahead:
    .endif
.endmacro

.macro sub __output__, __mod__
    .local skip, ahead, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel

    .ifblank __output__
        .fatal "Sub requires output to be typed and specified"
    .endif

    .ifblank __mod__
        .fatal "Sub requires modifier to be typed and specified"
    .endif

    .if is_null __output__
        .fatal "Sub requires output to have real type"
    .endif

    .if is_null __mod__
        .fatal "Sub requires modifier to have real type"
    .endif

    olabel      .set ilabel __output__
    mlabel      .set ilabel __mod__

    detype __output__, outtype
    detype __mod__,    modtype

    modwidth     = modtype & $7ff
    outwidth     = outtype & $7ff

    __sub__body outtype, olabel, outwidth, modtype, mlabel, modwidth
.endmacro