.macro lds __offset$__, __reg$__
    txs

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


    ldr absx: _lds_reg, ($100 + _lds_offset)
.endmacro

.macro sts __offset$__
    txs

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
    txs

    _lds_reg .set ar

    .ifblank __offset$__
        _lds_offset = $00
    .else
        _lds_offset = null_coalesce __offset$__, $00
    .endif
    
    cmp $100 + _lds_offset, x
.endmacro