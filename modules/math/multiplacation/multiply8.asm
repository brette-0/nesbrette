.proc multiply

    output
    otemp
    itemp

    multiplier

    lda output
    sta otemp

    lda multiplier          ; load the multiplier
    sta itemp               ; copy into temp variable

    @loop:
        lsr itemp
        bcc @skip           ; if last bit was clear, do not add

        clc
        
        lda output
        adc otemp
        sta output
        
        lda output+1
        adc otemp+1
        sta output+1        ; applied otemp to output

        @skip:
            asl otemp
            rol otemp+1     ; roll bits left

            lda itemp
            bne @loop       ; 

    rts
    .endproc