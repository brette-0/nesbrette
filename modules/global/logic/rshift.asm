.macro rshift __amt__
    .if (__amt__) > 7
        .if WARNING_LOGIC_SHIFT_OVERFLOW
            .warning "Amount to shift by will always result in zero"
        .endif
        lda #$00
    .elseif (__amt__) > 5
        .repeat (9 - __amt__), _
            rol
            .endrepeat
        and #(1 << (8 - amt)) - 1
    .else
        .repeat __amt__, _
            lsr
            .endrepeat
    .endif
    .endmacro