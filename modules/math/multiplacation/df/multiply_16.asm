.proc multiply_16
    ; takes in two 16 bit nums into a 32 bit output
    
    Base        = FUNCTION_MATH_MULTIPLY_BASE
    Temp        = FUNCTION_MATH_MULTIPLY_TEMP
    Mulitplier  = FUNCTION_MATH_MULTIPLY_MULTIPLIER
    Result      = FUNCTION_MATH_MULTIPLY_OUTPUT
    Mult_Temp   = FUNCTION_MATH_MULTIPLY_TEMP+4

    lda #$00
    sta Temp+2
    sta Temp+3          ; and temp hi-bytes
    lda Result
    sta Temp            ; while writing current info into temp
    lda Result+1
    sta Temp+1
    lda Mulitplier
    sta Mult_Temp
    lda Mulitplier+1
    sta Mult_Temp+1

    lda #$01            ; prevent immediate exit

    @loop:
        clc

    @_loop:
        beq exit
        lsr Temp
        rol Temp+1
        rol Temp+2
        rol Temp+3

        ror Mult_Temp+1
        lsr Mult_Temp
        bcc @_loop
        
        clc
        lda Result
        adc Temp
        sta Result
        lda Result+1
        adc Temp+1
        sta Result+1
        lda Result+2
        adc Temp+2
        sta Result+2
        lda Result+3
        adc Temp+3
        sta Result+3    ; 32bit math
        
        lda Mult_Temp
        cmp Mult_Temp+1
        bne @loop
        cmp #$00
        beq exit        ; if (hi == lo && lo == 0) return;
        bcs @loop       ; cmp #$00 will never yield clear carry

    @exit:
        rts
    .endproc

; Profiling:
; Size:
;   91 bytes                            | (with zp stored info)
;  125 bytes                            | (with abs stored info)
;---------------------------------------------------------------
; Speed:
;   This routine is less formulaic to quanitfy its speed
;   due to the nature of the checks, the more zeroes in a number the longer the iteration is
;   however the the sooner the highest set bit is shifted into carry, the sooner it exits.