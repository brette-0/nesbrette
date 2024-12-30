.macro memcpy __from__, __to__, __width__, __direct__, __reverse__
    .ifblank __from__
        .fatal "memcpy needs source address"
        .endif

    .ifblank __to__
        .fatal "memcpy needs target address"
        .endif

    .ifblank __width__
        .fatal "memcpy needs specified with"
        .endif

    .if (width <> x) .and (width <> y) and width <= 0
        .fatal "invalid memcpy width"
        .endif
    
    .ifblank __direct__
        __direct__ = direct
        .endif

    .if (__direct__ <> direct) .and (__direct__ <> indirect)
        .fatal "invalid memory address mode for memcpy"
        .endif
        
    pha

    .ifblank __reverse__
        __reverse__ = 0
    .endif

    .if __width__ < 0

        .if __reverse__
            .fatal "cannot reverse with variable width"
            .endif

        @loop:
            .if __width__ = x
                .if __direct__ = indirect
                    .fatal "memcpy does not support indexed indirect"
                    .endif

                lda __from__, x
                sta __from__, x
                dex
            .else
                .if __direct__ = indirect
                    lda (from), y
                    sta (to),   y
                .else
                    lda __from__, y
                    sta __from__, y
                .endif
                dey
            .endif

            bne @loop
    .else
        .repeat width, iter
            .if __reverse__
                lda __from__ + __width__ - iter - 1
            .else
                lda __from__ + iter
            .endif

            sta __to__   + iter
            .endrepeat
    .endif

    pla 
    .endmacro