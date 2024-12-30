.macro compare __base__, __compare__, __width__, __status__, __reg__, __direct__

    .ifblank __base__
        .fatal "long compare needs base value to compare"
        .endif 

    .ifblank __compare__
        .fatal "long compare needs compare value to compare"
        .endif

    .ifblank __width__
        .fatal "long compare needs width value to compare"
        .endif

    .if (__width__ < 1) && (__width__ <> x) && (__width__ <> y)
        .fatal "long compare needs valid width to compare"
        .endif

    .ifblank __status__
        .fatal "long compare needs specified cpu status flags"
        .endif

    .if abs(__status__) <> status & abs(z + c) && WARNINGS_MEMORY_COMPARE_UNSUPPORTED_FLAGS
        .warning "long compare will not set all flags, but will clear them"
        .endif

    .ifblank __direct__
        __direct__ = direct
        .endif

    .ifblank __reg__
        __reg__ = a
        .endif

    .if (__reg__ <> a) .and (__reg__ <> x) .and (__reg__ <> y)
        .fatal "long compare must use valid general purpose register"
        .endif
    
    .ifblank __direct__
        __direct__ = direct
        .endif

    .if (__direct__ <> direct) && (__direct__ <> indirect)
        .fatal "long compare must use either direct or indirect addressing"
        .endif

    .if (__direct__ = indirect) && ((__reg__ <> a) || (__width__) <> y)
        .fatal "indirect mode was not configured correctly"
        .endif

    php
    pla                 ; status => a

    and #~$__status__   ; clear values we intend to change (if a funtion exists, elsewise nuke)

    .if __status__ & abs(z)
        __eqcompare __base__, __compare__, __width__, __reg__, __direct__
        .endif

    .if __status__ & abs(c)
        __valcompare __base__, __compare__, __width__, __reg__, __direct__
        .endif

    pha
    plp                 ; a => status

    .endmacro

.macro __eqcompare  __base__, __compare__, __width__, __reg__, __direct__
    ; 'engine' macro performs no validation : assumes parameters are validated on entry

    
    .if __reg__ = a
        pha
        .endif

    .if __direct__ = indirect
        .if __width__ > 0
            .repeat __width__, iter
                dey
                lda (__base__),    y
                cmp (__compare__), y
                bne @exit
                .endrepeat
        .else
            @loop:
                lda (__base__), y
                cmp (__compare__), y
                bne @exit
                cpy #$00
                bne @loop
        .endif
    .elseif __width__ > 0
        .repeat __width__, iter
            .if __reg__ = a
                lda __base__    + iter
                cmp __compare__ + iter
            .elseif __reg__ = x
                ldx __base__    + iter
                cpx __compare__ + iter
            .elseif __reg__ = y
                ldy __base__    + iter
                cpy __compare__ + iter
            .endif

            bne @exit
            .endrepeat
    .else
        @loop:
            .if __reg__ = a
                .if     __width__ = x
                    dex
                    lda __base__,    x
                    cmp __compare__, x
                .elseif __width__ = y
                    dey
                    lda __base__,    y
                    cmp __compare__, y
                .endif
            .elseif __reg__ = x
                dex
                ldy __base__,    x
                cpy __compare__, x
            .else
                dey
                ldx __base__,    y
                cpx __compare__, y
            .endif

            bne @loop

            .if __width__ = x
                cpx #$00
            .else
                cpy #$00
            .endif

            bne @loop
    .endif
    
    .if __reg__ = a
        pla                                 ; fetch original a
        ora #abs(z)                         ; set z
        .exitmacro

        @exit:
            pla
            .exitmacro                      ; leave with original
        .endif
    .else
        ora #abs(z)                         ; set z
        @exit:
            .exitmacro                      ; leave with original
    .endif
    .endmacro


.macro __valcompare  __base__, __compare__, __width__, __reg__, __direct__
    ; 'engine' macro performs no validation : assumes parameters are validated on entry

    .if __reg__ = a
        pha
        .endif

    .if __direct__ = indirect
        .if __width__ > 0
            .repeat __width__, iter
                dey
                lda (__base__),    y
                cmp (__compare__), y
                bcc @exit
                .endrepeat
        .else
            @loop:
                lda (__base__), y
                cmp (__compare__), y
                bcc @exit
                cpy #$00
                bne @loop
        .endif
    .elseif __width__ > 0
        .repeat __width__, iter
            .if __reg__ = a
                lda __base__    + iter
                cmp __compare__ + iter
            .elseif __reg__ = x
                ldx __base__    + iter
                cpx __compare__ + iter
            .elseif __reg__ = y
                ldy __base__    + iter
                cpy __compare__ + iter
            .endif

            bcc @exit
            .endrepeat
    .else
        @loop:
            .if __reg__ = a
                .if     __width__ = x
                    dex
                    lda __base__,    x
                    cmp __compare__, x
                .elseif __width__ = y
                    dey
                    lda __base__,    y
                    cmp __compare__, y
                .endif
            .elseif __reg__ = x
                dex
                ldy __base__,    x
                cpy __compare__, x
            .else
                dey
                ldx __base__,    y
                cpx __compare__, y
            .endif

            bcc @loop

            .if __width__ = x
                cpx #$00
            .else
                cpy #$00
            .endif

            bne @loop
    .endif

    .if __reg__ = a
        pla                                 ; fetch original a
        ora #abs(z)                         ; set z
        .exitmacro

        @exit:
            pla
            .exitmacro                      ; leave with original
        .endif
    .else
        ora #abs(z)                         ; set z
        @exit:
            .exitmacro                      ; leave with original
    .endif
    .endmacro