; const
OUT_MAXIMUM_ARRAY
MOD_MAXIMUM_ARRAY

; zp
MOD_MSSByte, MOD_MSSB, TIMER

.define OPTIMIZATION_MULT_MSSBYTE_VALUE
.define OPTIMIZATION_MULT_MSSBYTE_DETAIL
.define OPTIMIZATION_MULT_MSSBYTE_COMPLEX

OUT, MOD, TEMP
.proc __get_MOD_MSSByte
    MSSByte ADDRESSES_MATH_MULT_MOD, MOD_MAXIMUM_ARRAY, null
    rts
    .endproc
.proc __get_MOD_LSSByte
    ldx #$00
    LSSByte ADDRESSES_MATH_MULT_MOD, MOD_MAXIMUM_ARRAY, null
    LSSB    
    rts
    .endproc
.proc __asl_out
    .repeat MOD_MAXIMUM_ARRAY,  iter
        rol OUT + iter
        .endrepeat
    rts
    .endproc

.proc __lsr_mod
    .repeat MOD_MAXIMUM_ARRAY,  iter
        ror MOD + MOD_MAXIMUM_ARRAY - iter - 1
        .endrepeat
    rts
    .endproc


.proc __mod_out
    .repeat MOD_MAXIMUM_ARRAY,  iter
        ror MOD + MOD_MAXIMUM_ARRAY - iter - 1
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



; nocall in case (mult => rts) = (jsr => rts => rts) | faster (jmp => rts)
.macro mult out, mod, out_type, mod_type, __nocall__
    .if mod_type > out_type
        .fatal "Multiplier cannot be larger than output"
    .elseif mod_type = out_type
        .ifdef OPTIMIZATION_MULT_MSSBYTE_VALUE
            lda OUT + out_type
            cmp MOD + mod_type
            bcs @skip
            juggle {out, mod}, {out_type}, TEMP, 0
            @skip:
        .endif

        .ifdef OPTIMIZATION_MULT_MSSBYTE_DETAIL
            ldx OUT + out_type
            lda TABLES_BIT_DETAIL, x
            ldx MOD + mod_type
            cmp TABLES_BIT_DETAIL, x
            bcs @skip
            juggle {out, mod}, {out_type}, TEMP, 0
            @skip:
        .endif

        .ifdef OPTIMIZATION_MULT_MSSBYTE_COMPLEX
            ldx OUT + out_type
            lda TABLES_MULT_COMPLEX, x
            ldx MOD + mod_type
            cmp TABLES_MULT_COMPLEX, x
            bcs @skip
            juggle {out, mod}, {out_type}, TEMP, 0
            @skip:
        .endif

        
    .endif
        
    
    ; deduce most significant byte and bit of mod
    ldx #mod_width
    jsr __get_MOD_MSSByte + (mod_width * (5 + (ADDRESSES_MATH_MULT_MOD > $100)))
    MSSB y
    tay
    txa
    lshift 3
    oray
    sta TIMER   ; Timer = (MSSByte(MOD) << 3) | MSSB(MOD)
    
    ldx #$00
    jsr __get_MOD_LSSByte + (mod_width * (5 + (ADDRESSES_MATH_MULT_MOD > $100)))
    stx MOD_LSSByte
    LSSB y
    sta MOD_LSSB

    tay
    txa
    lshift 3
    oray
    tax
    
    clc     ; might be redundant
    lda TIMER
    
    sbx     ; a = ((MSSByte(MOD) << 3) | MSSB(MOD) - (LSSByte(MOD) << 3) | LSSB(MOD))

    ; if timer is zero, there is nothing for us to do.
    bne @skip
    @exit:
        ldx #out_type
        lda #$00
        @loop:
            sta OUT - 1, x
            dex
            bne @loop
        .exitmacro
    @skip:

    sta TIMER   ; ((MSSByte(MOD) << 3) | MSSB(MOD) - (LSSByte(MOD) << 3) | LSSB(MOD))
    lshift x, out, out_type ; x = LSSByte(MOD) << 3) | LSSB(MOD)

    .if (__nocall__)
        .ifdef .ident(.sprintf("__mult_%d_%d"))
            .ident(.sprintf("jmp __mult_%d_%d"))
        .else
            __mult__head out_type, mod_type
        .endif
    .else
        .ifndef .ident(.sprintf("__mult_%d_%d"))
            __mult__head out_type, mod_type
            callback generated__callback
            .ident(.sprintf("jmp __mult_%d_%d"))
            generated__callback:
        .else
            .ident(.sprintf("jsr __mult_%d_%d"))
        .endif
    .endif

    .endmacro

.macro __mult_make out_type, mod_type
    memcpy out, temp, x
loop:
    lshift 1, TEMP, mod_type        ; roll temp left (x2 --> may be beneficial as SMC ... doubtful)
    
    dec TIMER                       ; due to the 21 element limit for mult and 8 bits being in a byte this can be a singular value
    beq exit                        ; do not tick beyond needed
    ldx MOD_LSSByte
    ldy MOD_LSSB
    cpy #$08                        ; if each bit in a byte is yet to be accessed
    bne @skip                       ; then skip wrap around
        ldy #$00                    ; otherwise do wrap around
        sty MOD_LSSB
        inx
        stx MOD_LSSByte             ; modify byte as GPR and MEM

@skip:
    lda MOD, x
    ldx MaskTables, y
    andx                            ; fetch the bit of the byte needed
    beq skip                        ; if not set no addition takes place
        clc
        jsr __sum_out               ; sum temp to out

    skip:
        callback loop               ; declare callback for jump
        jmp __lsr__mod_entry        ; rightshift modifier

    @exit:
    rts
    .endmacro

.macro __mult__head out_type, mod_type
    .ident(.sprintf("__mult_%d_%d:", out_type, mod_type))
    .endmacro