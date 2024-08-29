; 64byte
.proc multiply
    ; this routine *expects* a 16bit divisor/quotient/remainder to result from singular byte math
    ; all values below will need to be 16bit at least
    ; however, temps will need to be 32bit at least

    ; width will need to be a nonzero multiple of 2bytes


    ;   (8 + 8/8) / (8 + 8/8)
    ;   (16/8) / (16/8)
    ;   (16) * (8/16)
    ;   32/16
    ;   16 + 16/16

    o_quotient  =
    o_remainder =
    o_divisor   = 

    a_quotient  =
    a_remainder =
    a_divisor   = 

    temp        = FUNCTION_MATH_FRACTION_MULTIPLY_TEMP          ; 2w
    temp_1      = FUNCTION_MATH_FRACTION_MULTIPLY_TEMP1         ; 2w
    temp_2      = FUNCTION_MATH_FRACTION_MULTIPLY_TEMP2         ; 2w
    temp_3      = FUNCTION_MATH_FRACTION_MULTIPLY_TEMP3         ; 4w
    width       = 

    ldy width
    ; wrap together
    __memcpy__ o_quotient temp
    __memcpy__ a_quotient temp_1

    
    ; wrap together
    copyaddr temp           FUNCTION_MATH_MULTIPLICATION_OUTPUT
    copyaddr temp           FUNCTION_MATH_ADDITION_OUTPUT
    copyaddr o_divisor      FUNCTION_MATH_MULTIPLICATION_MULTIPLIER
    copyaddr o_remainder    FUNCITON_MATH_ADDITION_ADDER
    jsr math::multiply
    jsr math::addition

    copyaddr temp_1         FUNCTION_MATH_MULTIPLICATION_OUTPUT
    copyaddr temp_1         FUNCTION_MATH_ADDITION_OUTPUT
    copyaddr a_divisor      FUNCTION_MATH_MULTIPLICATION_MULTIPLIER
    copyaddr a_remainder    FUNCITON_MATH_ADDITION_ADDER
    jsr math::multiply
    jsr math::addition

    copy o_divisor temp_2
    copyaddr a_divisor FUNCTION_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiply


    asl FUNCITON_MATH_MULTIPLICATION_WIDTH
    copy temp temp_3
    copyaddr temp_1    FUNCTION_MATH_MULTIPLICATION_MULTIPLIER
    jsr math::multiply
    lsr FUNCITON_MATH_MULTIPLICATION_WIDTH
    
    ; intdiv to simplfify u32/u16

    copyaddr temp_3 FUNCTION_MATH_DIVISION_DIVIDEND
    copyaddr temp_2 FUNCTION_MATH_DIVISION_DIVISOR

    jsr math::divide

    copyaddr FUNCTION_MATH_DIVISION_QUOTIENT    FUNCTION_MATH_FRACTION_MULTIPLY_OUT
    copyaddr FUNCTION_MATH_DIVISION_REMAINDER   FUNCTION_MATH_FRACTION_MULTIPLY_REMAINDER
    copyaddr FUNCTION_MATH_DIVISION_DIVISOR     FUNCTION_MATH_FRACITON_MULTIPLY_DIVISOR
    
    rts
    .endproc