.proc sum_bits_64
    ; NUMBER
    ; NUMBER_LENGTH
    ; returns:
    ; y --> bits set (can be inverted for bits unset)

    clc
    ldx NUMBER_LENGTH
    ldy #$00
    @oloop:
        lda NUMBER, x       ; read number
        beq @next           ; if zero don't scan
        @iloop:
            lsr             ; otherwise load c
            beq @next       ; if empty, prepare next number
            bcc @iloop      ; if c empty, repeat
            iny             ; otherwise log
            bcs @iloop      ; and repat
        @next:
            bcc @skip       ; check c from earlier
            iny             ; apply if found
            @skip:          ; otherwise dont
                dex         ; either way check next digit
            bne @oloop      ; if width hasnt been fully read, leave
    rts                     ; exit on count
    .endproc