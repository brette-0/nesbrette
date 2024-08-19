.macro slow_multiply
    lda #$80
    sta FUNCTION_FLAGS
    jsr math::fraction::multiply     ; don't force simplification, handle externally
    jmp math::fraction::simplify
    .endmacro