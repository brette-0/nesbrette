.ifndef isinline
.proc __add_ioptr_fetch_width
    ; defines
    .ifdef CONSTANTS_MATH_ADD_WIDTH
        ldy #CONSTANTS_MATH_ADD_WIDTH
    .else
        ldy ADDRESSES_MATH_ADD_WIDTH
    .endif

    ; use bitwidth if inline and nonzero, else use vwidth
    .endproc
    ;leak
.proc __add_ioptr__body
.endif
    ; x => width

    output = ADDRESSES_MATH_ADD_OUT
    adder  = ADDRESSES_MATH_ADD_MOD

    clc
    .if ((.ifdef isbig) .or (.ifdef CONFIG_MODULES_MATH_BIG_ENDIAN)) .and .not ((.ifdef .isunrolled) .or (.ifdef CONFIG_MODULES_MATH_FORCE_UNROLL))
        ldy #$00
        .endif

    .if (.ifdef isunrolled) .or (.not .ifdef CONFIG_MODULES_MATH_FORCE_UNROLL)
        @loop:
            lda (output), y
            adc (adder), y
            sta (output), y       ; tar += mod
            
            .if (.ifdef isbig) .or (.ifdef CONFIG_MODULES_MATH_BIG_ENDIAN)
                iny
                .if .isinline
                    cpy #(bitwidth >> 5)
                .else (.ifdef CONSTANTS_MATH_ADD_WIDTH)
                    cpy #CONSTANTS_MATH_ADD_WIDTH
                .else
                    cpy ADDRESSES_MATH_ADD_WIDTH
                .endif
            .else
                dey
            .endif
            bne @loop                      ; do {} while (width);

    .else
        .ifdef (bitwidth >> 5)
            repeatwidth = (bitwidth >> 5)
        .elseif (.ifdef CONSTANTS_MATH_ADD_WIDTH)
            repeatwidth = (bitwidth >> 5)
        .else
            .fatal "No constant width specified for unroll"
        .endif

        .repeat repeatwidth, iter
            .if (.ifdef isbig) .or (.ifdef CONFIG_MODULES_MATH_BIG_ENDIAN)
                lda (output), y
                adc (output), y
                sta (output), y
                iny
            .else
                dey
                lda (output), y
                adc (adder) , y
                sta (output), y
            .endif
    .endif
    ; exit
    .ifndef isinline
        rts
    .else
        .if .not isinline
            rts
        .endif
    .endif

    .endproc 
