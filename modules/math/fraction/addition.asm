.proc addition

    ; fracts should be half the size of int types (structs will use full int size types for temporaries)
    ; support max 8 byte divisors/dividents (256bit)
    ; depends on:
        
        ; math::addition
        ; math::multiplication
        ; math::division

    ; returns
        ; FUNCTION_MATH_FRACTION_ADDITION_OUTPU
        ; FUNCTION_MATH_FRACTION_ADDITION_O_FRAC
        ; FUNCTION_MATH_FRACTION_ADDITION_DIVISOR

    output  = FUNCTION_MATH_FRACTION_ADDITION_OUTPUT    ; ioptr
    o_frac  = FUNCTION_MATH_FRACTION_ADDITION_O_FRAC    ; ioptr
    o_div   = FUNCTION_MATH_FRACTION_ADDITION_DIVISOR   ; ioptr

    adder   = FUNCTION_MATH_FRACTION_ADDITION_ADDER     ; ioptr
    a_frac  = FUNCTION_MATH_FRACTION_ADDITION_A_FRAC    ; ioptr
    a_div   = FUNCTION_MATH_FRACTION_ADDITION_ADIVISOR  ; ioptr

    temp    = FUNCTION_MATH_FRACTION_ADDITION_TEMP      ; ioptr
    temp_1  = FUNCTION_MATH_FRACTION_ADDITION_TEMP+2    ; ioptr
    
    width   = FUNCTION_MATH_FRACTION_ADDITION_WIDTH     ; zp/abs
    
    ldx width
    ; nest these together instead of macro
    copy o_frac temp
    copy a_frac temp_1

    copyaddr temp FUNCITON_MATH_MULTIPLICATION_OUT
    copyaddr a_div FUNCITON_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiplication
    copyaddr temp_1 FUNCITON_MATH_MULTIPLICATION_OUT
    copyaddr o_div FUNCITON_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiplication
    copyaddr temp FUNCTION_MATH_ADDITION_OUT
    copyaddr temp_1 FUNCTION_MATH_ADDITION_MODIFIER
    jsr math::addition
    copyaddr o_div FUNCITON_MATH_MULTIPLICATION_OUT
    copyaddr a_div FUNCITON_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiplication
    copyaddr output FUNCTION_MATH_ADDITION_OUT
    copyaddr adder FUNCTION_MATH_ADDITION_MODIFIER
    jsr math::addition
    copyaddr temp FUNCTION_MATH_DIVISION_DIVIDEND
    copyaddr temp FUNCTION_MATH_DIVISION_DIVISOR
    jsr math::division
    copyaddr FUNCTION_MATH_DIVISION_QUOTIENT FUNCTION_MATH_DIVISION_MODIFIER
    jsr math::addition

    ldx width
    copy FUNCTION_MATH_DIVISION_REMAINDER o_frac
    ldx width
    dex
    txa
    lsr
    sta temp
    tay
    @scan:
        lda FUNCTION_MATH_DIVISION_REMAINDER, y
        bne @exit
        iny
        cpy width
        bne @scan
        rts

    @exit:
        tya
        sec
        sbc temp
        bcs @simplify
        rts

    @simplify:
        .if FUNCTION_MATH_FRACTION_FEATURE_EXTERNAL_SIMPLIFY
            bit FUNCTION_FLAGS
            bmi @_leave
            bvs @_continue
            @_leave:
            rts
            @_continue:
        .endif
        ldx width
        __clear__ FUNCTION_LOGIC_RSHIFT_MODIFIER

        copyaddr FUNCTION_MATH_DIVISION_REMAINDER FUNCTION_LOGIC_RSHIFT_OUTPUT
        jsr logic::rshift
        copyaddr FUNCTION_MATH_DIVISION_DIVISOR FUNCTION_LOGIC_RSHIFT_OUTPUT
        jsr logic::rshift
        rts
    .endproc