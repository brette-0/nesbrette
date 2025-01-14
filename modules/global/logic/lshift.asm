; untested

.macro lshift __amt__, __output__, __width__
    .ifnblank __output__                            ; undefine output if null, uses acc mode
        .if is_null __output__
            .undefine __output__
        .endif
    .endif

    .ifndef __output__  ; acc mode
        .if (__amt__) > 7
            .if WARNING_LOGIC_SHIFT_OVERFLOW
                .warning "Amount to shift by will always result in zero"
            .endif
            lda #$00
        .elseif (__amt__) > 5
            .repeat (9 - __amt__), _
                ror
                .endrepeat
            and #~((1 << (amt)) - 1)
        .else
            .repeat __amt__, _
                asl
                .endrepeat
        .endif
    .else
        .if __amt__ >= (__width__ * 8)
            ; warn too large
            .endif

        ; byte shift (moving bytes)
        .repeat __width__ - (__amt__ >> 3), iter
            lda __output__ + iter
            sta __output__ + (__amt__ >> 3) + iter
            .endrepeat

        ; cleaning tail
        lda #$00
        .repeat (__amt__ >> 3), iter
            sta __output__ + width - (__amt__ >> 3) + iter
            .endrepeat

        ; shifting all remaining bytes by "fine detail"
        .if __amt__ & %111
            clc
            .repeat (__amt__ & %111), _
                .repeat __width__ - (__amt__ >> 3), iter
                    rol __output__ + __width__ - (__amt__ >> 3) -  iter
                    .endrepeat
                .endrepeat
            .endif            
    .endif
    .endmacro