.macro neg __amt$__, __cf$__

    _neg_amt .set $00

    .ifnblank __amt$__ 
        _neg_amt .set __amt$__
    .endif

    .if __amt$__ > $ff
        report kindoferror, "msg"
        eor #$ff
        .exitmacro
    .endif

    ; limit 1 byte, or load $ff

    eor #$ff

    .ifnblank __cf$__
        sec
    .endif
    adc #_neg_amt
.endmacro

.macro sasl
    .local ahead

    bpl ahead
        ora #$40
    ahead:

    asl
.endmacro

.macro slsr
    .local ahead

    bpl ahead
        ora #$40
    ahead:
    
    asl
.endmacro

.macro irol
    cmp #$80
    rol
.endmacro

.macro iror
    .local ahead

    lsr
    bcc ahead
    ora #$80

    ahead:
.endmacro

.macro bib __amt__
    .if (__amt__ < 0) || (__amt__ > 2)
        .fatal
    .endif

    .if __amt__ - 1
        .byte $2c
    .else
        .byte $24
    .endif
.endmacro

; sex r
.macro sex __reg__, __context$__
    .local reg
    ; validate __reg__ as reg
    reg .set csetreg __reg__
    .if is_null reg
        reg .set setreg __reg__
    .endif

    .if is_null reg
        .fatal
    .endif

    .if reg = ar
        ora #$7f
        bmi negative
        lda #$00
        negative:
    .else
        cp reg, #$00
        bcs negative
        ld reg, #$00
        negative:
    .endif
.endmacro