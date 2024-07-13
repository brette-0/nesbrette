.proc addition_ioptr
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_ADDITION_ADDER
    Result  = FUNCTION_MATH_ADDITION_OUT
    Width   = FUNCTION_MATH_ADDITION_WIDTH

    .if FUNCTION_MATH_ADDITION_LITTLE_ENDIAN
        ldy #$00
        ldx Width
        
        clc
        @loop:
            lda (Result), y
            adc (Adder),  y
            sta (Result), y
            inx
            dex
            bne @loop
    .elseif
        ldy Width
        
        clc
        @loop:
            lda (Result), y
            adc (Adder),  y
            sta (Result), y
            dey
            bne @loop
    .endif
    rts
    .endproc