.ifndef .isline                             ; do not include header or labels if inline
.proc __add_noptr_fetch_width
    ; defines
    .ifdef CONSTANTS_MATH_ADD_WIDTH
        ldx #CONSTANTS_MATH_ADD_WIDTH
    .else
        ldx ADDRESSES_MATH_ADD_WIDTH
    .endif

    ; use bitwidth if inline and nonzero, else use vwidth
    .endproc
    ;leak
.proc __add_noptr__body
.endif
    ; x => width

    output = ADDRESSES_MATH_ADD_OUT
    adder  = ADDRESSES_MATH_ADD_MOD

    .ifdef isabsolute 
        modifier = $800 * isabsolute
    .else
        .ifdef CONFIG_MODULES_MATH_FORCE_ABSOLUTE
            modifier = $800 * CONFIG_MODULES_MATH_FORCE_ABSOLUTE
        .else
            modifier = $0
        .endif
    .endif

    clc

    .ifdef isbig
        .ifdef isunrolled

    .if (.ifndef isunrolled) .or (.ifndef CONFIG_MODULES_MATH_FORCE_UNROLL)
        .if (.ifdef big) .or (.ifdef CONFIG_MODULES_MATH_BIG_ENDIAN)
            ldx #$00
        .endif

        @loop:
            lda output + modifier, x
            adc adder  + modifier, x
            sta output + modifier, x       ; tar += mod
            
            .if (.ifdef isbig) .or (.ifdef CONFIG_MODULES_MATH_BIG_ENDIAN)
                inx
                .if .isinline
                    cpx #(bitwidth >> 5)
                .else (.ifdef CONSTANTS_MATH_ADD_WIDTH)
                    cpx #CONSTANTS_MATH_ADD_WIDTH
                .else
                    cpx ADDRESSES_MATH_ADD_WIDTH
                .endif
            .else
                dex
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
                lda output - iter + modifier + (bitwidth >> 5)
                adc adder  - iter + modifier + (bitwidth >> 5)
                sta output - iter + modifier + (bitwidth >> 5)
            .else
                lda output + iter + modifier
                adc adder  + iter + modifier
                sta output + iter + modifier
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
