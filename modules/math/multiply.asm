.proc multiply
    ; ioptr
    output          = FUNCITON_MATH_MULTIPLICATION_OUT
    otemp           = FUNCITON_MATH_MULTIPLICATION_OUTTEMP
    itemp           = FUNCITON_MATH_MULTIPLICATION_INTEMP
    multiplier      = FUNCITON_MATH_MULTIPLICATION_MULTIPLIER
    width           = FUNCITON_MATH_MULTIPLICATION_WIDTH

    ldy width
    asl

    @copy_out:
        lda (output), y     ; load the output
        sta (otemp), y      ; copy into temp variable
        dey
        bpl @copy           ; copy out output


    ldy width
    @copy_in:
        lda (multiplier), y ; load the output
        sta (itemp), y      ; copy into temp variable
        dey
        bpl @copy           ; copy out output
    

    @loop:
        clc
        ldy width
        @rshift:
            @noadj:
                lda (itemp), y
                ror
                dey
                bpl @rshift

        bcc @skip           ; if last bit was clear, do not add

        clc
        ldy #$00
        @sum:
            lda (output), y
            adc (otemp), y
            sta (output), y
            iny
            cpy width
            bne @sum

        ; applied otemp to output

        @skip:
            lda #$00
            tay
            @adjust:
                rla (otemp), y
                iny
                cpy width
                bne @adjust
            
            ldy width
            @scan:
                dey
                lda (itemp), y
                bne @loop 

    rts
    .endproc