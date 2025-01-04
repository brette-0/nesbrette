.proc __mult__find__last__nonzero
    ; body width is 6
    ; smallest branch is 4
    ; max full iterations is 20
    ; can perform action branchlessly forwards (21 forwards, 20 backwards)

    ; highest branch is -8

    ; for every complete 'hunk' plus the remainder
    ; one hunk is 251 bytes

    t_set .set max_width
    
    .repeat (max_width / 41) + ((max_width .mod 41) <> 0), hunk
        .repeat .min(t_set - 1, 20) , iter
            dex
            lda ADDRESSES_MATH_MULT_MOD + max_width - iter - (251 * hunk) - 1
            bne @exit
            .endrepeat

        dex
        lda ADDRESSES_MATH_MULT_MOD + width - (251 * hunk) - 1
        
        .if t_set > 21
            beq @continue
            @exit:
            rts
            @continue:
        .else
            @exit:
                rts
        .endif

        t_set .set (t_set - .min(t_set, 21))
        .repeat .min(t_set - 1, 20) , iter
            dex
            lda ADDRESSES_MATH_MULT_MOD + max_width - iter - (251 * hunk) - 1
            bne @exit
            .endrepeat

        t_set .set (t_set - .min(t_set, 20))
        .endrepeat


    .repeat max_width - 1, iter
        dex
        lda ADDRESSES_MATH_MULT_MOD + max_width - (251 * hunk) - iter - 1
        bne @exit
        .endrepeat
    dex
    lda ADDRESSES_MATH_MULT_MOD + width - 1
    @exit:
    rts
    .endproc