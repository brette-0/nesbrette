.proc addition
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_ADDITION_ADDER
    Result  = FUNCTION_MATH_ADDITION_OUT
    Width   = FUNCTION_MATH_ADDITION_WIDTH
    
    .if FUNCTION_MATH_ADDITION_LITTLE_ENDIAN
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