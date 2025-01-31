"""

; assume page aligned, and fits within one page

.macro __mult__last_nonzero_write __width__
    .ifblank
        lda ADDRESSES_MATH_MULT_MULT_WIDTH
    .else
        lda #(__width__ * 6)
    .endif

    sta __mult__last_nonzero_write_entrypoint_lo    ; 6 cycles constant, 8 cycles variable

    ; if not page aligned
    clc
    adc #__mult__last_nonzero_write_entrypoint_lo
    lda __mult__last_nonzero_write_hi
    adc #$00
    sta __mult__last_nonzero_write_entrypoint_hi    ; if necessary 16 cycles added

    ; jump time (+ 4 cycles)    (10, 12 or 28)
    .endmacro
"""