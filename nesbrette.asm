; NESBRETTE - 2024

.include  "excludes.nesbrette.asm"
.include  "adresses.nesbrette.asm"
.include "constants.nesbrette.asm"
.define long_branchless_delay_warning           ; comment out to disable this warning

.macro phx
    sta $00
    txa
    pha
    lda $00
    .endmacro

.macro plx
    sta $00
    pla
    tax
    lda $00
    .endmacro

.macro phy
    sta $00
    tya
    pha
    lda $00
    .endmacro

.macro ply
    sta $00
    pla
    tay
    lda $00
    .endmacro


.macro delay cycles
    .setcpu "6502x"             ; enables illegal opcodes
    .ifblank cycles
        .byte $04, $00          ; just NOP for 2 cycles! I'm not the weird one here you are :P
        .exitmacro              ; default = 3 cycles
    .elseif (cycles > 4)
        .ifdef long_branchless_delay_warning
            .warning "A Solution with branches will yield a more size efficient solution"
        .endif
    .endif

    .if (cycles & 1)
        .if (cycles & 2)
            .byte $04, $00
            .repeat ((cycles - 3) >> 2)
                .byte $14, $00 
            .endrepeat

            .if ((cycles - 3) & 2)
                nop
            .endif
            
        .else
            .error "No legal or illegal opcode can delay by a singular cycle! Perhaps change prior memory adress modes or use an illegal variant!"
        .endif
    .else
        .repeat (cycles >> 2)
            .byte $14, $00 
        .endrepeat

        .if (cycles & 2)
            nop
        .endif
    .endif
    .endmacro

.macro rshift dist
    .if dist .mod 9 = 0
        .exitmacro
    .endif
    .if dist .mod 9 > 5
        .repeat 9 - dist .mod 9
            rol
        .endrepeat
        .if dist .mod 9 = 6
            and #%00000011
        .elseif dist .mod 9 = 7
            and #%00000001
        .else                   ; msb becomes carry
            lda #$00
        .endif
    .else
        .repeat dist .mod 9
            lsr
        .endrepeat
    .endif
    .endmacro

.macro lshift dist
        .exitmacro
    .if dist .mod 9 > 5
        .repeat 9 - dist .mod 9
            ror
        .endrepeat
        .if dist .mod 9 = 6
            and #%00000011
        .elseif dist .mod 9 = 7
            and #%00000001
        .else                   ; lsb becomes carry
            lda #$00
        .endif
    .else
        .repeat dist .mod 9
            asl
        .endrepeat
    .endif
    .endmacro

    .define Dpad_UP     $08
    .define Dpad_Down   $04
    .define Dpad_Left   $02
    .define Dpad_Right  $01

    .define Select      $20
    .define Start       $10
    
    .define Y_Button    $40
    .define B_Button    $80
    .define X_Button    $04
    .define A_Button    $08

    .define L_Button    $02
    .define R_Button    $01

    .macro alligned_poll    ; macro because it cant be branched to (I think?)
        .local @poll_inputs

        @poll_inputs:
        lda $4017           ; put get put GET
        and #$03            ; put get
        cmp #$01            ; put get
        rol $fd, x          ; put get put get put get
        lda $4016           ; put get put GET
        and #3              ; put get
        cmp #1              ; put get
        rol $fb, x          ; put get put get put get
        #common::delay 3    ; put get put
        bcc @poll_inputs    ; get put [get]
        #common::delay 3    ; put get put
        dex                 ; put get
        bpl @poll_inputs    ; get put [get]                 ; this can't be on a zp boundary because logic
        
        .endmacro
    .if EXCLUDE_SNES_POLL_FAST_SINGLE = 0
        .proc poll              ; optimize because we can
            @poll_inputs:
            lda $4017           ; put get put GET
            and #$03            ; put get
            cmp #$01            ; put get
            rol $fd, x          ; put get put get put get
            lda $4016           ; put get put GET
            and #3              ; put get
            cmp #1              ; put get
            rol $fb, x          ; put get put get put get
            bcc @poll_inputs    ; get put [get]
            dex                 ; put get
            bpl @poll_inputs    ; get put [get]                 ; this can't be on a zp boundary because logic
            
            rts
            .endproc
    .endif
.macro req target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bne @temp
                rts
            @temp:
        .else
            beq target
        .endif
    .else
        .local @temp
        bne @temp
            rts
        @temp:
    .endif

    .endmacro

.macro jeq target
    .local @temp
        bne @temp
            jmp target
        @temp:
    .endmacro

.macro jne target
    .local @temp
        beq @temp
            jmp target
        @temp:
    .endmacro

.macro jcc target
    .local @temp
        bcs @temp
            jmp target
        @temp:
    .endmacro

.macro jcs target
    .local @temp
        bcc @temp
            jmp target
        @temp:
    .endmacro

.macro jpl target
    .local @temp
        bmi @temp
            jmp target
        @temp:
    .endmacro

.macro jmi target
    .local @temp
        bpl @temp
            jmp target
        @temp:
    .endmacro

.macro jvs target
    .local @temp
        bvc @temp
            jmp target
        @temp:
    .endmacro

.macro jvc target
    .local @temp
        bvs @temp
            jmp target
        @temp:
    .endmacro


.if EXCLUDE_UNSAFE_SET_FLAGS = 0
    .proc set_flags
        ; a = flags
        pha
        jsr @temp
        @temp: rti
        .endproc
    .endif

.scope function
    
    .if EXCLUDE_MULTIPLY_8 = 0
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
    
    .if EXCLUDE_MULTIPLY_16 = 0
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

    .if EXCLUDE_ASIN_TABLE + EXCLUDE_ASIN_DECIMAL = 0
        .proc asin_decimal
            ; returns a as degrees
            numerator   = ASIN_DECIMAL_NUMERATOR
            denominator = ASIN_DECIMAL_DENOMINATOR

            lda #-1
            sta FUNCTION_DIVIDE_NUMERATOR
            lda demoninator
            sta FUNCTION_DIVIDE_DENOMINATOR
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
            lda ASIN_TABLE, y
            rts
            .endproc
    .endif

    .if EXCLUDE_ASIN_TABLE = 0


        ; ASIN_TABLE[x] = asin(x / 256)
        ASIN_TABLE:
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

    .if EXCLUDE_DIVIDE = 0
        .proc divide_8
            ; PARAMS SET IN ADDRESS FILE
            ; returns:
            ;   x - divident
            ;   a - modulo

            n = FUNCTION_DIVIDE_NUMERATOR
            d = FUNCTION_DIVIDE_DENOMINATOR
            t = FUNCTION_DIVIDE_TEMP

            ldx #$00        ; initialize x
            lda d
            
            .if RELEASE = 1 ; if release, prevent hard crashes
                bne nonzero ; if a nonzero leave
                dex         ; otherwise store max int
                txa         ; and max numerator
                rts         ; leave with no calculations
            nonzero:
            .endif
            
            sec
            sbc #$01
            bne not_one
            .if DIVIDE_FAST_POWER_OF_TWO    ; probably only useful with high numerators and frequent power of two denominators
                
                and d
                bne @not_power
                ; denominator is a power of 2, shifting is faster
                lda n
                pha
                    lda d

                    
                    stx t           ; initialize numerator count

                    @loop:
                        inx         ; log shifts
                        lsr n       ; shift numerator (divide by 2) --> store lost bit into carry
                        ror t       ; roll carry bit into numerator
                        lsr         ; shift denominator right (divide by 2)
                        bcc @loop   ; carry is clear when denominator is empty
                    ; x will always be at least 1, maximum of 8?
                    dex             ; decrease x to reverse /1 affects
                    rol t           ; roll back numerator
                    asl n           ; roll back integer
                    ldy t           ; save numerator
                    stx t           ; log shift into temp
                    lda #$08        ; load max shift
                    sec
                    sbc t           ; subtract unneeded shifts
                    tax             ; store in x
                    sty t           ; restore numerator
                    @_loop:
                        lsr t       ; shift numerator
                        dex         ; decrease shift count
                        bpl @_loop  ; repeat until shift complete
                    ldx n           ; load n (integer) into integer return
                pla
                sta n           ; restore original numerator
                lda t           ; load t (numerator) into numerator return
                rts

            @not_power:
            .endif
            
            not_one:

            lda n           ; load numerator
            sec
            loop:
                inx         ; d fits into n (x + 1) times --> modify x
                sbc d       ; subtract demoninator from current
                bcs loop    ; check if underflow, if not repeat
            dex             ; decrease to reverse initial increment
            adc d           ; add with carry d to get numerator
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

    .if MAPPER = 5
        .macro mmc5_square
            ; a = base
            sta $5205
            sta $5206
            .endmacro 
        .endif            

    .if (EXCLUDE_DIVIDE + EXCLUDE_HYPOTENUSE) = 0
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

    .if ((EXCLUDE_DIVIDE + EXCLUDE_HYPOTENUSE_MMC5) = 0) .and (MAPPER = 5)
        .proc hypotenuse_mmc5
            ldy #$01
            lda FUNCTION_HYPOTENUSE_A, y
            loop:
                mmc5_square
                lda $5206
                pha
                lda $5205
                pha
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
        .endif
    .endscope


.scope raycast
    .if EXCLUDE_RAYCAST_CALCULATE = 0
        .proc calculate
            
            interval        = RAYCAST_FIXED_INTERVAL
            
            .if (EXCLUDE_HYPOTENUSE_MMC5 = 0) .and (MAPPER = 5)
                jsr function::hypotenuse_mcc5
            .else
                jsr function::hypotenuse
            .endif

            lda FUNCTION_ROOT_ROOT  ; ? redundant
            sta FUNCTION_DIVIDE_NUMERATOR
            lda #interval
            sta FUNCTION_DIVIDE_DENOMINATOR
            jsr function::divide_8
            cmp #(interval >> 1)    ; remaider above half dividend
            bcc @noround
            inx                     ; round up divident
            @noround:
            txa
            pha

            lda FUNCTION_HYPOTENUSE_A
            sta FUNCTION_DIVIDE_NUMERATOR
            stx FUNCTION_DIVIDE_DENOMINATOR
            jsr function::divide_8

            stx RAYCAST_A_COARSE
            sta RAYCAST_A_FINE
            pla
            tax
            lda FUNCTION_HYPOTENUSE_O
            sta FUNCTION_DIVIDE_NUMERATOR
            stx FUNCTION_DIVIDE_DENOMINATOR
            jsr function::divide_8
            stx RAYCAST_O_COARSE
            sta RAYCAST_O_FINE

            .if RAYCAST_THETA_COEFFICIENT
                lda FUNCTION_ROOT_ROOT  ; access original hypotenuse
                sta FUNCTION_DIVIDE_DENOMINATOR
                lda #255                ; end denominator
                sta FUNCTION_DIVIDE_NUMERATOR
                jsr function::divide_8
                lda FUNCTION_HYPOTENUSE_O
                jsr function::multiply_8
                tay
                lda ASIN_TABLE, y;
                


            .endif
            rts
            .endproc
    .endif
    .endscope