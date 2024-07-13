.proc subtraction_df
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_SUBTRACTION_ADDER
    Result  = FUNCTION_MATH_SUBTRACTION_OUT
    Width   = FUNCTION_MATH_SUBTRACTION_WIDTH
    
    ldx #$00
    ldy Width
    
    sec
    @loop:
        lda Result, x
        sbc Adder,  x
        sta Result, x
        inx
        dey
        bne @loop
    rts
    .endproc

; Profiling:
; Size:
;   16 bytes                            | (with zp stored info)
;   19 bytes                            | (with abs stored info)
;---------------------------------------------------------------
; Speed:
;   12 + (Width * 17)                   | (with zp stored info)
;   13 + (Width * 20)                   | (with abs stored info)
;   13 + (Width * 21)                   | (if innermost branch overlaps a page boundary)