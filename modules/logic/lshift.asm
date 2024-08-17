.proc rshift

    output = FUNCTION_LOGIC_RSHIFT_OUTPUT       ; ioptr
    modifier = FUNCTION_LOGIC_RSHIFT_MODIFIER   ; zp/abs

    width = FUNCTION_LOGIC_RSHIFT_WIDTH

    clc
    ldx modifier
    @body:
        ldy #$00
        @digit:
            lda (output), y
            rol
            sta (output), y
            dey
            cpy width
            bne @digit
        dex
        bpl @body

    .endproc