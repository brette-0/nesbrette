.proc rshift

    output = FUNCTION_LOGIC_RSHIFT_OUTPUT       ; ioptr
    modifier = FUNCTION_LOGIC_RSHIFT_MODIFIER   ; zp/abs

    width = FUNCTION_LOGIC_RSHIFT_WIDTH

    clc
    ldx modifier
    @body:
        ldy width
        @digit:
            lda (output), y
            ror
            sta (output), y
            dey
            bpl @digit
        dex
        bpl @body

    .endproc