.proc reverse_8
    ; a --> value
    ; corrupts x
    ; result in result

    ldx #$00
    stx result
    ldx #$08

    @loop:
        lsr
        rol result
        dex
        bne @loop

    rts
    .endproc