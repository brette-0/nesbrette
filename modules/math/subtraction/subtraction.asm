.proc subtraction
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_SUBTRACTION_ADDER
    Result  = FUNCTION_MATH_SUBTRACTION_OUT
    Width   = FUNCTION_MATH_SUBTRACTION_WIDTH
    
    .if FUNCTION_MATH_SUBTRACTION_LITTLE_ENDIAN
        ldx #$00
        ldy Width
        
        clc
        @loop:
            lda Result, x
            adc Adder,  x
            sta Result, x
            inx
            dey
            bne @loop
    .else
        ldx Width
        clc
        @loop:
            lda Result, x
            adc Adder,  x 
            sta Result, x
            dex
            bne @loop
    .endif
    rts
    .endproc