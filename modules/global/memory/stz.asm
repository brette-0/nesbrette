; ldz u32: Tar
; ldz u32: Tar xr:ar
.macro stz __target__, __regs__, __value__, __unrolled__
    .local targettype, targetsize, indexreg, storereg, tlabel

    targetsize .set 0
    detype __target__, targetsize

    tlabel = ilabel __target__

    .ifblank __regs__
        indexreg = xr
        storereg = ar
    .else
        .if .left(1, __regs__) = 0 || .left(1, __regs__) = null
            indexreg = xr
        .elseif .left(1, __regs__) <> xr && .left(1, __regs__) <> yr
            .fatal
        .else
            indexreg = .left(1, __regs__)
        .endif

        .if .right(1, __regs__) = 0 || .right(1, __regs__) = null
            storereg = xr
        .elseif indexreg = .right(1, __regs__) || (.right(1, __regs__) <> xr && .right(1, __regs__) <> yr && .right(1, __regs__) <> ar)
            .fatal
        .else
            storereg = .right(1, __regs__)
        .endif
    .endif

    .ifblank __value__
        ldr imm:: storereg, 0
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