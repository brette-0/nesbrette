; NESBRETTE - 2024
.if mapper = 5
    .include "mmc5/constants.nesbrette.asm"     ; if using mmc5 register, include constants (register aliases)
    .ifndef _MMC5_MACROS_included
        .include "mmc5/macros.nesbrette.asm"    ; add in needed macros
    .endif
.endif

.define long_branchless_delay_warning           ; comment out to disable this warning

.scope tables

    .if EXCLUDE_ASIN_TABLE = 0
        ; ASIN_TABLE[x] = asin(x / 255)
        asin:
            .byte $00, $00, $00, $01, $01, $01, $01, $02, $02, $02, $02, $02, $03, $03, $03, $03
            .byte $04, $04, $04, $04, $04, $05, $05, $05, $05, $06, $06, $06, $06, $07, $07, $07
            .byte $07, $07, $08, $08, $08, $08, $09, $09, $09, $09, $09, $0a, $0a, $0a, $0a, $0b
            .byte $0b, $0b, $0b, $0c, $0c, $0c, $0c, $0c, $0d, $0d, $0d, $0d, $0e, $0e, $0e, $0e
            .byte $0f, $0f, $0f, $0f, $0f, $10, $10, $10, $10, $11, $11, $11, $11, $12, $12, $12
            .byte $12, $13, $13, $13, $13, $13, $14, $14, $14, $14, $15, $15, $15, $15, $16, $16
            .byte $16, $16, $17, $17, $17, $17, $18, $18, $18, $18, $19, $19, $19, $19, $1a, $1a
            .byte $1a, $1a, $1b, $1b, $1b, $1b, $1c, $1c, $1c, $1c, $1d, $1d, $1d, $1d, $1e, $1e
            .byte $1e, $1e, $1f, $1f, $1f, $1f, $20, $20, $20, $20, $21, $21, $21, $22, $22, $22
            .byte $22, $23, $23, $23, $23, $24, $24, $24, $25, $25, $25, $25, $26, $26, $26, $27
            .byte $27, $27, $27, $28, $28, $28, $29, $29, $29, $2a, $2a, $2a, $2a, $2b, $2b, $2b
            .byte $2c, $2c, $2c, $2d, $2d, $2d, $2e, $2e, $2e, $2f, $2f, $2f, $2f, $30, $30, $31
            .byte $31, $31, $32, $32, $32, $33, $33, $33, $34, $34, $34, $35, $35, $36, $36, $36
            .byte $37, $37, $37, $38, $38, $39, $39, $39, $3a, $3a, $3b, $3b, $3c, $3c, $3d, $3d
            .byte $3d, $3e, $3e, $3f, $3f, $40, $40, $41, $41, $42, $43, $43, $44, $44, $45, $46
            .byte $46, $47, $48, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $50, $51, $53, $55, $5a
    .endif

    .if EXCLUDE_INVERSE_TABLE = 0
        ; INV_TABLE[x] = 256 / x
        invert:
            .byte $ff, $ff, $80, $55, $40, $33, $2a, $24, $20, $1c, $19, $17, $15, $13, $12, $11
            .byte $10, $0f, $0e, $0d, $0c, $0c, $0b, $0b, $0a, $0a, $09, $09, $09, $08, $08, $08
            .byte $08, $07, $07, $07, $07, $06, $06, $06, $06, $06, $06, $05, $05, $05, $05, $05
            .byte $05, $05, $05, $05, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
            .byte $04, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
            .byte $03, $03, $03, $03, $03, $03, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
            .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
            .byte $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
            .byte $02, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
            .byte $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    .endif
.endscope

.scope function

    .if (MAPPER = 5)
        .include "mmc5/nesbrette.asm"
    .endif


    .if (EXCLUDE_MULTIPLY_8 = 0) .and !(MAPPER = 5)
        .proc multiply_8
            ; a = base
            ; x = iter
            ; returns a with low byte
            
            base = FUNCTION_MULTIPLY_FIRST
            
            sta base
            clc
            loop:
                adc base
                dex
                bne loop
            rts
            .endproc
    .endif
    
    .if (EXCLUDE_MULTIPLY_16 = 0) .and !(MAPPER = 5)
        .proc multiply_16
            ; a = base
            ; x = iter
            ; returns FUNCTION_MULTIPLY_OUT_HIGH as high byte
            ; returns a with low byte

            base = FUNCTION_MULTIPLY_FIRST
            high = FUNCTION_MULTIPLY_OUT_HIGH

            sta base
            clc
            loop:
                adc base
                bcc skip:
                    inc $01
                skip: dex
                bne loop
            rts 

            .endproc
    .endif

    .if EXCLUDE_ASIN_TABLE + EXCLUDE_ASIN_FRAC = 0
        .proc asin_frac
            ; returns a as degrees
            numerator   = ASIN_DECIMAL_DENOMINATOR
            denominator = ASIN_DECIMAL_DIVISOR

            lda #-1
            sta FUNCTION_DIVIDE_DENOMINATOR
            lda demoninator
            sta FUNCTION_DIVIDE_DIVISOR
            jsr divide_8
            lda numerator
            .if MAPPER = 5
                sta MMC5_MULT_WRITE_HIGH
                stx MMC5_MULT_WRITE_LOW
                lda MMC5_MULT_READ_LOW
            .else
                sta FUNCTION_MULTIPLY_FIRST
                jsr multiply_8  ; return a with low value from multiplacation
            .endif
            tay
            lda tables::asin, y
            rts
            .endproc
    .endif

    .if (MAPPER = 5) .and (EXCLUDE_INVERSE_TABLE = 0)
        .if EXCLUDE_MMC5_DIVIDE = 0
            .define divide_8 mmc5::divide_8
        .elseif EXCLUDE_2A03_DIVIDE = 0
            .define divide_8 2a03_divide_8
        .endif
    .elseif EXCLUDE_2A03_DIVIDE = 0
        .define divide_8 2a03_divide_8
    .endif

    
    .if EXCLUDE_2A03_DIVIDE = 0
        .proc 2a03_divide_8
            ; PARAMS SET IN ADDRESS FILE
            ; returns:
            ;   x - quotient
            ;   a - remainder

            denominator = FUNCTION_DIVIDE_DENOMINATOR
            divisor     = FUNCTION_DIVIDE_DIVISOR
            .if DIVIDE_FAST_POWER_OF_TWO = 0
                temp    = FUNCTION_DIVIDE_TEMP
            .endif

            ldx #$00            ; initialize x
            lda divisor
            .if CHECK_FOR_ZERODIVISIONERROR = 1
                .if BREAK_ON_ZERODIVISIONERROR = 0
                    bne nonzero ; if a nonzero leave
                    dex         ; otherwise store max int
                    txa         ; and max numerator
                    rts         ; leave with no calculations
                nonzero:
                .else
                    brk
                .endif
            .endif
            
            sec
            sbc #$01
            bne not_one         ; if (a-1) [does not check for zerodivision]
            txa                 ; x "0" --> A   [no remainder]
            ldx denominator     ; Quotient = Denominator [no division]
            rts                 ; leave
            not_one:


            .if DIVIDE_FAST_POWER_OF_TWO = 1
                and divisor     ; check for power of 2
                bne @not_power  ; leave if it can't apply
                
                ldx #$00
                lda divisor
                lsr
                @_loop:         ; calculate shift amount/mask index
                    inx
                    lsr
                    bcc @_loop

                lda denominator
                @loop:          ; shift as appropriate
                    lsr
                    dex
                    bpl @loop
                tax 

                lda denominator
                and mask-1, x   ; mask for remainder
                
                rts
                mask: .byte $01, $03, $07, $0f, $1f, $3f, $7f
            @not_power:
            .endif

            lda dividend
            sec
            loop:
                inx         ; d fits into n (x + 1) times --> modify x
                sbc divisor
                bcs loop    ; check for underflow
            dex
            adc divisor     ; add with carry d to get numerator
            rts

            .endproc
        .endif

    .if EXCLUDE_ROOT = 0
        .proc root
            
            root    = FUNCTION_ROOT_ROOT
            rem     = FUNCTION_ROOT_REM
            numh    = FUNCTION_ROOT_IN_HIGH
            numl    = FUNCTION_ROOT_IN_LOW

            lda #$00
            sta root
            sta rem
            tax

            loop1: 
                sec
                lda numh
                sbc #$40
                tay
                lda rem
                sbc root
                bcc loop2
                sty numh
                sta rem

            loop2: 
                rol root
                asl numl
                rol numh
                rol rem
                asl numl
                rol numh
                rol rem
                dex
                bne loop1
            
            rts        
            .endproc
        .endif

    .if (EXCLUDE_SQUARE_TABLE) = 0
        ; big endian
        SQUARE_TABLE:
            .byte $00, $01, $04, $09, $10, $19, $24, $31, $40, $51, $64, $79, $90, $a9, $c4
        .endif
    .if (EXCLUDE_EXTENDED_SQUARE_TABLE) = 0
            .word $09c4, $0a29, $0a90, $0af9, $0b64, $0bd1, $0c40, $0cb1, $0d24, $0d99, $0e10, $0e89, $0f04, $0f81, $1000, $1081
            .word $1104, $1189, $1210, $1299, $1324, $13b1, $1440, $14d1, $1564, $15f9, $1690, $1729, $17c4, $1861, $1900, $19a1
            .word $1a44, $1ae9, $1b90, $1c39, $1ce4, $1d91, $1e40, $1ef1, $1fa4, $2059, $2110, $21c9, $2284, $2341, $2400, $24c1
            .word $2584, $2649, $2710, $27d9, $28a4, $2971, $2a40, $2b11, $2be4, $2cb9, $2d90, $2e69, $2f44, $3021, $3100, $31e1
            .word $32c4, $33a9, $3490, $3579, $3664, $3751, $3840, $3931, $3a24, $3b19, $3c10, $3d09, $3e04, $3f01, $4000, $4101
            .word $4204, $4309, $4410, $4519, $4624, $4731, $4840, $4951, $4a64, $4b79, $4c90, $4da9, $4ec4, $4fe1, $5100, $5221
            .word $5344, $5469, $5590, $56b9, $57e4, $5911, $5a40, $5b71, $5ca4, $5dd9, $5f10, $6049, $6184, $62c1, $6400, $6541
            .word $6684, $67c9, $6910, $6a59, $6ba4, $6cf1, $6e40, $6f91, $70e4, $7239, $7390, $74e9, $7644, $77a1, $7900, $7a61
            .word $7bc4, $7d29, $7e90, $7ff9, $8164, $82d1, $8440, $85b1, $8724, $8899, $8a10, $8b89, $8d04, $8e81, $9000, $9181
            .word $9304, $9489, $9610, $9799, $9924, $9ab1, $9c40, $9dd1, $9f64, $a0f9, $a290, $a429, $a5c4, $a761, $a900, $aaa1
            .word $ac44, $ade9, $af90, $b139, $b2e4, $b491, $b640, $b7f1, $b9a4, $bb59, $bd10, $bec9, $c084, $c241, $c400, $c5c1
            .word $c784, $c949, $cb10, $ccd9, $cea4, $d071, $d240, $d411, $d5e4, $d7b9, $d990, $db69, $dd44, $df21, $e100, $e2e1
            .word $e4c4, $e6a9, $e890, $ea79, $ec64, $ee51, $f040, $f231, $f424, $f619, $f810, $fa09, $fc04, $fe01
        .endif       

    .if EXCLUDE_HYPOTENUSE = 0
        .proc hypotenuse
            ; $00 adjacent
            ; $01 opposite

            ldy #$01
            loop:
                lax FUNCTION_HYPOTENUSE_A, y
                cmp #$16
                bcc @use_short_table
                .if EXCLUDE_EXTENDED_SQUARE_TABLE = 1
                    brk                     ; if this crash is triggered, you need to disable the EST exclude
                .else
                    clc
                    sbc #16
                    clc ;? redundant
                    asl
                    adc #16
                    tax
                    lda SQUARE_TABLE+1, x
                    pha
                    lda SQUARE_TABLE, x
                    pha
                    bne @next_target
                .endif

                @use_short_table:
                    lda SQUARE_TABLE, x
                    pha
                    lda #$00
                    pha
                
                @next_target:
                    dey
                    bpl loop
            pla
            sta FUNCTION_ROOT_IN_HIGH
            pla
            sta FUNCTION_ROOT_IN_LOW
            pla
            clc
            adc FUNCTION_ROOT_IN_HIGH
            sta FUNCTION_ROOT_IN_HIGH
            pla
            clc
            adc FUNCTION_ROOT_IN_LOW
            sta FUNCTION_ROOT_IN_LOW

            jsr function::root
            rts

            .endproc
        .endif    
    .endscope


.scope raycast
    .if EXCLUDE_RAYCAST_CALCULATE = 0
        .proc calculate
            ; accessing interval quantity is erroneous if theta coefficient is enabled
            ; modifying theta coefficicient is only reccomended if the code is well understood
            ; it can cause performance issues or unexpected flaws in collision code if done incorrectly
            ; leaks into _calculate@body
            
            .ifdef mmc5::hypotenuse
                jsr function::mmc5::hypotenuse
            .else
                jsr function::hypotenuse
            .endif

            lda #interval
            
            .if USE_FIXED_INTERVAL = 1
                sta RAYCAST_INTERVAL_ADDR
            .endif

            .endproc
    .endif
    .if !(EXCLUDE_THETA_COEFFICIENT .and EXCLUDE_RAYCAST_CALCULATE)
        .proc _calculate_body
            interval        = RAYCAST_FIXED_INTERVAL

            lda FUNCTION_ROOT_ROOT  ; ? redundant
            sta FUNCTION_DIVIDE_DENOMINATOR
            
            sta FUNCTION_DIVIDE_DIVISOR
            jsr function::divide_8
            cmp #(interval >> 1)    ; remaider above half dividend
            bcc @noround
            inx                     ; round up divident
            @noround:
            txa
            pha

            lda FUNCTION_HYPOTENUSE_A
            sta FUNCTION_DIVIDE_DENOMINATOR
            stx FUNCTION_DIVIDE_DIVISOR
            jsr function::divide_8

            stx RAYCAST_A_COARSE
            sta RAYCAST_A_FINE
            pla
            tax
            lda FUNCTION_HYPOTENUSE_O
            sta FUNCTION_DIVIDE_DENOMINATOR
            stx FUNCTION_DIVIDE_DIVISOR
            jsr function::divide_8
            stx RAYCAST_O_COARSE
            sta RAYCAST_O_FINE
            rts
            .endproc
    .endif

        .if EXCLUDE_THETA_COEFFICIENT = 0
            .proc theta_coefficient
                ; doesn't apply theta coefficient to any raycast values, storage is handled seperately
                ; must be called after calculating raycast core
                interval        = RAYCAST_FIXED_INTERVAL
                lda #interval
            
                .if USE_FIXED_INTERVAL = 1
                    sta RAYCAST_INTERVAL_ADDR
                .endif

                .ifdef function::mmc5::hypotenuse
                    jsr function::mmc5::hypotenuse
                .else
                    jsr function::hypotenuse
                .endif

                lda FUNCTION_ROOT_ROOT  ; access original hypotenuse (? redundant)
                sta FUNCTION_DIVIDE_DIVISOR
                lda #255                ; end denominator
                sta FUNCTION_DIVIDE_DENOMINATOR
                jsr function::divide_8
                lda FUNCTION_HYPOTENUSE_O
                .if (MAPPER = 5)
                    sta $5205
                    txa
                    sta $5206
                    lda $5205
                .else
                    jsr function::multiply_8
                .endif
                eor #$7f
                and #$7f                ; mirror up to half access (higher the number --> closer to 45 degrees)
                tay
                lda tables::asin, y

                ; use X MSB of available information
                .if 5 - THETA_COEFFICIENT_COMPLEXITY
                    rshift (5 - THETA_COEFFICIENT_COMPLEXITY)        
                .endif

                sta RAYCAST_TEMP
                lda RAYCAST_INTERVAL_ADDR
                sec
                sbc RAYCAST_TEMP
                sta RAYCAST_INTERVAL_ADDR

                jmp _calculate_body     ; return after calculating splits
            .endproc
    .endif
    .endscope

.if EXCLUDE_UNSAFE_SET_FLAGS = 0
    .proc set_flags
        ; a = flags
        pha
        jsr @temp
        rts
 @temp: rti
        .endproc
    .endif