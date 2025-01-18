; untested

.macro add __output__, __mod__
    .local skip, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel
    
    isoutnum    = isnum __output__
    isoutconst  = isconst __output__

    ismodnum    = isnum __mod__
    ismodconst  = isconst __mod__

    olabel      = ilabel __output__
    mlabel      = ilabel __mod__

    modtype     .set type __mod__
    outtype     .set type __output__
    
    .if !outtype
        outtype .set width __output__
    .elseif !(isoutnum && isoutconst)
        .fatal "Addition requires output to int type"
    .endif

    .if !modtype
        modtype .set width __mod__
    .elseif !(ismodnum && ismodconst)
        .fatal "Addition requires modifier to be int type"
    .endif

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