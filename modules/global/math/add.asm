; sign untested

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

    modwidth     = modtype & $7ff
    outwidth     = outtype & $7ff

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
            .endif

            .repeat outwidth - modwidth - 1, iter
                lda eindex olabel, outwidth, (modwidth + iter), endian outtype
                sbc #$00
                sta eindex olabel, outwidth, (modwidth + iter), endian outtype
                bcs @ahead
            .endrepeat

            ; since the last permutation would end in a bra condition, we can flesh this out optimally
            dec eindex olabel, outwidth, (outwidth - 1), endian outtype
        @ahead:
    .endif
.endmacro