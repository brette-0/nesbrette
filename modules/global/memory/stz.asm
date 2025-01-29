.macro ldz __reg__
    .local _reg

    .ifblank __reg__
        _reg = ar
    .else
        _reg = setreg __reg__
    .endif

    .if (is_null _reg)
        .fatal "Invalid Register specied"
    .endif

    ldr _reg: imm, $00
.endmacro

.macro __stz __target__, __width__, __ireg__, __reg__, __value__, __unrolled__
    .ifblank __value__
        ldr imm:: storereg, 0
    .elseif __value__ = null
    .else
        ldr imm:: storereg, __value__
    .endif

    .if __unrolled__
        .repeat targetsize, iter
            str wabs:: storereg, (tlabel + iter)
        .endrepeat
    .else
        ldr imm:: indexreg, targetsize
        @loop:
            str wabsx:: storereg, tlabel
            der indexreg
            bne @loop
    .endif
.endmacro

; stz u32: Tar
; stz u32: Tar xr:ar
.macro stz __target__, __regs__, __value__, __unrolled__
    .local targettype, targetsize, indexreg, storereg, tlabel

    t_target .set 0
    detype __target__, t_target

    l_target = ilabel __target__
    w_target = typeval t_target


    ; _reg  = (local == null|blank) ? (__unrolled__ ? null : ar) : local
    ; _ireg = (local == null|blank) ? (__unrolled__ ? null : xr) : local
    .ifblank __regs__
        .if __unrolled__
            _ireg = null
        .else
            _ireg = xr
        .endif
        _reg = ar
    .else
        _ireg = setireg .right(1, __regs__)
        _reg  = setreg  .left( 1, __regs__)

        .if _ireg = _reg & !__unrolled__
            .fatal "Cannot use indexing register as writing register"
        .endif
    .endif

    ; call to validate params as preproc ints (forces error report higher on stack call)
    validate_preprocint __value__
    validate_preprocint __unrolled__

    __stz l_target, w_target, _ireg, _reg, __value__, __unrolled__
.endmacro