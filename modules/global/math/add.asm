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

    .if istyped __output__
        .out "Alpha"
        outtype .set type __output__
        .if !outtype
            outtype .set itype __output__
        .endif

        .if !(isoutnum && isoutconst)
            .fatal "Addition requires output to int type"
        .endif
    .else
        outtype .set width __output__
    .endif

    .if istyped __mod__
        .out "Alpha"
        modtype .set type __mod__
        .if !modtype
            modtype .set itype __mod__
        .endif

        .if !(ismodnum && ismodconst)
            .fatal "Addition requires modifier to int type"
        .endif
    .else
        modtype .set width __mod__
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