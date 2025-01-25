.macro ldstat
    php
    pla
.endmacro

.macro ststat
    pha
    plp
.endmacro

.macro callback __addr__
    lda #<__addr__
    pha
    lda #>__addr__
    pha
.endmacro

.macro lds __reg__
    tsx
    .if .xmatch(__reg__, y)
        ldy $0100, x
    .else
        lda $0100, x
    .endif
.endmacro

.macro sts __reg__
    tsx
    .if .xmatch(__reg__, y)
        sty $0100, x
    .else
        sta $0100, x
    .endif
.endmacro