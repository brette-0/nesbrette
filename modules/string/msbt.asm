.proc nullt
    ; Assumes PPUADDR is alligned
    ; Assumes PPUCTRL INC dir is right
    
    StrLoc = FUNCTION_STRING_PTR

    ldy #$00

    @write:
        lda (StrLoc), y
        sta PPUDATA
        bpl @write
        
    rts
    .endproc