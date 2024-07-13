.proc lfsr_16
    lda FUNCTION_RANDOM_LFSR_16
    lsr 
    eor FUNCTION_RANDOM_LFSR_16
    sta FUNCTION_RANDOM_LFSR_16
    lda FUNCTION_RANDOM_LFSR_16+1
    ror FUNCTION_RANDOM_LFSR_16+1
    sta FUNCTION_RANDOM_LFSR_16+1
    rts
    .endproc

; make macro?