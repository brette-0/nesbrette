; untested

.macro add __output__, __mod__
    .local skip, isoutconst, isoutnum, ismodconst, ismodnum

    ; type validation

    isoutnum    = isnum __output__
    isoutconst  = isconst __output__

    ismodnum    = isnum __mod__
    ismodconst  = isconst __mod__

    modtype     = type __mod__
    outtype     = type __output__

    .if !(isoutnum && isoutconst)
        .fatal "Addition requires output to int type"
    .elseif !(ismodnum && ismodconst)
        .fatal "Addition requires modifier to be int type"
    .endif

    olabel = ilabel __output__
    mlabel = ilabel __mod__

    ; core
    .repeat type __mod__ >> 1, iter
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