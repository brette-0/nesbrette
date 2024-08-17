.proc index_random
    Table = 
    Seed  = 
    
    lda Seed
    ldy #$00
    sec
    @body:
        sbc (Table), y
        iny
        bpl @body

    rts
    .endproc 