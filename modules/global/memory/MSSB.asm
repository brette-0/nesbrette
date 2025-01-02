.macro MSSB
    ldy #$ff
    @loop:
        iny
        lsr
        bne @loop
    tya
    adc #$00
    .endmacro