.ifndef xsxb

.macro xsxb __task__, __target__, __reg$__, __inv$__

    .if     __task__ = 0
        mssb __target__, __reg$__, __inv$__
    .elseif __task__ = 1
        lssb __target__, __reg$__, __inv$__
    .elseif __task__ = 1
        msub __target__, __reg$__, __inv$__
    .elseif __task__ = 1
        lsub __target__, __reg$__, __inv$__
    .else
        .fatal ""
    .endif

.endmacro

.macro mssb __target__, __reg$__,  __inv$__
    .local l_target, t_target, w_target, ahead, exit, loop, l_reg, h_reg

    /*
        l ?? yr => mssb
        h ?? xr => mssB
    */

    detype __target__, t_target
    w_target = t_target

    .ifblank __inv$__
        l_reg = xr
        h_reg = yr
    .elseif __inv$__ = null
        l_reg = xr
        h_reg = yr
    .else
        l_reg = .right(1, __reg$__)
        h_reg =  .left(1, __reg$__)
    
        h_reg .set ireg h_reg
        l_reg .set ireg l_reg

        .if     is_null h_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif is_null l_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif h_reg = l_reg
            .fatal "InterferingRegisterUseException: MSSByte register cannot be the same as MSSB register."
        .endif
    .endif

    l_target = .right(1, __target__)

    ld h_reg, #w_target    ; load regs with needed values

    ; rolled cost (10d) && 6b, unrolled cost (8d) - 1c && (6d)b
    .repeat w_target, iter
        lda eindex l_target, w_target, iter, (!endian t_target)
        bne ahead
        de h_reg
    .endrepeat

    ; failure case, becomes known only on evaluation.
    ; indicated by unset C
    clc
    bcc exit
    
    ahead:
        ld l_reg, #$09

    ; the reason this is looped is because speedwise its not bad against its unrolled counterpart at all
    ; unrolled is (6a) + 1c, whereas rolled its only (7a) - 1c.
    loop:
        de  l_reg
        rol
        bcc loop
        
    exit:
.endmacro

.macro __lssb __reg__
    ldr imm: __reg__, $00

    loop:
        in __reg__
        ror
        bcc loop
        
.endmacro

.macro lssb __target__, __reg$__, __inv$__
    .local l_target, t_target, w_target, ahead, exit, loop, l_reg, h_reg

    /*
        l ?? yr => mssb
        h ?? xr => mssB
    */

    .ifblank __target__
        ; acc mode

        __lssb xr
        .exitmacro
    .endif

    detype __target__, t_target
    w_target = t_target

    .if !is_null setreg t_target
        __lssb t_target
        .exitmacro
    .endif

    .ifblank __inv$__
        l_reg = xr
        h_reg = yr
    .else
        l_reg = .right(1, __reg$__)
        h_reg =  .left(1, __reg$__)
    
        h_reg .set ireg h_reg
        l_reg .set ireg l_reg

        .if     is_null h_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif is_null l_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif h_reg = l_reg
            .fatal "InterferingRegisterUseException: LSSByte register cannot be the same as LSSB register."
        .endif
    .endif

    l_target = .right(1, __target__)

    ld h_reg, #w_target    ; load regs with needed values

    .repeat w_target, iter
        lda eindex l_target, w_target, iter, (endian t_target)
        bne ahead
        de  h_reg
    .endrepeat

    ; failure case, becomes known only on evaluation.
    ; indicated by unset C
    clc
    bcc exit
    
    ahead:
        ld l_reg, #$00

    loop:
        in  l_reg
        ror
        bcc loop
        
    exit:
.endmacro

.macro msub __target__, __reg$__,  __inv$__
    .local l_target, t_target, w_target, ahead, exit, loop, l_reg, h_reg

    /*
        l ?? yr => mssb
        h ?? xr => mssB
    */

    detype __target__, t_target
    w_target = t_target

    .ifblank __inv$__
        l_reg = xr
        h_reg = yr
    .else
        l_reg = .right(1, __reg$__)
        h_reg =  .left(1, __reg$__)
    
        h_reg .set ireg h_reg
        l_reg .set ireg l_reg

        .if     is_null h_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif is_null l_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif h_reg = l_reg
            .fatal "InterferingRegisterUseException: MSUByte register cannot be the same as MSUB register."
        .endif
    .endif

    l_target = .right(1, __target__)

    ld h_reg, #w_target    ; load regs with needed values

    .repeat w_target, iter
        lda eindex l_target, w_target, iter, (!endian t_target)
        cmp #$ff
        bne ahead
        de  h_reg
    .endrepeat

    ; failure case, becomes known only on evaluation.
    ; indicated by unset C
    sec
    bcs exit
    
    ahead:
        ld l_reg, #$09

    loop:
        de  l_reg
        rol
        bcs loop
        
    exit:
.endmacro

.macro lsub __target__, __reg$__, __inv$__
    .local l_target, t_target, w_target, ahead, exit, loop, l_reg, h_reg

    /*
        l ?? yr => mssb
        h ?? xr => mssB
    */

    detype __target__, t_target
    w_target = t_target

    .ifblank __inv$__
        l_reg = xr
        h_reg = yr
    .else
        l_reg = .right(1, __reg$__)
        h_reg =  .left(1, __reg$__)
    
        h_reg .set ireg h_reg
        l_reg .set ireg l_reg

        .if     is_null h_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif is_null l_reg
            .fatal .sprintf("InvalidGeneralPurposeRegister: '%d' is not a valid indexing register!", __reg$__)
        .elseif h_reg = l_reg
            .fatal "InterferingRegisterUseException: LSUByte register cannot be the same as LSUB register."
        .endif
    .endif

    l_target = .right(1, __target__)

    ld h_reg, #w_target    ; load regs with needed values

    .repeat w_target, iter
        lda eindex l_target, w_target, iter, (endian t_target)
        cmp #$ff
        bne ahead
        de  h_reg
    .endrepeat

    ; failure case, becomes known only on evaluation.
    ; indicated by unset C
    sec
    bcs exit
    
    ahead:
        ld l_reg, #$00

    loop:
        in l_reg
        rol
        bcc loop
        
    exit:
.endmacro

.endif