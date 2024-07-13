.proc lfsr
    ; size

    ldx FUNCTION_RANDOM_LFSR_WIDTH
    @loop:
        lda FUNCTION_RANDOM_LFSR-1, x
        rol FUNCTION_RANDOM_LFSR-1, x
        eor FUNCTION_RANDOM_LFSR-1, x
        sta FUNCTION_RANDOM_LFSR-1, x
        dex
        bne @loop

    rts
    .endproc