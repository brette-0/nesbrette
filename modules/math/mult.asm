; constant defines
max_width = CONSTANTS_MATH_MULT_SMC_WIDTH

; parameters
ADDRESSES_MATH_MULT_OUT
ADDRESSES_MATH_MULT_OUT_WIDTH
ADDRESSES_MATH_MULT_MOD
ADDRESSES_MATH_MULT_MOD_WIDTH

; temporaries
ADDRESSES_MATH_MULT_MOD_mssB
ADDRESSES_MATH_MULT_MOD_mssb

.proc __mult__find__last__nonzero
    .repeat max_width, iter
        dex
        lda ADDRESSES_MATH_MULT_MOD + max_width - iter - 1
        bne @exit
        .endrepeat
    @exit:
    rts
    .endproc

.proc __mult__find__first__nonzero  ; tick down
    .repeat max_width, iter
        inx
; entrypoint
        lda ADDRESSES_MATH_MULT_MOD + iter
        bne @exit
        .endrepeat
    @exit:
    rts
    .endproc

.proc __mult__coarse__lshift        ; tick down
    .repeat max_width, iter
        dex
    ; entrypoint
        lda ADDRESSES_MATH_MULT_OUT + max_width - iter - 1, x
        sta ADDRESSES_MATH_MULT_OUT + max_width - iter - 1
        .endrepeat
    rts
    .endproc

.proc __mult__out__lshift           ; tick up
    .repeat max_width, iter
        asl ADDRESSES_MATH_MULT_OUT + iter
        .endrepeat
    .endproc

.proc __mult__out__temp_mv          ; tick up
    .repeat max_width, iter
        lda ADDRESSES_MATH_MULT_OUT      + iter
        sta ADDRESSES_MATH_MULT_OUT_temp + iter
        .endrepeat
    .endproc

.proc __mult__out__temp__lshift     ; tick up
    .repeat max_width, iter
        asl ADDRESSES_MATH_MULT_OUT_temp + iter
        .endrepeat
    .endproc

.proc __mult__mod__rshift           ; tick up
    .repeat max_width, iter
        lsr ADDRESSES_MATH_MULT_MOD + iter
        .endrepeat
    .endproc

.proc __mult__mod__sum              ; tick up
    .repeat max_width, iter
        lda ADDRESSES_MATH_MULT_OUT      + iter
        adc ADDRESSES_MATH_MULT_OUT_TEMP + iter
        sta ADDRESSES_MATH_MULT_OUT      + iter
        .endrepeat
    .endproc

.proc mult
    ldx ADDRESSES_MATH_MULT_MOD_WIDTH
    jsr #$0000  ; __mult__find__last__nonzero (jump inside)
    stx ADDRESSES_MATH_MULT_MOD_mssB    ; byte
    MSSB
    sta ADDRESSES_MATH_MULT_MOD_mssb    ; bit

    xset
    bne @ahead
        ; wipe out
        rts

@ahead:
    ldx #$00
    jsr #$0000  ; __mult__find__first__nonzero (jump inside at entrypoint)
    stx ADDRESSES_MATH_MULT_MOD_lssB    ; byte
    pha
    beq @skip_translate
    jsr #$0000  ; __mult__coarse__lshift (jump inside at entrypoint)

@skip_translate:
    pla
    MSSB
    sta ADDRESSES_MATH_MULT_MOD_lssb    ; bits

    @loop:
        jsr #$0000  ; __mult__out__lshift (return insertion)
        dex
        bne @loop

    jsr #$0000      ; __mult__out__temp_mv

    @main:
        ldx ADDRESSES_MATH_MULT_MOD_lssB
        lda ADDRESSES_MATH_MULT_MOD, x
        and ADDRESSES_MATH_MULT_MOD_MASKS, x
        beq @nosum

        jsr #$0000  ; __mult__mod__sum          (return insertion)

        @nosum:
        jsr #$0000  ; __mult__out__temp__lshift (return insertion)
        jsr #$0000  ; __mult__mod__rshift       (return insertion)
        lda ADDRESSES_MATH_MULT_MOD_lssB
        cmp ADDRESSES_MATH_MULT_MOD_mssB 
        bne @main                           ; if we have read every byte
        lda ADDRESSES_MATH_MULT_MOD_lssb
        cmp ADDRESSES_MATH_MULT_MOD_mssb
        bne @main                           ; if we have read every bit of last byte
    
    .endproc

ADDRESSES_MATH_MULT_MOD_MASKS:
    .byte ~$01, ~$02, ~$04, ~$08, ~$10, ~$20, ~$40, ~$80