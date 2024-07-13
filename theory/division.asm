.proc divide

    Quotient
    Remainder
    Width
    Divisor
 
    QTemp
    STemp

    lda #<FUNCTION_MATH_DIVISION_Temp 
    sta FUNCTION_MATH_ADDITION_OUT
    lda #>FUNCTION_MATH_DIVISION_Temp
    sta FUNCTION_MATH_ADDITION_OUT+1
    lda #<One
    sta FUNCTION_MATH_ADDITION_ADDER
    lda #>One
    sta FUNCTION_MATH_ADDITION_ADDER        ; this might be a case of misuse

    ldx Width
    stx FUNCTION_MATH_ADDITION_WIDTH

    @copyin:
        lda FUNCTION_MATH_DIVISION_Quotient, x
        sta FUNCTION_MATH_DIVISION_Temp, x
        dex
        bne @copyin

    ldx #$00
    
    @body:
        @byte:
            lda Quotient, x
            sec
            sbc Divisor, x
            sta Quotient, x

            bcs @next           ; no need to request borrow

            stx STemp
            inx
            @borrow:
                sec
                lda Quotient, x
                sbc Divisor, x 
                sta Quotient, x

                inx
                cpx Width
                beq @jumper
                bcs @next
                bcc @borrow

            @jumper:
                bcc @exit
                bcs @_next:
                 


            @_next:
            ldx STemp
            @next:              ; perform for each byte
                inx
                cpx Width
                bne @byte

        ; log into Temp



        ; ??? 
        bcs @body               ; if carry set, we didn't underflow last byte (might be unconditional?)

    @exit:
        jsr function::math::addition_dd

    ldx Width
    @copyout:
        lda FUNCTION_MATH_DIVISION_Temp, x
        sta FUNCTION_MATH_DIVISION_Quotient, x
        dex
        bne @copyout
    rts

        One:    .byte $01
    .endproc