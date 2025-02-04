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

.macro __stz_typeless l_target, t_target, _reg, _mode, _zero
    .if !_zero
        ldr _reg: imm, $00
    .endif

    .repeat typeval t_target, iter
        str _reg: _mode, eindex l_target, typeval t_target, iter, endian t_target
    .endrepeat
.endmacro

; typed validation handler
.macro stz __target__, __reg$__, __zero$__
    .local _reg, _mode, t_target, w_target, _zero
    ; (nb_int: ptr) __target__
    ; (token : gpr) __reg$__
    ; (bool)        __zero$__

    t_target .set null

    detype __target__, t_target

    l_target .set .right(1, __target__)
    w_target .set typeval t_target

    _mode .set null
    _reg  .set null 

    .ifblank __reg$__
        _mode .set wabs
        _reg  .set ar
    .elseif .xmatch(.left(1, __reg$__), y)
        _mode .set wabsy
    .elseif .xmatch(.left(1, __reg$__), x)
        _mode .set wabsx
    .elseif .left(1, __reg$__) = xr
        _mode .set wabsx
    .elseif .left(1, __reg$__) = yr
        _mode .set wabsy
    .elseif .left(1, __reg$__) = null
        _mode .set wabs
        _reg  .set ar
    .elseif !.left(1, __reg$__)
        _mode .set wabs
        _reg  .set ar
    .endif

    .if .tcount(__reg$__) = .tcount(0:0)
        _reg .set .right(1, __reg$__)
        _reg .set setreg _reg

        .if is_null _reg
            .fatal "InvalidGeneralPurposeRegister: loading GPR must be a valid GPR!"; invalid reg
        .endif

        .if (ar << (isindexed _mode)) = _reg
            .fatal "IntereferingRegisterUseException: Cannot have the reading register the same as the inedxing register!"
        .endif
    .endif

    _zero .set 0 

    .ifnblank __zero$__
        _zero .set __zero$__
    .endif

    null_coalset _reg, ar
    null_coalset _mode, wabs

    .if (_reg <> ar) && (_mode <> wabs)
        .fatal "InvalidMemoryAddressModeException: Store X|Y, x/y is invalid!"
    .endif

    __stz_typeless l_target, w_target, _reg, _mode, _zero
.endmacro