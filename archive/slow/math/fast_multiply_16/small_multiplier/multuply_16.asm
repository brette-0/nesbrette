.proc multiply_16
    .if (FUNCTION_MULTIPLY_16_REGISTERS = 3) .or (FUNCTION_MULTIPLY_16_REGISTERS = 4) ; use AXY
        ; input:
        ; Large Number --> A
        ; Small Number --> X
        ; result:
        ; lobyte       --> A
        ; hibyte       --> Y

        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION = 1
            beq @zerotwo
            cpx #$00
            beq @zero    
        .endif

        .if MULTIPLY_CHECK_ONE_MULTIPLICATION
            cmp #$01
            bne @not_one
            lda #$00
            sta FUNCTION_MULTIPLY_RESULT_Hi
            rts

            @not_one:
        .endif

        sta FUNCTION_MULTIPLY_BASE
        
        .if FUNCTION_MULTIPLY_REDUCE_ITERATIONS
            .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                cpx FUNCTION_MULTIPLY_BASE
                bcc @exit
                    txa
                    ldx FUNCTION_MULTIPLY_BASE
                    sta FUNCTION_MULTIPLY_BASE
                @exit:
            .else
                cpy FUNCTION_MULTIPLY_BASE
                bcc @exit
                    tya
                    ldy FUNCTION_MULTIPLY_BASE
                    sta FUNCTION_MULTIPLY_BASE
                @exit:
            .endif
        .endif
        
        clc
        .if FUNCTION_MULTIPLY_16_REGISTERS = 3
            ldy #$00
        .else
            ldx #$00
        .endif

        @loop:
            adc FUNCTION_MULTIPLY_BASE
            bcc @skip
            
            .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                iny
            .else
                inx
            .endif

            clc
        @skip:
            .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                dex
            .else
                dey
            .endif

            bne @loop
        rts

        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION
            @zero:
                lda #$00
                .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                    tay
                .else
                    tax
                .endif
                rts
        .endif

    .elseif (FUNCTION_MULTIPLY_16_REGISTERS = 2) | (FUNCTION_MULTIPLY_16_REGISTERS = 1) ; Use AY / AX
        ; input:
        ; Large Number --> A
        ; Small Number --> X
        ; result:
        ; lobyte       --> A
        ; hibyte       --> FUNCTION_MULTIPLY_RESULT_Hi

        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION = 1
            beq @zerotwo
            cpx #$00
            beq @zero    
        .endif

        .if MULTIPLY_CHECK_ONE_MULTIPLICATION
            cmp #$01
            bne @not_one
            lda #$00
            sta FUNCTION_MULTIPLY_RESULT_Hi
            rts

            @not_one:
        .endif
    
        sta FUNCTION_MULTIPLY_BASE

        .if FUNCTION_MULTIPLY_REDUCE_ITERATIONS
            .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                cpx FUNCTION_MULTIPLY_BASE
                bcc @exit
                    txa
                    ldx FUNCTION_MULTIPLY_BASE
                    sta FUNCTION_MULTIPLY_BASE
                @exit:
            .else
                cpy FUNCTION_MULTIPLY_BASE
                bcc @exit
                    tya
                    ldy FUNCTION_MULTIPLY_BASE
                    sta FUNCTION_MULTIPLY_BASE
                @exit:
            .endif
        .endif

        lda #$00
        sta FUNCTION_MULTIPLY_RESULT_Hi
        lda FUNCTION_MULTIPLY_BASE 
        clc

        @loop:
            adc FUNCTION_MULTIPLY_BASE
            bcc @skip
            inc FUNCTION_MULTIPLY_RESULT_Hi
            clc
        @skip:
            
            .if FUNCTION_MULTIPLY_16_REGISTERS = 2
                dey
            .else
                dex
            .endif

            bne @loop
        rts
        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION
            @zero:
                lda #$00
                .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                    tay
                .else
                    tax
                .endif
                rts
        .endif

    .else
        ; input:
        ; a                             --> High value
        ; FUNCTION_MULTIPLY_SECOND      --> Small Value
        ; return:
        ; a                             --> lobyte
        ; FUNCTION_MULTIPLY_RESULT_Hi   --> hibyte

        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION = 1
            beq @zerotwo
                pha
                lda FUNCTION_MULTIPLY_SECOND
                cmp #$00    ; not right
                beq @zero
            pla    
        .endif

        .if MULTIPLY_CHECK_ONE_MULTIPLICATION
            cmp #$01
            bne @not_one
            lda #$00
            sta FUNCTION_MULTIPLY_RESULT_Hi
            rts

            @not_one:
        .endif

        sta FUNCTION_MULTIPLY_BASE
        
        .if FUNCTION_MULTIPLY_REDUCE_ITERATIONS
            lda FUNCTION_MULTIPLY_SECOND
            cmp FUNCTION_MULTIPLY_BASE
            bcc @exit
                pha
                lda FUNCTION_MULTIPLY_BASE
                sta FUNCTION_MULTIPLY_SECOND
                pla
                sta FUNCTION_MULTIPLY_BASE
            @exit:
        .endif

        lda #$00
        sta FUNCTION_MULTIPLY_RESULT_Hi
        lda FUNCTION_MULTIPLY_BASE

        clc
        @loop:
            adc FUNCTION_MULTIPLY_BASE
            bcc @skip
            inc FUNCTION_MULTIPLY_SECOND
            clc
        @skip:
            dec FUNCTION_MULTIPLY_SECOND
            bne @loop
        rts
        .if MULTIPLY_CHECK_ZERO_MULTIPLICATION
            @zero:
                pla
                lda #$00
            @zerotwo:
                .if FUNCTION_MULTIPLY_16_REGISTERS = 3
                    tay
                .else
                    tax
                .endif
                rts
        .endif
    .endif
    .endproc

; multiply_16_profiling:    (add zerohandling / onehandling logs)
;----------------------------------------------------------
;   Mode 0
;       FASTEST: (15 * FUNCTION_MULTIPLY_SECOND) - floor((a * FUNCTION_MULTIPLY_SECOND * 7) / 256) + 18
;       SLOWEST: (19 * FUNCTION_MULTIPLY_SECOND) - floor((a * FUNCTION_MULTIPLY_SECOND * 8) / 256) + 21
;           (all factors are in control of the developer)
;----------------------------------------------------------
;   Modes 1 & 2
;       FASTEST: (12 * FUNCTION_MULTIPLY_SECOND) - floor((a * FUNCTION_MULTIPLY_SECOND * 7) / 256) + 18
;       SLOWEST: (15 * FUNCTION_MULTIPLY_SECOND) - floor((a * FUNCTION_MULTIPLY_SECOND * 8) / 256) + 21
;           (all factors are in control of the developer)
;----------------------------------------------------------
;   Mode 3 & 4
;       FASTEST: (10 * x) - floor((a * y * 3) / 256) + 11
;       SLOWEST: (12 * x) - floor((a * y * 3) / 256) + 12
;           (all factors are in control of the developer)
;           (x is interchangable with y)

; MARGINAL DIFFERNCE!