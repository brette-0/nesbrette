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

.macro lds __reg__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    .if .xmatch(__reg__, y)
        ldy $0100 + __offset__, x
    .else
        lda $0100 + __offset__, x
    .endif
.endmacro

.macro sts __offset__, __reg__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    .if .xmatch(__reg__, y)
        sty $0100 + __offset__, x
    .else
        sta $0100 + __offset__, x
    .endif
.endmacro

.if 0

.macro des, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    dec $0100 + __offset__, x
.endmacro

.macro ins, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    inc $0100 + __offset__, x
.endmacro

.macro cps __reg__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    .if .xmatch(__reg__, y)
        cpy $0100 + __offset__, x
    .else
        cmp $0100 + __offset__, x
    .endif
.endmacro

.macro ads __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    adc $0100 + __offset__, x
.endmacro

.macro sbs __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    sbc $0100 + __offset__, x
.endmacro

.macro ans __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    and $0100 + __offset__, x
    .endmacro

.macro ors __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    ora $0100 + __offset__, x
    .endmacro

.macro eos __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    eor $0100 + __offset__, x
.endif

.macro rss __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    lsr $0100 + __offset__, x
.endif

.macro lss __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    asl $0100 + __offset__, x
.endif

.macro lrs __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif
    
    rol $0100 + __offset__, x
.endif


.macro rrs __offset__, __xissp__
    .ifblank __xissp__
        tsx
    .endif

    ror $0110 + __offset__, x
.endif

.endif