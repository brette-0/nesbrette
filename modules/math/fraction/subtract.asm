.proc subtraction

    ; fracts should be half the size of int types (structs will use full int size types for temporaries)
    ; support max 8 byte divisors/dividents (256bit)
    ; depends on:
        
        ; math::subtraction
        ; math::multiplication
        ; math::division

    ; returns
        ; FUNCTION_MATH_FRACTION_SUBTRACTION_OUTPU
        ; FUNCTION_MATH_FRACTION_SUBTRACTION_O_FRAC
        ; FUNCTION_MATH_FRACTION_SUBTRACTION_DIVISOR

    output  = FUNCTION_MATH_FRACTION_SUBTRACTION_OUTPUT    ; ioptr
    o_frac  = FUNCTION_MATH_FRACTION_SUBTRACTION_O_FRAC    ; ioptr
    o_div   = FUNCTION_MATH_FRACTION_SUBTRACTION_DIVISOR   ; ioptr

    adder   = FUNCTION_MATH_FRACTION_SUBTRACTION_ADDER     ; ioptr
    a_frac  = FUNCTION_MATH_FRACTION_SUBTRACTION_A_FRAC    ; ioptr
    a_div   = FUNCTION_MATH_FRACTION_SUBTRACTION_ADIVISOR  ; ioptr

    temp    = FUNCTION_MATH_FRACTION_SUBTRACTION_TEMP      ; ioptr
    temp_1  = FUNCTION_MATH_FRACTION_SUBTRACTION_TEMP+2    ; ioptr
    
    width   = FUNCTION_MATH_FRACTION_SUBTRACTION_WIDTH     ; zp/abs
    
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
    copyaddr temp FUNCTION_MATH_SUBTRACTION_OUT
    copyaddr temp_1 FUNCTION_MATH_SUBTRACTION_MODIFIER
    jsr math::SUBTRACTION
    copyaddr o_div FUNCITON_MATH_MULTIPLICATION_OUT
    copyaddr a_div FUNCITON_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiplication
    copyaddr output FUNCTION_MATH_SUBTRACTION_OUT
    copyaddr adder FUNCTION_MATH_SUBTRACTION_MODIFIER
    jsr math::SUBTRACTION
    copyaddr temp FUNCTION_MATH_DIVISION_DIVIDEND
    copyaddr temp FUNCTION_MATH_DIVISION_DIVISOR
    jsr math::division
    copyaddr FUNCTION_MATH_DIVISION_QUOTIENT FUNCTION_MATH_DIVISION_MODIFIER
    jsr math::SUBTRACTION

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
        
        ldx width
        __clear__ FUNCTION_LOGIC_RSHIFT_MODIFIER
        
        
        .if FEATURE_FUNCTION_MATH_FRACTION_SUBTRACTION_APO2MOD
            lax width
            dex
            and #~$03
            tay
            txa
            and #$03
            tax
            lda #$01
            xrshift
            sta FUNCTION_LOGIC_RSHIFT_MODIFIER, y
        .else
            ldx width
            dex
            lda #$01
            sta FUNCTION_LOGIC_RSHIFT_MODIFIER, x
        .endif

        copyaddr FUNCTION_MATH_DIVISION_REMAINDER FUNCTION_LOGIC_RSHIFT_OUTPUT
        jsr logic::rshift
        copyaddr FUNCTION_MATH_DIVISION_DIVISOR FUNCTION_LOGIC_RSHIFT_OUTPUT
        jsr logic::rshift
        rts
    .endproc