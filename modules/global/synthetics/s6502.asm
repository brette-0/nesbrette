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