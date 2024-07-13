.proc double_poll
    readjoy2_safe:
        ldx #$00
        jsr readjoyx_safe  ; X=0: safe read controller 1
        inx
        ; fall through to readjoyx_safe, X=1: safe read controller 2

    readjoyx_safe:
        jsr readjoyx
    reread:
        lda buttons, x
        pha
        jsr readjoyx
        pla
        cmp buttons, x
        bne reread
        rts
    .endproc

; source: https://www.nesdev.org/wiki/Controller_reading_code#DPCM_Safety_using_Repeated_Reads