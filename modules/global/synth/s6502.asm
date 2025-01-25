; untested
.macro sasl
    .local t

    asl
    bcc t
        ora #$40
    t:  and #~$80
    .endmacro

.macro slsr
    cmp #$80
    ror
    .endmacro

.macro neg __carry__
    eor #$ff
    .ifblank __carry__
        clc
        __carry__ = 0
    .endif

    .if (__carry__ < 0) .or (__carry__ > 1)
        .fatal "Invalid carry value"
        .endif
    
    adc #(1 - __carry__)
    .endmacro

.macro ccf
    rol
    eor #$01
    ror
    .endmacro



.macro iror __reg__
    .ifblank __reg__
        pha
        lsr
        pla
        ror
    .elseif __reg__ = x
        tax
        lsr
        txa
        ror
    .elseif __reg__ = y
        tay
        lsr
        tya
        ror
    .endif

.macro irol
    cmp #$80
    rol
    .endmacro

.macro labs __target__
    lda __target__ | $800
.endmacro

.macro labsx __target__
    lda __target__ | $800, x
.endmacro

.macro labsy __target__
    lda __target__ | $800, y
.endmacro

.macro lybs __target__
    ldy __target__ | $800
.endmacro

.macro lybsx __target__
    ldy __target__ | $800, x
.endmacro

.macro lxbs __target__
    ldx __target__ | $800
.endmacro

.macro lxbsy __target__
    ldx __target__ | $800, y
.endmacro

.macro sabs __target__
    sta __target__ | $800
.endmacro

.macro sabsx __target__
    sta __target__ | $800, x
.endmacro

.macro sabsy __target__
    sta __target__ | $800, y
.endmacro

.macro sybs __target__
    sty __target__ | $800
.endmacro

.macro sybsx __target__
    sty __target__ | $800, x
.endmacro

.macro sxbs __target__
    stx __target__ | $800
.endmacro

.macro sxbsy __target__
    stx __target__ | $800, y
.endmacro