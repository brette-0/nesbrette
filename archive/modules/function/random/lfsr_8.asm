.proc lfsr_8
    lda FUNCTION_RANDOM_LFSR_8
    lsr 
    eor FUNCTION_RANDOM_LFSR_8
    sta FUNCTION_RANDOM_LFSR_8
    rts
    .endproc

; make macro?