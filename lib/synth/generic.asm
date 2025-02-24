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


; jmx Area, y
; jmx Area, null
; jmx Area (why do this)
; jmx Area, x, (nf + set)
; jmx Area, null, (nf + set), 1
.macro jmx __target__, __mode$__, __flag_state$__, __flip$__
    .local ahead

    .ifnblank __flag_state$__
        .if     __flag_state$__ = (nf + clear)
            bmi ahead
        .elseif __flag_state$__ = (nf + set)
            bpl ahead
        .elseif __flag_state$__ = (of + clear)
            bvs ahead
        .elseif __flag_state$__ = (of + set)
            bvc ahead
        .elseif __flag_state$__ = (cf + clear)
            bcs ahead
        .elseif __flag_state$__ = (cf + set)
            bcc ahead
        .elseif __flag_state$__ = (zf + clear)
            bne ahead
        .elseif __flag_state$__ = (zf + set)
            beq ahead
        .else
    .endif


    .ifblank __mode$__
        jmp [__target__]
        .exitmacro

    .elseif .xmatch(__mode$__, x)
        _jmx_reg .set xr
    .elseif .xmatch(__mode$__, y)
        _jmx_reg .set yr
    .elseif .xmatch(__mode$__, iy)
        _jmx_reg .set yr
    .elseif .xmatch(__mode$__, ix)
        _jmx_reg .set xr
    .elseif __mode$__ = absx
    .elseif __mode$__ = absy
    .elseif __mode$__ = inabsx
    .elseif __mode$__ = inabsy
    .else
        .fatal "invalid mem mode"
    .endif

    .ifnblank __flip$__
        _jmx_flip .set __flip$__
    .else
        _jmx_flip .set 0
    .endif


    ldr __mode$__: ar, __target__ + _jmx_flip
    pha

    ldr __mode$__: ar, __target__ + 1 - _jmx_flip
    pha

    php
    rti 

    ahead:
.endmacro

.macro labs __target__
    lda ($800 | __target__)
.endmacro

.macro lxbs __target__
    ldx ($800 | __target__)
.endmacro

.macro lybs __target__
    ldy ($800 | __target__)
.endmacro

.macro laxbs __target__
    lax ($800 | __target__)
.endmacro

.macro lrbs __reg_target__

    _lrbs_reg .set .left(1, __reg_target__)
    _lrbs_reg .set setreg _lrbs_reg

    ldr abst: _lrbs_reg, .right(1, __reg_target__)
.endmacro

.macro sabs __target__
    sta ($800 | __target__)
.endmacro

.macro sxbs __target__
    stx ($800 | __target__)
.endmacro

.macro sybs __target__
    sty ($800 | __target__)
.endmacro


.macro srbs __reg_target__

    _lrbs_reg .set .left(1, __reg_target__)
    _lrbs_reg .set setreg _lrbs_reg

    str abst: _lrbs_reg, .right(1, __reg_target__)
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

; sex ar
; sex ar, t:label
.macro sex __reg__, __context$__
    .local is_signed, l_context, w_context, t_context

    is_signed .set 1
    
    .ifblank __context$__
        t_context .set null
        detype __context$__, t_context
        w_context = width t_context
        is_signed = signed t_context

        l_context = .right(1, __context$__)

        .if is_signed
            ldr eindex l_context, w_context, 0, endian ~t_context
        .endif
    .endif

    .if is_signed
        ; validate __reg__ as reg
        reg = __reg___
        .if reg = ar
            ora #$7f
            bmi negative
            lda #$00
            negative:
        .else
            cpr imm: reg, $80
            bcs negative
            ldr imm: reg, $00
            negative:
        .endif
    .else
        ldr imm: reg, $00
    .endif
.endmacro