.ifndef shift

.ifndef memcpy
    ::dependancies .set ::dependancies + 1
    ; lihmem::memcpy is macro only at 0 bytes thus doesn't need a size change
.endif

.ifndef ldz
    ::dependancies .set ::dependancies + 1
    ; libmem::flush is macro only at 0 bytes thus doesn't need a size change
.endif

includefrom memory, memcpy
includefrom memory, flush

.macro __rshift __amt__, __cpve__
    .if __amt__ > 7
        report 3, .sprintf("Requested Shift Amount '%d' exceeds register width of 8", __amt__)
        lda #$00
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

.macro rshift __param0__, __param1__, __zero$__, __reg$__, __mode$__, __cpve$__
    .local mode, zero, l_target, t_target, w_target, cpve

    cpve .set null

    .ifblank __param1__
        ; acc mode

        __rshift __param0__ ; for now I dont think can be variable
        .exitmacro
    .endif

    .ifblank __cpve$__
        deferror error,     cpve 
    .else
        deferror __cpve$__, cpve
    .endif


    .ifblank __reg$__
        reg .set ar
    .elseif __reg$__ = null
        reg .set ar
    .else
        reg .set __reg$__
        reg .set setreg __reg$__

        .if is_null reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid register!", __reg$__)
        .endif
    .endif

    .ifblank __mode$__
        mode .set wabs
    .elseif __mode$__ = null
        mode .set wabs
    .else
        mode .set __mode$__
        mode .set setmam mode

        .if is_null mode
            .fatal .sprintf("InvalidMemoryAddressModeException: '%d' is not a valid memory address mode!", __mode$__)
        .endif

        .if reg = mamreg mode
            .fatal "InterferingRegisterUseException: data register cannot be the same as indexing register."
        .endif
    .endif

    .ifblank __zero$__
        zero = null
    .elseif __zero$__= null
        zero = null
    .else
        zero = setreg __zero$__
        .if is_null zero
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid register!", __zero$__)
        .endif
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

.macro __lshift __amt__
    .if __amt__ > 7
        report 3, .sprintf("Requested Shift Amount '%d' exceeds register width of 8", __amt__)
        lda #$00
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

.macro lshift __param0__, __param1__, __zero$__, __reg$__, __mode$__
    .local mode, zero, l_target, t_target, w_target

    .ifblank __param1__
        __lshift __param0__
        .exitmacro
    .endif

    .ifblank __reg$__
        reg .set ar
    .elseif __reg$__ = null
        reg .set ar
    .else
        reg .set __reg$__
        reg .set setreg __reg$__

        .if is_null reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid register!", __reg$__)
        .endif
    .endif

    .ifblank __mode$__
        mode .set wabs
    .elseif __mode$__ = null
        mode .set wabs
    .else
        mode .set __mode$__
        mode .set setmam mode

        .if is_null mode
            .fatal .sprintf("InvalidMemoryAddressModeException: '%d' is not a valid memory address mode!", __mode$__)
        .endif

        .if reg = mamreg mode
            .fatal "InterferingRegisterUseException: data register cannot be the same as indexing register."
        .endif
    .endif

    .ifblank __zero$__
        zero = null
    .elseif __zero$__= null
        zero = null
    .else
        zero = setreg __zero$__
        .if is_null zero
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid register!", __zero$__)
        .endif
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

.endif