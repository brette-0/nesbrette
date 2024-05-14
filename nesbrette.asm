; NESBRETTE - 2024

.include "excludes.nesbrette.asm"
.include "adresses.nesbrette.asm"

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

.macro rne target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            beq @temp
                rts
            @temp:
        .else
            bne target
        .endif
    .else
        .local @temp
        beq @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rcs target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bcc @temp
                rts
            @temp:
        .else
            bcs target
        .endif
    .else
        .local @temp
        bcc @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rcc target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bcs @temp
                rts
            @temp:
        .else
            bcc target
        .endif
    .else
        .local @temp
        bcc @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rpl target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bmi @temp
                rts
            @temp:
        .else
            bpl target
        .endif
    .else
        .local @temp
        bmi @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rmi target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bpl @temp
                rts
            @temp:
        .else
            bmi target
        .endif
    .else
        .local @temp
        bpl @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rvc target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bvs @temp
                rts
            @temp:
        .else
            bvc target
        .endif
    .else
        .local @temp
        bvs @temp
            rts
        @temp:
    .endif

    .endmacro

.macro rvs target
    .ifdef target
        .feature force_range
        .if (target - *) > 128 || (target - *) < -127
            .local @temp
            bvc @temp
                rts
            @temp:
        .else
            bvc target
        .endif
    .else
        .local @temp
        bvc @temp
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
.macro abeq target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jeq target
    .else
        beq target
    .endif
    .endmacro
.macro abne target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jne target
    .else
        bne target
    .endif
    .endmacro
.macro abpl target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jpl target
    .else
        bpl target
    .endif
    .endmacro
.macro abmi target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jmi target
    .else
        bmi target
    .endif
    .endmacro
.macro abcc target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jcc target
    .else
        bcc target
    .endif
    .endmacro
.macro abcs target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jcs target
    .else
        bcs target
    .endif
    .endmacro
.macro abvc target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jvc target
    .else
        bvs target
    .endif
    .endmacro
.macro abvs target
    .feature force_range    ; allow negative integer literals
    .if (target - *) > 128 || (target - *) < -127
        #common::jvs target
    .else
        bvc target
    .endif
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
    .if EXCLUDE_DIVIDE = 0
        .proc divide
            ; PARAMS SET IN ADDRESS FILE
            ; returns:
            ;   x - divident
            ;   a - modulo

            n = FUNCTION_DIVIDE_NUMERATOR
            d = FUNCTION_DIVIDE_DENOMINATOR

            ldx #$00        ; initialize x
            lda n           ; load numerator
            loop:
                inx         ; d fits into n (x + 1) times --> modify x
                clc
                sbc d       ; subtract demoninator from current
                bpl loop    ; check if underflow, if not repeat
            dex             ; decrease to reverse initial increment

            .endproc
    .endif
    .endscope