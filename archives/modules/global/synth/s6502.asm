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
    .local _ireg

    _ireg = setreg __reg__

    .if _ireg = ar
        pha
        lsr
        pla
        ror
    .else
        tar _ireg
        lsr
        tra _ireg
        ror
    .endif

.macro irol
    cmp #$80
    rol
    .endmacro


.if 0

; this design is stupidly optimised
.macro labs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    ldr ar: ((abs _ireg) + abst), __target__
.endmacro

.macro lybs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    .if _ireg = yr
        .fatal "Cannot index with accessing register"
    .endif

    ldr yr: ((abs _ireg) + abst), __target__
.endmacro

.macro lxbs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    .if _ireg = xr
        .fatal "Cannot index with accessing register"
    .endif
    
    ldr xr: ((abs _ireg) + abst), __target__
.endmacro

.macro sabs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    str ar: ((abs _ireg) + abst), __target__
.endmacro

.macro sybs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    .if _ireg = yr
        .fatal "Cannot index with accessing register"
    .endif

    str yr: ((abs _ireg) + abst), __target__
.endmacro

.macro sxbs __target__
    .local _ireg

    _ireg = setireg (.right(1, __target__) * (.paramcount - 1))
    .if _ireg = xr
        .fatal "Cannot index with accessing register"
    .endif

    str x: ((abs _ireg) + abst), __target__
.endmacro

.endif


; lrbs, srbs