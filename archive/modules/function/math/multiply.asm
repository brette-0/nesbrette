.proc multiply
    ; FUNCTION_FAST_MULTIPLY_BASE [little endian]
    ; FUNCTION_FAST_MULTIPLY_EXP  [little endian]
    ; FUNCTION_FAST_MULTIPLY_INPUT_LENGTH
    ; FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
    
    ; uses a/x/y

    ; zero mult protection
    ldx FUNCTION_FAST_MULTIPLY_EXP
    @check_exp:                                     ; scan for 0
        dex
        beq @zleave
        lda FUNCTION_FAST_MULTIPLY_EXP, x
        beq @check_exp

    @check_base:                                    ; scan for 0
        dex
        beq @zleave
        lda FUCTION_FAST_MULTIPLY_BASE, x
        beq @check_base

    ; init args

    ldx FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
    lda #$00
    @clean:
        sta FUNCTION_FAST_MULTIPLY_TEMP-1, x
        dex
        bne @clean                              ; init temps

    ldx #$ff
    @scan:
        inx
        lda FUNCTION_FAST_MULTIPLY_EXP, x       ; find first nonzero byte (for exit checking)
        beq scan
    
    stx Checkbyte
    
    @_digit:
    clc                                         ; remove redundant cleans

    @digit:
        ldx FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
        @mult2:
            rol FUNCTION_FAST_MULTIPLY_TEMP-1, x; rol bits
            dex
            bne @mult2


        ldx #$00
        ldy FUNCTION_FAST_MULTIPLY_EXP        
        @div2:
            ror FUNCTION_FAST_MULTIPLY_EXP-1, x ; roll down
            dey
            bne @div2

        bcc @digit                              ; if clear we dont gotta clean nor apply

    ; add the number above to a total

    clc                                         ; else clean and add to sum
    ldx #$0
    @sum:
        lda FUNCTION_FAST_MULTIPLY_RESULT, x
        adc FUNCTION_FAST_MULTIPLY_TEMP, x
        sta FUNCTION_FAST_MULTIPLY_RESULT, x    ; apply lobyte
        inx
        cpx FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
        bne @sum

    ldx Checkbyte
    lda FUNCTION_FAST_MULTIPLY_EXP, x           ; check if a
    bne @_digit                                 ; is zero, if so we are done with this byte
    inx
    cpx FUNCTION_FAST_MULTIPLY_EXP
    stx Checkbyte
    bcc @digit                                  ; loop back with new checkbyte
    rts

    @zleave:
        ldx FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
        @writez:
            sta FUNCTION_FAST_MULTIPLY_RESULT-1, x
            dex
            bne @writez
        rts
    @oleave:
        ldx FUNCITON_FAST_MULTIPLY_OUTPUT_LENGTH
        @copyfromin:
            lda FUNCTION_FAST_MULTIPLY_TEMP-1, x
            sta FUNCTION_FAST_MULTIPLY_RESULT-1, x
            dex
            bne @copyfromin
        rts
    .endproc