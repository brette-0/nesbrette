; needs dynamic width
; needs ioptr
; untested

; NEEDS MAJOR REWORK

.macro eval __offset__, __width__, __endian__, __reg__
    .ifblank __offset__
        .fatal "eval requires offset to evaluate"
        .endif

    .ifblank width
        .fatal "eval requires width to evaluate"
        .endif

    .ifblank __endian__
        __endian__ = little
        .endif

    .if (__endian__ <> little) .and (__endian__ <> big)
        .fatal "Invalid Endianness"
        .endif

    .ifblank __reg__
        __reg__ = a
        .endif

    .if (__reg__ <> x) .and (__reg__ <> y) .and (__reg__ <> a)
        .fatal "Invalid GPR for eval"
        .endif

    php
    pla                                 ; status => a
    and #%01111101                      ; mask out N and Z

    .if __endian__ = little
        bit __offset__ + __width__ - 1  ; fetch signature
    .else
        bit __offset__
    .endif

    bpl @skip
        ora #$80

    @skip:

    .if __reg__ = a
        pha
        .endif

    .repeat __width__, iter
        .if     __reg__ = a
            lda __offset__ + __width__      
        .elseif __reg__ = x
            ldx __offset__ + __width__
        .else
            ldy __offset__ + __width__
        .endif

        bne @exit    
        .endrepeat
    
    .if __reg__ = a
        pla
        .endif
    
    ora #$02                ; enable Z
    
    @exit:
    pha
    plp                     ; a => status
    .endmacro