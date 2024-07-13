.proc fast_multiply_16
    ; FUNCTION_FAST_MULTIPLY_BASE
    ; FUNCTION_FAST_MULTIPLY_EXP
    ; just uses a

    ; zero mult protection
    lda FUNCTION_FAST_MULTIPLY_EXP
    beq @zleave

    ; one mult protection
    cmp #$01
    beq @oleave

    ; init args
    lda FUNCTION_FAST_MULTIPLY_BASE
    beq @zleave

    sta FUNCTION_FAST_MULTIPLY_TEMP

    .if FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY
        lda FUNCTION_FAST_MULTIPLY_BASE
        jsr logic::sum_bits_8
        sty FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY_TEMP
        lda FUNCTION_FAST_MULTIPLY_EXP
        jsr logic::sum_bits_8
        cpy FUNCTION_FAST_MULTIPLY_REDUCE_INTENSITY_TEMP
        bcc @continue
            pha
            lda FUNCTION_FAST_MULTIPLY_BASE
            sta FUNCTION_FAST_MULTIPLY_EXP
            pla
            sta FUNCTION_FAST_MULTIPLY_BASE
        @continue:
    .endif

    lda #$00
    sta FUNCTION_FAST_MULTIPLY_TEMP+1

    @_digit:
    clc                                     ; remove redundant cleans

    @digit:
        rol FUNCTION_FAST_MULTIPLY_TEMP     ; rol bits
        rol FUNCTION_FAST_MULTIPLY_TEMP+1   ; upwards
        lsr FUNCTION_FAST_MULTIPLY_EXP      ; shift down
        bcc @digit                          ; if clear we dont gotta clean nor apply

    ; add the number above to a total

    clc                                     ; else clean and add to sum
    lda FUNCTION_FAST_MULTIPLY_RESULT
    adc FUNCTION_FAST_MULTIPLY_TEMP
    sta FUNCTION_FAST_MULTIPLY_RESULT       ; apply lobyte

    lda FUNCTION_FAST_MULTIPLY_RESULT+1
    adc FUNCTION_FAST_MULTIPLY_TEMP+1
    sta FUNCTION_FAST_MULTIPLY_RESULT+1     ; with carry onto hibyte

    lda FUNCTION_FAST_MULTIPLY_EXP          ; check if a
    bne @_digit                             ; is zero, if so we are done.
    rts

    @zleave:
        sta FUNCTION_FAST_MULTIPLY_RESULT
        sta FUNCTION_FAST_MULTIPLY_RESULT+1
        rts
    @oleave:
        lda FUNCTION_FAST_MULTIPLY_BASE
        sta FUNCTION_FAST_MULTIPLY_RESULT
        lda #$00
        sta FUNCTION_FAST_MULTIPLY_RESULT+1
        rts
    .endproc

; bitsumming was TOO SLOW for this! Cycle test script in directory