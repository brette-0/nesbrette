; requires math::subtract
; requires static common ioptr_compare

.proc bcd
    input       = FUNCTION_LOGIC_BCD_INPUT
    output      = FUNCTION_LOGIC_BCD_OUTPUT
    inwidth     = FUNCTION_LOGIC_BCD_INWIDTH
    outwidth    = FUNCTION_LOGIC_BCD_OUTWIDTH
    temp        = FUNCTION_LOGIC_BCD_TEMP
    ioptr       = FUNCTION_LOGIC_BCD_IOPTR


    ; clean output
    lda #$00
    ldy outwidth
    @clean:
        sta output, y
        sta temp, y
        dey
        bpl @clean

    ldy inwidth
    @copy:
        lda (input), y
        sta (temp), y
        dey
        bpl @copy
    
    ldx #$fe
    @scan:
        iny
        iny

        lda PO10_Table, y
        sta ioptr
        lda PO10_Table, y
        sta ioptr+1

        ioptr_compare ioptr temp inwidth 1
        inx
        bcc @scan
    dex
    txa
    asl
    
    ; set up iterative subtraciton

    @body:
        jsr math::subtract_ioptr
        ; increment something
        bcs @body                   ; subtract routine respects carry
        ; fetch lesser power of 10

    rts
    .endproc