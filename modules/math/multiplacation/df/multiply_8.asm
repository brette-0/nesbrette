.proc multiply_16
    ; takes in two 8 bit nums into a 16 bit output
    
    Temp        = FUNCTION_MATH_MULTIPLY_TEMP
    Mulitplier  = FUNCTION_MATH_MULTIPLY_MULTIPLIER
    Result      = FUNCTION_MATH_MULTIPLY_OUTPUT
    Mult_Temp   = FUNCTION_MATH_MULTIPLY_TEMP+2

    lda #$00
    sta Temp+1          ; and temp hi-byte
    lda Result
    sta Temp            ; while writing current info into temp
    lda Mulitplier
    sta Mult_Temp

    lda #$01            ; prevent immediate exit

    @loop:
        clc

    @_loop:
        beq exit
        rol Temp
        rol Temp+1

        lsr Mult_Temp
        bcc @_loop
        
        clc
        lda Result
        adc Temp
        sta Result
        lda Result+1
        adc Temp+1
        sta Result+1    ; 16bit math
        
        lda Mult_Temp
        cmp #$00 
        beq exit
        bcs @loop       ; cmp #$00 will never yield clear carry

    @exit:
        rts
    .endproc

; Profiling:
; Size:
;   41 bytes                            | (with zp stored info)
;   55 bytes                            | (with abs stored info)
;---------------------------------------------------------------
; Speed:
;   This routine is less formulaic to quanitfy its speed
;   due to the nature of the checks, the more zeroes in a number the longer the iteration is
;   however the the sooner the highest set bit is shifted into carry, the sooner it exits.