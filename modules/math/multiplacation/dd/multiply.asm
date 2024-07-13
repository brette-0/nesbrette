.proc multiply
    ; takes in two var width nums into another var width num
    
    Temp        = FUNCTION_MATH_MULTIPLY_TEMP
    Mulitplier  = FUNCTION_MATH_MULTIPLY_MULTIPLIER
    Result      = FUNCTION_MATH_MULTIPLY_OUTPUT
    Mult_Temp   = FUNCTION_MATH_MULTIPLY_MULT_TEMP
    LAST        = FUNCTION_MATH_MULTIPLY_LAST
    Width       = FUNCTION_MATH_MULTIPLY_WIDTH

    lda Width
    tax
    asl
    tay
    lda #$00
    @clean:
        sta (Result), y
        sta (Temp),   y 
        dey
        dex
        bne @clean
    @clean2:
        sta (Result), y
        dey
        bne @clean2

    ldy Width
    @copy:
        lda (Result), y
        sta (Temp), y
        lda (Mulitplier), y
        sta (Mult_Temp),  y
        dey
        bne @copy

    ldx Width
    ldy #$ff
    @scan:
        iny
        lda (Result), y
        beq @scan
    sty Last
    
    lda #$01            ; prevent immediate exit
    ldy #$00

    @loop:
        clc

    @_loop:
        beq exit
        lda (Width), y
        asl
        tax
        ldy #$00
        @ls:
            rol (Temp), y
            iny
            dex
            bne @ls

        ldy #$00
        ldx Width
        @rs:
            ror (Mult_Temp), y
            iny
            dex
            bne @rs

        bcc @_loop
        
        clc
        ; setup addition dirty dynamic
        jsr math::addition_dd

        ldy Last
        lda (Mult_Temp), y
        cmp #$00 
        bne @loop       ; cmp #$00 will never yield clear carry
        inc (Last),  y
        lda (Last),  y
        cmp (Width), y
        bne @loop       ; if not finished all, leave

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