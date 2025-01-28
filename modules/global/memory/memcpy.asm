.macro memcpy __from__, __to__, __width__, __direct__, __reverse__
    .local t_from, t_to, _reg, _ireg
    
    .ifblank __from__
        .fatal "memcpy needs source address"
    .endif

    .ifblank __to__
        .fatal "memcpy needs target address"
    .endif

    t_from .set 0
    t_to   .set 0

    detype __from__, t_from
    detype __to__,   t_to
    
    .ifblank __regs__
        _reg  = ar
        _ireg = xr
    .else
        _reg  =  setreg .left(1,  __regs__)
        _ireg = setireg .right(1, __regs__)
    .endif

    pha

    .if __width__ < 0
        @loop:
            ldr _reg: (wabs + _ireg), __from__
            str _reg: (wabs + _ireg), __to__
            der _ireq
            bne @loop

    .else
        .repeat width, iter
            ldr _reg: wabs, (eindex t_from: __from__, iter)
            str _reg: wabs, (eindex t_to: __to__, iter)
        .endrepeat
    .endif

    pla
.endmacro


/*

    memcpy u32: foo, u32: bar   ; typical use
    memcpy u32: foo, bu32: bar  ; 'reverse' use

*/