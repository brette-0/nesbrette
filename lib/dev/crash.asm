; Worlds best Console Crash Screen

.scope crash

.macro crashscreen __OAM$__, __charmapcallback$__


.ifndef __OAMRAM$__
    OAMRAM = $02    ; if not specified
.else
    OAMRAM = __OAMRAM$__
.endif

.segment CRASHPRG
    ; preserve rules for return, modify to skip shadow writes
    ; as there will be no interrupts, and we want this to be small
    ; speed does NOT matter here

    ret_pasw = PerformAutomaticShadowWrites
    rule PerformAutomaticShadowWrites, allow

    lda #%00100000  ; no NMI, shared CHR, short sprites, NT0, horizontal inc mode
    sta PPUCTRL
    sta PPUMASK

    lda PPUPSTAT    ; free latch (needs to be done only once)
    lda #$3e
    sta PPUADDR
    ldx #$ff
    stx PPUADDR     ; ppuaddr => ciram[1]
    inx
    stx PPUMASK     ; disable video out

    clear_OAM:
        sta OAMRAM, x
        inx
        bne clear_OAM

    lda #OAMRAM
    sta OAMDMA      ; clean sprites

    ; PPUADDR = 3eff | ax = 0

    ldx #11
    Pallete_Outter:
    ldy #2
    Palette:
        lda Colours, y
        sta PPUDATA
        dey
        bne Palette
        dex
        bne Pallete_Outter

    ; PPUADDR  $3f20

    lda #$3f
    sta PPUDATA
Colours:
    .byte $20, $10, $00

    __charmapcallback$__                        ; call macro to set previous charmap
    rule PerformAutomaticShadowWrites, ret_pasw
.endmacro

.endscope