; const
OUT_MAXIMUM_ARRAY
MOD_MAXIMUM_ARRAY

; zp
MOD_MSSByte, MOD_MSSB, OUT_LSSByte, OUT_LSSB, TIMER

OUT, MOD, TEMP
.proc __get_MOD_MSSByte
    MSSByte ADDRESSES_MATH_MULT_MOD, MOD_MAXIMUM_ARRAY, null
    rts
    .endproc

.proc __get_MOD_LSSByte
    LSSByte ADDRESSES_MATH_MULT_MOD, MOD_MAXIMUM_ARRAY, null
    rts
    .endproc

.proc __asl_out
    .repeat MOD_MAXIMUM_ARRAY,  iter
        asl MOD_MAXIMUM_ARRAY + iter
    .endrepeat
    rts
    .endproc

.proc __mod_out
    .repeat MOD_MAXIMUM_ARRAY,  iter
        lsr MOD + MOD_MAXIMUM_ARRAY - iter - 1
    .endrepeat

    rts
    .endproc

.proc __sum_out
    .repeat MOD_MAXIMUM_ARRAY,  iter
        lda OUT + iter
        adc TEMP + iter
        sta OUT + iter
        .endrepeat

    rts
    .endproc

.macro __mult_mod_mssb mod_width
    jmp __get_MOD_MSSByte + (mod_width * (5 + (ADDRESSES_MATH_MULT_MOD > $100)))
    stx MOD_MSSByte
    MSSB 
    sta MOD_MSSB
    .endmacro

.proc __mult_out_lssb_AND_temp_make
    ; fetch output lesser data
    jmp __get_MOD_LSSByte
    stx OUT_LSSByte
    LSSB
    sta OUT_LSSB

    memcpy out, temp, out_type 
    rts
    .endproc

; nocall in case (mult => rts) = (jsr => rts => rts) | faster (jmp => rts)
.macro mult out, mod, out_type, mod_type, __nocall__
    __mult__head
    __mult_mod_mssb mod_type
    jsr __mult_out_lssb

    clc
    adx
    tax ; x = x + a
    lshift x, out, out_type

    .if (MOD_LSSByte << 3) | MOD_LSSB = (OUT_LSSByte << 3) | OUT_LSSB     ; our work is done here
        .exitmacro
    .endif

    lda #(MOD_MSSByte << 3) | MOD_MSSB) -  (MOD_LSSByte << 3) | MOD_LSSB
    sta TIMER

    .if (__nocall__)
        .ifdef .ident(.sprintf("__mult_%d_%d"))
            .ident(.sprintf("jmp __mult_%d_%d"))
        .else
            .ident(.sprintf("__mult_make %d, %d"))
        .endif
    .else
        .ifndef .ident(.sprintf("__mult_%d_%d"))
            .ident(.sprintf("__mult_make %d, %d"))
            callback generated__callback
            .ident(.sprintf("jmp __mult_%d_%d"))
            generated__callback:
        .else
            .ident(.sprintf("jsr __mult_%d_%d"))
        .endif
    .endif

    .endmacro

.macro __mult_make out_type, mod_type
loop:
        jsr __get_MOD_LSSByte
        dec TIMER
        beq exit
        ldx MOD_LSSByte
        ldy MOD_LSSB
        cpy #$08
        bne @skip
            ldy #$00
            sty MOD_LSSB
            inx
            stx MOD_LSSByte

        @skip:
            lda MOD, x
            ldx MaskTables, y
            
        andx
        beq skip
            clc
            jsr __sum_out

        skip:
            callback loop
            jmp __lsr__mod_entry
    @exit:
    rts
    .endmacro

.macro __mult__head out_type, mod_type
    .ident(.sprintf("__mult_%d_%d:"))
    .endmacro