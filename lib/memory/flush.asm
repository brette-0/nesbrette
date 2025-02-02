; tested and working
.macro ldz __gpr__
    /*
        (gpr)__gpr__
    */

    gpr .set ar
    .ifnblank __gpr__
        gpr .set setreg __gpr__
    .endif

    ldr imm: gpr, $00
.endmacro

; tested and working
.macro stz __target__, __reg$__, __zero$__
    ; (nb_int: ptr) __target__
    ; (token : gpr) __reg$__
    ; (bool)        __zero$__
    detype __target__, t_target

    l_target .set .right(1, __target__)
    w_target .set typeval t_target

    _stz_mode .set null
    _stz_reg  .set null 

    .ifblank __reg$__
        _stz_mode .set wabs
        _stz_reg  .set ar
    .elseif .xmatch(.left(1, __reg$__), y)
        _stz_mode .set wabsy
    .elseif .xmatch(.left(1, __reg$__), x)
        _stz_mode .set wabsx
    .elseif .left(1, __reg$__) = xr
        _stz_mode .set wabsx
    .elseif .left(1, __reg$__) = yr
        _stz_mode .set wabsy
    .elseif .left(1, __reg$__) = null
        _stz_mode .set wabs
        _stz_reg  .set ar
    .endif

    .if .tcount(__reg$__) = .tcount(0:0)
        _stz_reg .set .right(1, __reg$__)
        _stz_reg .set setreg _stz_reg

        .if is_null _stz_reg
            .fatal "InvalidGeneralPurposeRegister: loading GPR must be a valid GPR!"; invalid reg
        .endif

        .if (_stz_mode - wabs) && ((ar << (_stz_mode - wabs)) = _stz_reg)
            .fatal "IntereferingRegisterUseException: Cannot have the reading register the same as the inedxing register!"
        .endif
    .endif

    _zero .set 0 

    .ifnblank __zero$__
        _zero .set __zero$__
    .endif

    null_coalset _stz_reg, ar
    null_coalset _stz_mode, wabs

    .if (_stz_reg <> ar) && (_stz_mode <> wabs)
        .fatal "InvalidMemoryAddressModeException: Store X|Y, x/y is invalid!"
    .endif

    .if !_zero
        ldr _stz_reg: imm, $00
    .endif

    .repeat typeval t_target, iter
        str _stz_reg: _stz_mode, eindex l_target, w_target, iter, endian t_target
    .endrepeat
.endmacro