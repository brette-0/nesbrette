.proc sum_bits_8
    ; args:
    ; a --> number
    ; returns:
    ; y --> bits set (can be inverted for bits unset)

    ldy #$00

    @loop:
        lsr             ; otherwise load c
        beq @next       ; if empty, prepare next number
        bcc @loop       ; if c empty, repeat
        iny             ; otherwise log
        bcs @loop
    @next:
        bcc @skip
        iny
    @skip:    
    rts                 ; exit on count
    .endproc