.macro div addr
    pha
    .if RECIPROCAL_ElementWidth = 1
        .if addr < 0    ; imm
            ldy #-addr
        .else
            ldy addr
        .endif

        lda RECIPROCAL, y
        sta MMC5_Mult_Hi
    
    .else
        ; access lobyte
        .if addr < 0
            lda #-addr
        .else
            lda addr
        .endif

        sta MMC5_Mult_Hi
        lda #RECIPROCAL_ElementWidth
        sta MMC5_Mult_Lo                ; build offset from base
        
        lda #<Reciprocal
        adc MMC5_Mult_Result_Lo
        sta $00

        lda #>Reciprocal
        adc MMC5_Mult_Result_Hi
        sta $01                         ; apply to origin and setup indirect indexed

        ldy #RECIPROCAL_ElementWidth-1  ; access tail (little endian hibyte)

        lda ($00), y
        sta MMC5_Mult_Hi                ; access 8bit approx of reciprocal approx

    .endif
    pla
    sta MMC5_Mult_Lo                    ; against numerator
    lda MMC5_Mult_Result_Hi             ; prep a with result
    .endmacro