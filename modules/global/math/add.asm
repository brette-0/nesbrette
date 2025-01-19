; tested

.macro add __output__, __mod__
    .local skip, ahead, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel
    
    isoutnum    = isnum __output__
    isoutconst  = isconst __output__

    ismodnum    = isnum __mod__
    ismodconst  = isconst __mod__

    olabel      .set ilabel __output__
    mlabel      .set ilabel __mod__

    detype __output__, outtype
    detype __mod__,    modtype

    modwidth     = modtype & ((1 << 30) -1)
    outwidth     = outtype & ((1 << 30) -1)

    ; core
    .repeat modwidth, iter
        lda olabel + iter
        adc mlabel + iter
        sta olabel + iter
    .endrepeat

    .if outwidth > modwidth
        bcc @skip
        inc olabel + modwidth
        @skip:
    .endif

    ; if types are of differing size and the type of the modifier is signed
    ismodsign = signed modtype
    .if ismodsign && outwidth <> modwidth
        lda mlabel + modwidth - 1   ; load final (highest) byte of mod
        bpl @ahead                  ; if positive, value was positive, no need to adjust
            ; if the difference is greater than 1, we have 'borrow' logic to consider
            .if (outwidth - modwidth) > 1
                clc
                .repeat outwidth - modwidth - 1, iter
                    lda olabel + modwidth + iter
                    sbc #$00
                    sta olabel + modwidth + iter
                    bcs @ahead
                .endrepeat

                ; since the last permutation would end in a bra condition, we can flesh this out optimally
                lda olabel + outwidth - 1
                sbc #$00
                sta olabel + outwidth - 1
            .else
                ; where the difference is one, there is nowhere to borrow from
                dec olabel + modwidth
            .endif
        @ahead:
    .endif
.endmacro