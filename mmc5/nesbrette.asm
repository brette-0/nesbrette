.scope mmc5
    .if EXCLUDE_MMC5_DIVIDE = 0
        .proc divide_8
            sta MMC5_Mult_High
            ldy tables::inverse, x		; 256/x
            sty MMC5_Mult_Low
            ldy MMC5_Mult_High
            sty Q
            stx MMC5_Mult_Low
            clc
            sbc MMC5_Mult_Low
            sta R 
            rts

            .endproc
        .endif

    .if EXCLUDE_HYPOTENUSE_MMC5 = 0
        .proc hypotenuse
            ldy #$01
            lda FUNCTION_HYPOTENUSE_A, y
            loop:
                mmc5_square
                lda $5206
                pha
                lda $5205
                pha
                dey
                bpl loop
            pla
            sta FUNCTION_ROOT_IN_HIGH
            pla
            sta FUNCTION_ROOT_IN_LOW
            pla
            clc
            adc FUNCTION_ROOT_IN_HIGH
            sta FUNCTION_ROOT_IN_HIGH
            pla
            clc
            adc FUNCTION_ROOT_IN_LOW
            sta FUNCTION_ROOT_IN_LOW

            jsr function::root
            rts

            .endproc
        .endif
.endscope