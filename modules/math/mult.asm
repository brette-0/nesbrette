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
    ; body width is 6
    ; smallest branch is 4
    ; max full iterations is 20
    ; can perform action branchlessly forwards (21 forwards, 20 backwards)

    ; highest branch is -8

    ; for every complete 'hunk' plus the remainder
    ; one hunk is 251 bytes

    t_set .set max_width
    
    .repeat (max_width / 41) + ((max_width .mod 41) <> 0), hunk
        .repeat .min(t_set - 1, 20) , iter
            dex
            lda ADDRESSES_MATH_MULT_MOD + max_width - iter - (251 * hunk) - 1
            bne @exit
            .endrepeat

        dex
        lda ADDRESSES_MATH_MULT_MOD + width - (251 * hunk) - 1
        
        .if t_set > 21
            beq @continue
            @exit:
            rts
            @continue:
        .else
            @exit:
                rts
        .endif

        t_set .set (t_set - .min(t_set, 21))
        .repeat .min(t_set - 1, 20) , iter
            dex
            lda ADDRESSES_MATH_MULT_MOD + max_width - iter - (251 * hunk) - 1
            bne @exit
            .endrepeat

        t_set .set (t_set - .min(t_set, 20))
        .endrepeat


    .repeat max_width - 1, iter
        dex
        lda ADDRESSES_MATH_MULT_MOD + max_width - (251 * hunk) - iter - 1
        bne @exit
        .endrepeat
    dex
    lda ADDRESSES_MATH_MULT_MOD + width - 1
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

.proc __mult
    ldx ADDRESSES_MATH_MULT_MOD_WIDTH
    jsr #$2020  ; __mult__find__last__nonzero (jump inside)
    stx ADDRESSES_MATH_MULT_MOD_mssB    ; byte
    MSSB
    sta ADDRESSES_MATH_MULT_MOD_mssb    ; bit

    xset
    bne @ahead
        ; wipe out
        rts

@ahead:
    ldx #$00
    jsr $2020  ; __mult__find__first__nonzero (jump inside at entrypoint)
    stx ADDRESSES_MATH_MULT_MOD_lssB    ; byte
    pha
    beq @skip_translate
    jsr $2020  ; __mult__coarse__lshift (jump inside at entrypoint)

@skip_translate:
    pla
    MSSB
    sta ADDRESSES_MATH_MULT_MOD_lssb    ; bits

    @loop:
        jsr $2020  ; __mult__out__lshift (return insertion)
        dex
        bne @loop

    jsr $2020      ; __mult__out__temp_mv

    @main:
        ldx ADDRESSES_MATH_MULT_MOD_lssB
        lda ADDRESSES_MATH_MULT_MOD, x
        and $3d3d, x                        ; ADDRESSES_MATH_MULT_MOD_MASKS
        beq @nosum

        jsr $2020  ; __mult__mod__sum          (return insertion)

        @nosum:
        jsr $2020  ; __mult__out__temp__lshift (return insertion)
        jsr $2020  ; __mult__mod__rshift       (return insertion)
        lda ADDRESSES_MATH_MULT_MOD_lssB
        cmp ADDRESSES_MATH_MULT_MOD_mssB 
        bne @main                           ; if we have read every byte
        lda ADDRESSES_MATH_MULT_MOD_lssb
        cmp ADDRESSES_MATH_MULT_MOD_mssb
        bne @main                           ; if we have read every bit of last byte
    
    .endproc

ADDRESSES_MATH_MULT_MOD_MASKS:
    .byte $01, $02, $04, $08, $10, $20, $40, $80


.macro __init__mult
    __mult__smc__find__last__nonzero ADDRESSES_MATH_MULT_SMC_HUNK1


.macro mult
    jsr __mult
    .endmacro

.macro __mult__smc__find__last__nonzero __mult__find__last__nonzero
    .local gen, ahead, t_Addr_Hi, t_Addr_Lo

    t_Addr_Lo = temp & $ff
    t_Addr_Hi = temp >> $08

    lda #<ADDRESSES_MATH_MULT_MOD
    sta t_Addr_Lo
    lda #>ADDRESSES_MATH_MULT_MOD
    sta t_Addr_Hi

    clc
    ldx #((max_width-1) * 6)
    lda #((max_width-1) * 6) + 4
    @gen:
        ldy #$ca
        sty __mult__find__last__nonzero, x          ; dex
   
        ldy #$ad
        sty __mult__find__last__nonzero + 1, x      ; lda abs
        
        ldy t_Addr_Lo
        sty __mult__find__last__nonzero + 2, x      ; abs lo

        ldy t_Addr_Hi
        sty __mult__find__last__nonzero + 3, x      ; abs hi (little endian)

        sbc #$06
        bmi @exit
        sta __mult__find__last__nonzero + 5, x      ; relative address

        ldy #$d0
        sty __mult__find__last__nonzero + 4, x      ; bne

        inc t_Addr_Lo
        bne @ahead
        inc t_Addr_Hi

    @ahead:
        txa
        axs #$06
        bne @gen                                    ; bra (branch to exit should always succeed)

    @exit:
    .endmacro