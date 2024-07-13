.if INCLUDE_SUBTRACTION_INIT
    .proc cleaned_subtraction
        ldx FUNCTION_MATH_SUBTRACTION_WIDTH
        lda #$00
        @clean:
            sta FUNCTION_MATH_SUBTRACTION_OUT, x
            dex
            bne @clean
        ; leaks into SUBTRACTION
        .endproc
    .endif
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