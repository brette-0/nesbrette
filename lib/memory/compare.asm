.ifndef compare

.macro compare __source__, __target__, __reg$__, __modes$__, __fallback$__
    .local phase2, exit, smaller, w_source, w_target, t_target, t_source, l_target, l_source, _reg, m_comp, m_load, fallback

    /*

        (int: ptr)  __source__
        (int: ptr)  __target__

        (gpr)       __reg$__
        (mam: mam)  __modes$__


        limits:
            uses ar for bitmath
            requires xr|yr as dr
                no wabsr | absr


        response:
            cpu stat
                Z   - equal to                  : requirement
                N   - sign equality             : also kind of cool
                C   - Greater than or equal to  : requirement
                V   - Greater than              : cool as fuck


        usage:
            compare Source, Target
            compare Source, Target, wabsx: wabsy
    */

    t_target .set null
    t_source .set null

    detype __target__, t_target
    detype __source__, t_source

    w_source = typeval t_source
    w_target = typeval t_target

    .if (!w_source) || (!w_source)
        ; invalid type
    .endif

    l_source = .right(1, __source__)
    l_target = .right(1, __target__)

    .ifblank __reg$__
        r_data .set yr
    .else
        r_data .set __reg$__
        r_data .set setireg r_data

        .if is_null r_data
            .fatal ; invalid ireg
        .endif
    .endif

    .ifblank __fallback$__
        fallback .set $00
    .else
        fallback .set __fallback$__

        .if is_null r_data
            .fatal ; invalid ireg
        .endif
    .endif

    

    .ifblank __modes$__
        m_load .set wabs
        m_comp .set wabs
    .else
        m_load .set  .left(1, __modes$__)
        m_comp .set .right(1, __modes$__)

        m_load .set setireg __modes$__
        m_comp .set setireg __modes$__

        .if is_null r_load
            .fatal ""
        .endif

        .if is_null r_comp
            .fatal ""
        .endif
    .endif

    lda #$00

    .repeat w_target, iter
        ldr r_data: m_load, eindex l_source, w_source, iter, endian t_source
        cpr r_data: m_comp, eindex l_target, w_target, iter, endian t_target
        bne phase2
    .endrepeat

    .if .max(0, w_source - w_target)
        ldr r_data: imm, fallback
    
        .repeat .max(0, w_source - w_target), iter
            cpr r_data: m_comp, eindex l_target, w_target, (iter + w_source - w_target), endian t_target
            bne phase2
        .endrepeat
    .endif

    ora #ZF + CF
    bne exit
    
    phase2:
        ; if we have reached here there are two possibilities
        ; load[r] <> comp[r] || fallback <> comp[r]

        bcc smaller
        ora #(CF + OF)

        smaller:

    ldr r_data: m_load, eindex l_source, w_source, (w_source - 1), endian t_source
    cpr r_data: m_comp, eindex l_target, w_target, (w_target - 1), endian t_target

    bpl nosigndiff
    ora #NF
    nosigndiff:

    exit:
    pha
    plp ; ststat (not warranting a whole ass dependancy)
.endmacro

.endif