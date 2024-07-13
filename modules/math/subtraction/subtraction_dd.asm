.proc subtraction_dd
    ; inputs:
    ; little endian

    Adder   = FUNCTION_MATH_SUBTRACTION_ADDER
    Result  = FUNCTION_MATH_SUBTRACTION_OUT
    Width   = FUNCTION_MATH_SUBTRACTION_WIDTH
    
    ldy #$00
    ldx Width
    
    sec
    @loop:
        lda (Result),   y
        sbc (Adder),  y
        sta (Result), y
        inx
        dex
        bne @loop
    rts
    .endproc

; Profiling:
; Size:
;   19 bytes                            | 
;---------------------------------------------------------------
; Speed:
;   12 + (Width * 23)                   | (with zp stored info)
;   13 + (Width * 23)                   | (with abs stored info)
;   13 + (Width * 24)                   | (if innermost branch overlaps a page boundary)
;   13 + (Width * 25)                   | (if innermost branch overlaps a page boundary + indirect indexed write indexed over a page boundary)