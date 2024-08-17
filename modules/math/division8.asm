.proc divide8

    divisor     = FUNCTION_MATH_DIVISION_MODIFIER
    dividend    = FUNCTION_MATH_DIVISION_DIVIDEND
    quotient    = FUNCTION_MATH_DIVISION_QUOTIENT
    remainder   = FUNCTION_MATH_DIVISION_REMAINDER

    ldy #$00
    ldx $00
    lda (dividend), y
    
    sec
    @loop:
        sbc (divisor), y
        inx
        bcs @loop
    adc (divisor), y
    dex

    ; x = quotient
    ; a = remainder
    ; (dividend) holds dividend

    .if FEATURE_MATH_SIMPLIFY_INTEGRAL_DIVISION
        temp = FUNCTION_MATH_DIVISION_FMASID
        stx temp
        
        clc
        @optimise:
           lsr temp
           bcs @exit
           lsr
           bcc @optimise
           asl
        @exit:
            asl temp    
        ldx temp 
    .endif
    rts
    .endproc