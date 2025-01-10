; untested

.macro add __width__, __output__, __mod__
    .local output, width, mod
    .ifblank __output__
        output  = ADDRESSES_MATH_ADD_OUT
    .else
        output  = __output__
    .endif
    
    .ifblank __mod__
        adder   = ADDRESSES_MATH_ADD_MOD
    .else
        adder   = __mod__
    .endif

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