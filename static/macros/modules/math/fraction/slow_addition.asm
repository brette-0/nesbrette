.macro slow_subtraction
    lda #$80
    sta FUNCTION_FLAGS
    jsr math::fraction::addition     ; don't force simplification, handle externally
    jmp math::fraction::simplify
    .endmacro