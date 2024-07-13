.if __EXCLUDE_MACRO_PUSH_MORE_REGISTERS = 0
    .macro phx
        txa
        pha
    .endmacro

    .macro phy
        tya
        pha
    .endmacro

    .macro plx
        pla
        tax
    .endmacro

    .macro ply
        pla
        tay
    .endmacro
    .endif

.if __EXCLUDE_DELAY = 0
    .macro delay cycles
        .setcpu "6502x"             ; enables illegal opcodes
        .ifblank cycles
            .byte $04, $00          ; just NOP for 2 cycles! I'm not the weird one here you are :P
            .exitmacro              ; default = 3 cycles
        .elseif (cycles > 4)
            .if MACROS_DELAY_INEFFICIENT_BRANCHLESS_WARNING = 1
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
    .endif

.if __EXCLUDE_SHIFT
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
    .endif 

.if __EXCLUDE_CONDITIONAL_JUMP = 0
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
    .endif

.macro ijsr ram
    .local leave

    lda >leave
    pha
    lda <leave
    pha
    
    jmp (ram)
    leave:
        rts

    .endmacro