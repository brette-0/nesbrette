.proc subtraction_ioptr
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_SUBTRACTION_ADDER
    Result  = FUNCTION_MATH_SUBTRACTION_OUT
    Width   = FUNCTION_MATH_SUBTRACTION_WIDTH
    
    .if FUNCTION_MATH_SUBTRACTION_LITTLE_ENDIAN
        ldy #$00
        ldx Width
        
        sec
        @loop:
            lda (Result), y
            sbc (Adder),  y
            sta (Result), y
            inx
            dex
            bne @loop
    .elseif
        ldy Width
        
        sec
        @loop:
            lda (Result), y
            sbc (Adder),  y
            sta (Result), y
            dey
            bne @loop
    .endif
    rts
    .endproc