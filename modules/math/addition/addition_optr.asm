.if INCLUDE_ADDITION_OPTR_INIT
    .proc cleaned_addition_optr
        ldy Width
        lda #<FUNCTION_MATH_ADDITION_OUT
        sta $00
        lda #>FUNCTION_MATH_ADDITION_OUT
        sta $01

        @clean:
            sta ($00), y
            dey
            bne @clean    
        
        .endproc
    .endif
.proc addition_optr
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
            lda Result, y
            adc Adder,  y
            sta (Result), y
            inx
            dex
            bne @loop
    .elseif
        ldy Width
        
        clc
        @loop:
            lda Result, y
            adc Adder,  y
            sta (Result), y
            dey
            bne @loop
    .endif
    rts
    .endproc