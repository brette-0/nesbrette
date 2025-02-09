includefrom memory, memcpy
includefrom memory, flush

.macro __rshift __amt__, __zero__
    .if __amt__ > 7
        report 1, "Fucky doo"
        .if     __zero__ = ar
        .elseif __zero__ = xr
            txa
        .elseif __zero__ = yr
            tya
        .else
            lda #$00
        .endif
    .endif

    .if __amt__ > 5
        .repeat (9 - __amt__), _
            rol
        .endrepeat
        and #((1 << (8 - __amt__)) - 1)
    .else
        .repeat __amt__, _
            lsr
        .endrepeat
    .endif
.endmacro

; TODO: see if we can clean up calling case
.macro rshift __param0__, __param1__, __zero$__, __reg$__, __mode$__
    .local mode, zero, l_target, t_target, w_target

    .ifblank __reg$__
        reg .set ar
    .else
        reg .set __reg$__
        reg .set setreg __reg$__

        .if is_null reg
            .fatal ""
        .endif
    .endif

    .ifblank __mode$__
        mode .set wabs
    .else
        mode .set __mode$__
        mode .set setmam mode

        .if is_null mode
            .fatal
        .endif

        .if reg = mamreg mode
            .fatal
        .endif
    .endif

    .ifblank __zero$__
        zero = null
    .else
        zero = setreg __zero$__
        .if is_null zero
            .fatal ""   ; fatal error
        .endif
    .endif

    .ifblank __param1__
        __rshift __param0__, zero
        .exitmacro
    .endif

    t_target .set null

    l_target = .right(1, __param0__)
    detype __param0__, t_target
    w_target = typeval t_target

    transamt = __param1__ >> 3      ; amount of bytes needed to move
    shiftamt = __param1__ & %111    ; amount of bits to shift

    t_temp  = w_target - transamt
    t_temp2 = l_target + transamt

    .if transamt
        memcpy t_temp: l_target, t_temp: t_temp2, reg, mode: mode, error, 0, zero, 0
    .endif

    stz transamt: l_target, reg, 0

    .repeat shiftamt, _
        lsr l_target + transamt
        .repeat t_temp, iter
            .if iter > 0
                ror l_target + transamt + iter
            .endif
        .endrepeat
    .endrepeat
.endmacro

.macro __lshift __amt__, __zero__
    .if __amt__ > 7
        report 1, "Fucky doo"
        .if     __zero__ = ar
        .elseif __zero__ = xr
            txa
        .elseif __zero__ = yr
            tya
        .else
            lda #$00
        .endif
    .endif

    .if __amt__ > 5
        .repeat (9 - __amt__), _
            ror
        .endrepeat
        and #~((1 << __amt__) - 1)
    .else
        .repeat __amt__, _
            asl
        .endrepeat
    .endif
.endmacro

; TODO: see if we can clean up calling case
.macro lshift __param0__, __param1__, __zero$__, __reg$__, __mode$__
    .local mode, zero, l_target, t_target, w_target

    .ifblank __reg$__
        reg .set ar
    .else
        reg .set __reg$__
        reg .set setreg __reg$__

        .if is_null reg
            .fatal ""
        .endif
    .endif

    .ifblank __mode$__
        mode .set wabs
    .else
        mode .set __mode$__
        mode .set setmam mode

        .if is_null mode
            .fatal
        .endif

        .if reg = mamreg mode
            .fatal
        .endif
    .endif

    .ifblank __zero$__
        zero = null
    .else
        zero = setreg __zero$__
        .if is_null zero
            .fatal ""   ; fatal error
        .endif
    .endif

    .ifblank __param1__
        __lshift __param0__, zero
        .exitmacro
    .endif

    t_target .set null

    l_target .set .right(1, __param0__)
    detype __param0__, t_target
    w_target = typeval t_target

    transamt = __param1__ >> 3      ; amount of bytes needed to move
    shiftamt = __param1__ & %111    ; amount of bits to shift

    t_temp  = w_target - transamt
    t_temp2 = l_target + transamt

    .if transamt
        memcpy t_temp: t_temp2, t_temp: l_target, reg, mode: mode, error, 0, zero, 0
    .endif

    t_temp3 = l_target + w_target - transamt

    stz transamt: t_temp3, reg, 0

    .repeat shiftamt, _
        asl l_target + transamt
        .repeat t_temp, iter
            .if iter > 0
                rol l_target + transamt - iter
            .endif
        .endrepeat
    .endrepeat
.endmacro

.macro shift __amt__
    .if __amt__ > 0
        rshift num
    .else
        __amt__ < 0
        lshift num
    .endif
.endmacro