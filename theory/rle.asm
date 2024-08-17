; This module should be used alongside the tablemaker with keyword "rle_bias"
; with fields "Encoded Length Width" "Seed Width"
; max decoded offset 256

.proc index_table_ioptr
    Seed        = FUNCTION_BIASING_RLE_SEED             ; zp[2]
    Seed_Width  = FUNCTION_BIASING_RLE_SEED_WIDTH       ; abs[2]
    Table       = FUNCTION_BIASING_RLE_TABLE_PTR        ; zp[2]
    Temp        = FUNCTION_BIASING_TEMP                 ; (zp)[2]

    lda #<Seed
    sta FUNCTION_MATH_SUBTRACTION_BASE
    lda #>Seed
    sta FUNCTION_MATH_SUBTRACTION_BASE

    lda #<(Table-2)
    sta FUNCTION_MATH_SUBTRACTION_ADDER
    lda #>(Table)
    sta FUNCTION_MATH_SUBTRACTION_ADDER

    lda Seed_Width
    sta FUNCTION_MATH_SUBTRACTION_WIDTH                 ; prep width
    
    ldx #$00
    sec
    @body:
        lax FUNCTION_MATH_SUBTRACTION_ADDER
        axs #-2                                         ; modify off by 2 bytes
        cpx FUNCTION_MATH_SUBTRACTION_ADDER
        bcc @nomod
        inc FUNCTION_MATH_SUBTRACTION_ADDER
        
        @nomod:
            stx FUNCTION_MATH_SUBTRACTION_ADDER
        
        stx Temp
        sty Temp+1
        jsr math::subtraction_ioptr                     ; call subtraction
        ldx Temp
        ldy Temp+1                                      ; zp restore x/y
        iny
        bcs @body                                       ; sub ioptr should leave c intact
    dey                                                 ; adjust

    rts                                                 ; leave, offset is masked to lobyte
.endproc