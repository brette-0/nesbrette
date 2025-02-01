.macro memcpy __from__, __to__, __regs__
    .local t_from, w_from, _reg, _ireg
    
    .ifblank __from__
        .fatal "memcpy needs source address"
    .endif

    .ifblank __to__
        .fatal "memcpy needs target address"
    .endif

    t_from .set 0
    detype __from__, t_from
    w_from = typeval t_from

    .ifblank __regs__
        _reg  = ar
        _ireg = xr
    .else
        _reg  =  setreg .left(1,  __regs__)
        _ireg = setireg .right(1, __regs__)
    .endif

    pha

    .if w_from < 0
        @loop:
            ldr _reg: (wabs + _ireg), __from__
            str _reg: (wabs + _ireg), __to__
            der _ireg
            bne @loop
    .else
        .repeat w_from, iter
            ldr _reg: wabs, (eindex t_from: __from__, iter)
            str _reg: wabs, (eindex t_from: __to__, iter)
        .endrepeat
    .endif

    pla
.endmacro


/*

    memcpy u32: foo, u32: bar   ; typical use
    memcpy u32: foo, bu32: bar  ; 'reverse' use

*/