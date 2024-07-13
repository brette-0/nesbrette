.proc multiply_16
    ; takes in two 8 bit nums into a 16 bit output
    
    Base        = FUNCTION_MATH_MULTIPLY_BASE
    Temp        = FUNCTION_MATH_MULTIPLY_TEMP
    Mulitplier  = FUNCTION_MATH_MULTIPLY_MULTIPLIER
    Result      = FUNCTION_MATH_MULTIPLY_OUTPUT
    Mult_Temp   = FUNCTION_MATH_MULTIPLY_TEMP+4


    lda #$00
    tay
    sta (Result), y
    iny
    sta (Result), y     ; clean output
    iny
    sta (Result), y
    iny
    sta (Result), y

    sta (Temp), y       ; and temp hi-byte
    dey
    sta (Temp), y

    ldy #$00
    lda (Base), y
    sta (Temp), y       ; while writing current info into temp
    iny
    lda (Base), y
    sta (Temp), y
    lda (Mulitplier), y
    sta (Mult_Temp), y
    dey
    lda (Mulitplier), y
    sta (Mult_Temp), y

    lda #$01            ; prevent immediate exit
    
    @loop:
        clc

    @_loop:
        beq exit
        rol (Temp), y
        iny
        rol (Temp), y
        iny
        rol (Temp), y
        iny
        rol (Temp), y
        
        ldy #$00
        lsr (Mult_Temp), y
        iny
        ror (Mult_Temp), y
        ldy #$00
        bcc @_loop
        
        clc
        lda (Result), y
        adc (Temp), y
        sta (Result), y
        iny
        lda (Result), y
        adc (Temp), y
        sta (Result), y
        iny
        lda (Result), y
        adc (Temp), y
        sta (Result), y
        iny
        lda (Result), y
        adc (Temp), y
        sta (Result), y ; 32bit math
        
        ldy #$01
        lda (Mult_Temp), y
        clc
        dey
        adc (Mult_Temp), y
        cmp #$00 
        beq exit
        bcs @loop       ; cmp #$00 will never yield clear carry

    @exit:
        rts
    .endproc

; Profiling:
; Size:
;   
;   
;---------------------------------------------------------------
; Speed:
;   This routine is less formulaic to quanitfy its speed
;   due to the nature of the checks, the more zeroes in a number the longer the iteration is
;   however the the sooner the highest set bit is shifted into carry, the sooner it exits.