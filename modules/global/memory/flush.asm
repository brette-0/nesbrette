; needs to be expanded on
.macro flush __target__, __range__, __value__, __unroll__
    .ifblank __range__
        .fatal "Target and Range for memory flushing must be configured"
        .endif

    .ifblank __value__
        __value__ = $00
        .endif

    .ifblank __unroll__
        __unroll__ = 0
        .endif

    lda #__value__
    .if __unroll__
        .repeat __range__, iter
            sta __target__ + iter
            .endrepeat
        .endif
    .else
        ldx #width
        loop:
            sta __target__ - 1, x
            dex
            bne loop
    .endif