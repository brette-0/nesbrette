; untested

.macro sub __width__
    output = ADDRESSES_MATH_SUB_OUT
    sub    = ADDRESSES_MATH_SUB_MOD
    .ifblank __width__
        width = CONSTANTS_MATH_SUB_WIDTH
    .else
        width = __width__
    .endif

    .repeat iter, width
        lda output + iter
        sbc sub    + iter
        sta output + iter
        .endrepeat
    .endmacro