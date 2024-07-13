.proc nullt
    ; Assumes PPUADDR is alligned
    ; Assumes PPUCTRL INC dir is right
    
    StrLoc = FUNCTION_STRING_PTR

    ldy #$00
    lda (StrLoc), y
    bne @write
    rts

    @write:
        sta PPUDATA
        lda (StrLoc), y
        bne @write
        
    rts
    .endproc