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
        ldy $0100 + __offset__, x
    .else
        lda $0100 + __offset__, x
    .endif
.endmacro

.macro sts __offset__, __reg__
    tsx
    .if .xmatch(__reg__, y)
        sty $0100 + __offset__, x
    .else
        sta $0100 + __offset__, x
    .endif
.endmacro

.macro des
    tsx
    dec $0100 + __offset__, x
.endmacro

.macro ins
    tsx
    inc $0100 + __offset__, x
.endmacro

.macro cps __reg__
    tsx
    .if .xmatch(__reg__, y)
        cpy $0100 + __offset__, x
    .else
        cmp $0100 + __offset__, x
    .endif
.endmacro

.macro ads __offset__
    tsx
    adc $0100 + __offset__, x
.endmacro

.macro sbs __offset__
    tsx
    sbc $0100 + __offset__, x
.endmacro

.macro ans __offset__
    tsx
    and $0100 + __offset__, x
    .endmacro

.macro ors __offset__
    tsx
    ora $0100 + __offset__, x
    .endmacro

.macro eos __offset__
    tsx
    eor $0100 + __offset__, x
.endif

.macro rss __offset__
    tsx
    lsr $0100 + __offset__, x
.endif

.macro lss __offset__
    tsx
    asl $0100 + __offset__, x
.endif

.macro lrs __offset__
    tsx
    rol $0100 + __offset__, x
.endif


.macro rrs __offset__
    tsx
    ror $0110 + __offset__, x
.endif