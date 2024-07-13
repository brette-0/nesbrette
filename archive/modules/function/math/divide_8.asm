.if TARGET = "CA65"
    .proc divide_8
.else
    .export _divide_8
    .proc _divide_8
.endif
    sta MMC5_Mult_High
    ldy tables::inverse, x		; 256/x
    sty MMC5_Mult_Low
    ldy MMC5_Mult_High
    sty Quotient
    stx MMC5_Mult_Low
    clc
    sbc MMC5_Mult_Low
    sta Remainder
    rts
    .endproc