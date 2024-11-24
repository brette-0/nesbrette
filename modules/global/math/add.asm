; untested

.macro add __width__
    .local output, width, mod
    output = ADDRESSES_MATH_ADD_OUT
    adder  = ADDRESSES_MATH_ADD_MOD
    .ifblank __width__
        width = CONSTANTS_MATH_ADD_WIDTH
    .else
        width = __width__
    .endif

    .repeat width, iter
        lda output + iter
        adc adder  + iter
        sta output + iter
        .endrepeat
    .endmacro