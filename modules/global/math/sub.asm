; untested

.macro sub __width__, __output__, __mod__
    .local output, width, mod

    .ifblank __output__
        output  = ADDRESSES_MATH_SUB_OUT
    .else
        output  = __output__
    .endif

    .ifblank __mod__
        mod     = ADDRESSES_MATH_SUB_MOD
    .else
        mod     = __mod__
    .endif

    .ifblank __width__
        width = CONSTANTS_MATH_SUB_WIDTH
    .else
        width = __width__
    .endif

    .repeat width, iter
        lda output + iter
        sbc mod    + iter
        sta output + iter
        .endrepeat
    .endmacro