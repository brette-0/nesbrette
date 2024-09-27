
.proc __add_noptr_fetch_width
    ; defines
    .if CONSTANTS_MATH_ADD_WIDTH
        ldx #CONSTANTS_MATH_ADD_WIDTH
    .else
        ldx ADDRESSES_MATH_ADD_WIDTH
    .endif

    ; use bitwidth if inline and nonzero, else use vwidth
    .endproc
    ;leak
.proc __add_noptr__body
    ; x => width

    output = ADDRESSES_MATH_ADD_OUT
    adder  = ADDRESSES_MATH_ADD_MOD

    .ifdef isabsolute
        modifier = $800
    .else
        modifier = $0
    .endif

    clc
    .if .not isunrolled    
        @loop:
            lda output + modifier, x
            adc adder  + modifier, x
            sta output + modifier, x       ; tar += mod
            dex
            bne @loop                       ; do {} while (width);

    .else
        .repeat (bitwidth >> 3), iter
            lda output + iter + modifier
            adc adder  + iter + modifier
            sta output + iter + modifier
    .endif
    

    ; exit
    .if .not isinline
        rts
        .endif

    .endproc 
