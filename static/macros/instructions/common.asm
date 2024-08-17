.macro ijsr target
    .local exit

    lda #<exit
    pha
    lda #>exit
    pha

    jmp target
    @exit:

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

.macro xrshift dist
    .local loop
    @loop:
        lsr
        dex
        bpl @loop
    
    .endmacro

.macro xlshift dist
    .local loop
    @loop:
        asl
        dex
        bpl @loop
    
    .endmacro

.macro push addr
    lda #>addr
    pha
    lda #<addr
    pha
    .endmacro

.macro pull addr
    pla
    sta addr
    pla
    sta addr+1
    .endmacro


.macro compare first, second, width, endian
    .local body

    .if endian = 1
        ldx width

        @body:
            lda first, x
            cmp second, x
            beq @next
            bcs @exit
        @next:
            dex
            bpl @body
            clc
        @exit:
            rts
        .exitmacro
    .else
        ldx #$00

        @body:
            lda first, x
            cmp second, x
            beq @next
            bcs @exit
        @next:
            inx
            cpx width
            bne @body
            clc
        @exit:
            rts
        .exitmacro
    .endmacro


.macro compareptr first, second, width, endian
    .local body

    .if endian = 1
        ldy width

        @body:
            lda (first), y
            cmp (second), y
            beq @next
            bcs @exit
        @next:
            dey
            bpl @body
            clc
        @exit:
            rts
        .exitmacro
    .else
        ldy #$00

        @body:
            lda (first), y
            cmp (second), y
            beq @next
            bcs @exit
        @next:
            iny
            cpy width
            bne @body
            clc
        @exit:
            rts
        .exitmacro
    .endmacro

.macro copy source target width
    ; use y as width
    .local loop

    .ifndef width
        width = -1
    .if width > 0
        ldy #width
        .endif

    lda #<source
    sta $00
    lda #>source
    sta $01
    lda #<target
    sta $02
    lda #>target
    sta $03
    
    @loop:
        lda ($00), y
        sta ($02), y
        dey
        bpl @loop

    .endmacro

.macro copyaddr sourceptr targetptr
    .local loop

    .ifndef width
        width = -1
    .if width > 0
        ldy #width
        .endif

    lda #<sourceptr
    sta targetptr
    lda #>sourceptr
    sta targetptr+1
    .endmacro