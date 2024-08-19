.macro slow_division
    lda #$80
    sta FUNCTION_FLAGS
    jsr math::fraction::division     ; don't force simplification, handle externally
    jmp math::fraction::simplify
    .endmacro