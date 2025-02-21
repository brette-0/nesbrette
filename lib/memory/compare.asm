.ifndef compare

.macro compare __source__, __target__, __modes$__, __fallback$__
    .local phase2, exit, smaller, w_source, w_target, t_target, t_source, l_target, l_source, _reg, m_comp, m_load, fallback
    /*

        TODO: Rewrite optional parameter validation
        TODO: Write Width Mismatch Fallback
        TODO: Optimise ldr=>cpr situations with dual ireg

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
                Z   - equal to bitwise
                C   - Greater than or equal to
                V   - Greater than
                N   - equal to numerically


        usage:
            compare Source, Target
            compare Source, Target, wabsx: wabsy


        tests:
            Unsigned | Unsigned 
                PASSING BITWISE EQUALITY CHECK
                PASSING NUMERICAL EQUALITY CHECK
                PASSING >= CHECK
                PASSING > CHECK
            
            Unsigned | Signed 
            




            Signed | Unsigned 
            




            Signed | Ssigned 
            




            
    */

    srcdelta .set null
    tardelta .set null

    malloc srcdelta, 1
    malloc tardelta, 1

    t_target .set null
    t_source .set null

    detype __target__, t_target
    detype __source__, t_source

    w_source = typeval t_source
    w_target = typeval t_target

    .if (!w_source) || (!w_target)
        ; invalid type
    .endif

    l_source = .right(1, __source__)
    l_target = .right(1, __target__)
    
    r_comp = xr

    .ifblank __modes$__
        m_load = wabs
        m_comp = wabs
    .else
        m_load = setmam .left( 1, __modes$__)
        m_comp = setmam .right(1, __modes$__)
    .endif

    lda #$00
    
    .if endian w_target
        ldr xr: imm, w_target
    .else
        tar xr
    .endif

    .repeat w_target, iter
        ldr yr: m_comp, eindex l_target, w_target, iter, endian ~t_target
        cpr yr: m_load, eindex l_source, w_source, iter, endian ~t_source
        bne phase2
        ner xr, (endian w_target)
    .endrepeat

    .if     endian t_source = endian t_target
        ora #ZF + CF + NF
    .else
        ; load hibyte
        ldr yr: m_load, eindex l_source, w_source, 0, endian ~t_source
        cpr yr: imm, $80
        ldr yr: m_comp, eindex l_target, w_target, 0, endian ~t_target

        bcs __n_q
        ; __p_q
        bmi __p_n
        ora #ZF + CF + NF
        bne exit

        __p_n:
        ora #ZF + CF
        bne exit

        __n_q:
        bmi __p_n
        ora #ZF + CF + NF
        bne exit
    .endif
    
    phase2:
        ; if we have reached here there are two possibilities
        ; load[r] <> comp[r] || fallback <> comp[r]

    /*

        If sign difference with negative value, early exit

    */

    ; fetch values for numerical compare
    str yr: wabs, tardelta  ; store largest delta (source-target) from target 
    
    ldr yr: wabsx, l_source ; fetch from target where indexed
    str yr: wabs, srcdelta  ; store largest delta (source-target) from source

    ; Y CONTAINTS SOURCE DELTA
    ; X IS STALE

    .if signed t_source && (!signed t_target)
        ldr xr: m_load, eindex l_source, w_source, 0, endian ~t_source
        bmi exit
        ; unsigned compare now suffices

        cpr yr: wabs, tardelta
        bcc exit
    .elseif signed t_target && (!signed t_source)
        ldr xr: m_load, eindex l_source, w_source, 0, endian ~t_source
        bpl exit
        ; unsigned compare now suffices

        cpr yr: wabs, tardelta
        bcs exit
    .elseif signed t_source && signed t_target
        ldr xr: m_comp, eindex l_target, w_target, 0, endian ~t_target
        cpr xr: imm, $80
        ldr xr: m_load, eindex l_source, w_source, 0, endian ~t_source
        

        bcs __negative
        bmi exit1

        cpr yr: wabs, tardelta
        bcs exit1
        bcc exit

        __negative:
        bpl exit1

        cpr yr: wabs, tardelta
        bcc exit1
        beq exit1
        bcs exit
    .else
        bcc exit
    .endif

    exit1:
        ora #(CF + OF)

    exit:
        pha
        plp ; ststat (not warranting a whole ass dependancy)

    ; memory cleanup
    dealloc tardelta, 1
    dealloc srcdelta, 1
.endmacro
.endif