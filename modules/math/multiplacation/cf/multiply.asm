.proc multiply
    ; takes in two var width nums into another var width num
    
    Base        = FUNCTION_MATH_MULTIPLY_BASE
    Temp        = FUNCTION_MATH_MULTIPLY_TEMP
    Mulitplier  = FUNCTION_MATH_MULTIPLY_MULTIPLIER
    Result      = FUNCTION_MATH_MULTIPLY_OUTPUT
    Mult_Temp   = FUNCTION_MATH_MULTIPLY_MULT_TEMP
    LAST        = FUNCTION_MATH_MULTIPLY_LAST
    Width       = FUNCTION_MATH_MULTIPLY_WIDTH

    lda Width
    tay
    asl
    tax
    lda #$00
    @clean:
        sta Result, x
        sta Temp,   x 
        dex
        dey
        bne @clean
    @clean2:
        sta Result, x
        dex
        bne @clean2

    ldx Width
    @copy:
        lda Base, x
        sta Temp, x
        lda Mulitplier, x
        sta Mult_Temp,  x
        dex
        bne @copy

    ldy Width
    ldx #$ff
    @scan:
        inx
        lda Base, x
        beq @scan
    stx Last
    
    lda #$01            ; prevent immediate exit

    @loop:
        clc

    @_loop:
        beq exit
        lda Width
        asl
        tay
        ldx #$00
        @ls:
            rol Temp, x
            inx
            dey
            bne @ls

        ldx #$00
        ldy Width
        @rs:
            ror Mult_Temp, x
            inx
            dey
            bne @rs

        bcc @_loop
        
        clc
        ; setup addition dirty dynamic
        jsr math::addition_dd

        ldx Last
        lda Mult_Temp, x
        cmp #$00 
        bne @loop       ; cmp #$00 will never yield clear carry
        inc Last
        lda Last
        cmp Width
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