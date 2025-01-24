.macro add __params__
    ; entrypoint call handler for addition (splits : typed, notype)

    ; only if types exist, attempt type decoding
    .if .not INCLUDES_NESBRETTE_PREPROCESSOR_TYPING
        __add__notyping {__params__}    ; parse packed parameters
        .exitmacro
    .endif

    ; unpack parameters
    __output__ = index(__params__, 0)
    __mod__    = index(__params__, 1)

    .local skip, ahead, isoutconst, isoutnum, ismodconst, ismodnum, modtype, outtype, olabel, mlabel
    
    isoutnum    = isnum __output__
    isoutconst  = isconst __output__

    ismodnum    = isnum __mod__
    ismodconst  = isconst __mod__

    olabel      .set ilabel __output__
    mlabel      .set ilabel __mod__

    detype __output__, outtype
    detype __mod__,    modtype

    modwidth     = typeval modtype
    outwidth     = typeval outtype

    __add__body {olabel, mlabel, outwidth, modwidth, signed modtype, endian outtype, endian modtype}
    .exitmacro

.macro __add__body __params__
    ; core (add)

    ; parameter unpacking
    olabel   = index(__params__, 0)
    mlabel   = index(__params__, 1)
    outwidth = index(__params__, 2)
    modwidth = index(__params__, 3)
    modsign  = index(__params__, 4)
    oendian  = index(__params__, 5)
    mendian  = index(__params__, 6)
    

    .repeat modwidth, iter
        lda eindex olabel, outwidth, iter, oendian
        adc eindex mlabel, modwidth, iter, mendian
        sta eindex olabel, outwidth, iter, oendian
    .endrepeat

    .if outwidth > modwidth
        bcc @skip
        inc eindex olabel, outwidth, modwidth, oendian
        @skip:
    .endif

    ; if types are of differing size and the type of the modifier is signed
    .if (outwidth <> modwidth) && modsign
        ; load final (highest) byte of mod
        lda eindex mlabel, modwidth, (modwidth - 1), mendian
        bpl @ahead                  ; if positive, value was positive, no need to adjust
            ; if the difference is greater than 1, we have 'borrow' logic to consider
            .if (outwidth - modwidth) > 1
                clc
                .repeat outwidth - modwidth - 1, iter
                    lda eindex olabel, outwidth, (modwidth + iter), oendian
                    sbc #$00
                    sta eindex olabel, outwidth, (modwidth + iter), oendian
                    bcs @ahead
                .endrepeat
            .endif

            ; since the last permutation would end in a bra condition, we can flesh this out optimally
            dec eindex olabel, outwidth, (outwidth - 1), oendian
        @ahead:
    .endif
.endmacro


.if __add__notyping __output__, __osize__, __modifier__, __msize__, __oendian__, __mendian__, __msign__
    .ifblank __oendian__
        __oendian__ = 0
        __mendian__ = 0
        __osign__   = 0
        __msign__   = 0
    .elseif .ifblank(__mendian__)
        __mendian__ = 0
        __osign__   = 0
        __msign__   = 0
    .elseif .ifblank(__osign__)
        __osign__   = 0
        __msign__   = 0
    .elseif .ifblank(__msign__)
        __msign__   = 0
    .endif

    __add__body {__output__, __osize__, __modifier__, __msign__, __msign__, __oendian__, __mendian__}
.endif