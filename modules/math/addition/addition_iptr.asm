.if INCLUDE_ADDITION_IPTR_INIT
    .proc cleaned_addition_iptr
        ldx Width
        lda #$00
        @clean:
            sta Result, x
            dex
            bne @clean    
        
        .endproc
    .endif
.proc addition_iptr
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