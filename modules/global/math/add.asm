; untested

.macro add __output__, __mod__
    .local skip, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel
    
    isoutnum    = isnum __output__
    isoutconst  = isconst __output__

    ismodnum    = isnum __mod__
    ismodconst  = isconst __mod__

    olabel      .set ilabel __output__
    mlabel      .set ilabel __mod__

    modtype     .set type __mod__
    outtype     .set type __output__

    detype __output__, outtype
    detype __mod__,    modtype

    .out .sprintf("%d", outtype)
    .out .sprintf("%d", modtype)

    ; core
    .repeat modtype, iter
        lda olabel + iter
        adc mlabel + iter
        sta olabel + iter
    .endrepeat

    .if outtype > modtype
        bcc @skip
        inc olabel + outtype - 1
        @skip:
    .endif
    .endmacro