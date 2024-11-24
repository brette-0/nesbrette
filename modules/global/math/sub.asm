; untested

.macro sub __width__
    .local output, width, mod
    output = ADDRESSES_MATH_SUB_OUT
    mod    = ADDRESSES_MATH_SUB_MOD
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