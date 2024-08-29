.proc divide

    divisor     = FUNCTION_MATH_DIVISION_MODIFIER
    dividend    = FUNCTION_MATH_DIVISION_DIVIDEND
    quotient    = FUNCTION_MATH_DIVISION_QUOTIENT
    remainder   = FUNCTION_MATH_DIVISION_REMAINDER

    width       = FUNCTION_MATH_DIVISION_WIDTH

    ldy #$00
    ldx $00
    lda (dividend), y
    
    sec
    @loop:
        ; point divisor
        jsr math::subtraction
        inx
        bcs @loop
    ; point divisor?
    jsr math::addition
    dex

    rts
    .endproc