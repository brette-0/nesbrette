.if INCLUDE_SUBTRACTION_IPTR_INIT
    .proc cleaned_subtraction_iptr
        ldx FUNCTION_MATH_SUBTRACTION_WIDTH
        lda #$00
        @clean:
            sta FUNCTION_MATH_SUBTRACTION_OUT, x
            dex
            bne @clean    
        
        .endproc
    .endif
.proc subtraction_iptr
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_SUBTRACTION_ADDER
    Result  = FUNCTION_MATH_SUBTRACTION_OUT
    Width   = FUNCTION_MATH_SUBTRACTION_WIDTH

    .if FUNCTION_MATH_SUBTRACTION_LITTLE_ENDIAN
        ldy #$00
        ldx Width
        
        clc
        @loop:
            lda (Result), y
            adc (Adder),  y
            sta Result, y
            inx
            dex
            bne @loop
    .else
        ldy Width
        clc
        @loop:
            lda (Result), y
            adc (Adder),  y
            sta Result, y
            dey
            bne @loop
    .endif
    rts
    .endproc