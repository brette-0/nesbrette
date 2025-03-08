deferror ::PROFILE_AllowAccessToStack, error
deferror ::PROFILE_AllowErroneousAccess, error
deferror ::PROFILE_AllowIndexedRegisterAccess, error


.macro lds __offset$__, __reg$__
    .local stacksafety

    stacksafety = PROFILE_AllowAccessToStack
    rule AllowAccessToStack, allow
    tsx

    _lds_reg .set ar

    .ifblank __offset$__
        _lds_offset = $00
    .else
        _lds_offset = null_coalesce __offset$__, $00
    .endif
    
    .ifnblank __reg$__
        _lds_reg .set setreg __reg$__
    .endif

    .if _lds_reg = xr
        .fatal ""
    .endif

    .if _lds_reg = null
        .fatal ""
    .endif

    ld _lds_reg, $100 + _lds_offset, x
    rule AllowAccessToStack, stacksafety
.endmacro

.macro sts __offset$__
    tsx

    .ifblank __offset$__
        _lds_offset = $00
    .else
        _lds_offset = null_coalesce __offset$__, $00
    .endif

    .if _lds_reg = null
        .fatal ""
    .endif

    sta $100 + _lds_offset, x
.endmacro

.macro cps __offset$__
    tsx

    _lds_reg .set ar

    .ifblank __offset$__
        _lds_offset = $00
    .else
        _lds_offset = null_coalesce __offset$__, $00
    .endif
    
    cmp $100 + _lds_offset, x
.endmacro