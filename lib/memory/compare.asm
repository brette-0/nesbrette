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

    .ifblank __modes$__
        m_load = wabs
        m_comp = wabs
    .else
        m_load = setmam .left( 1, __modes$__)
        m_comp = setmam .right(1, __modes$__)
    .endif

    php         ; ldsstat
    pla
    and #~(CF + NF + OF + ZF)
    
    ; this looks wrong, but its right because we index backwards naturally
    .if endian w_source
        tax
    .else
        ldx #w_source - 1
    .endif

    .repeat w_target - 1, iter
        ldy eindex l_target, w_target, iter, endian ~t_target
        cpy eindex l_source, w_source, iter, endian ~t_source
        bne phase2
        ner xr, (!endian w_target)
    .endrepeat

    ldy eindex l_target, w_target, (w_target - 1), endian ~t_target
    cpy eindex l_source, w_source, (w_target - 1), endian ~t_source
    bne phase2


    e_source = endian t_source
    e_target = endian t_target

    s_source = signed t_source
    s_target = signed t_target

    .if    s_source = s_target
        ora #ZF + CF + NF
        bne exit
    .else
        ; load hibyte
        ldy eindex l_source, w_source, 0, (!e_source)
        bmi _n
        ldy eindex l_target, w_target, 0, (!e_target)
        bmi _n

        ora #ZF + CF + NF
        bne exit

        _n:
        ora #ZF + CF
        bne exit
    .endif
    
    phase2:
        ; if we have reached here there are two possibilities
        ; load[r] <> comp[r] || fallback <> comp[r]

    /*

        If sign difference with negative value, early exit

    */

    ; fetch values for numerical compare
    sty tardelta            ; store largest delta (source-target) from target 
    
    ldy l_source, x         ; fetch from target where indexed
    sty srcdelta            ; store largest delta (source-target) from source

    ; Y CONTAINTS SOURCE DELTA
    ; X IS DELTA BYTE OFFSET

    ; unsigned against signed
    .if (!s_source) && s_target

        ldx eindex l_source, w_source, 0, (!e_source)
        bmi exit1   ; if b0d0 is set, the value cannot be reached by signed

        ldx eindex l_target, w_source, 0, (!e_source)
        bmi exit1   ; if b0d0 is set on target then target is negative, source is always larger

        ; otherwise its safe to comapre as unsigned
        cpy tardelta
        bcc exit
    ; signed against unsigned
    .elseif s_source && (!s_target)

        ldx eindex l_target, w_source, 0, (!e_source)
        bmi exit    ; if b0d0 is set, the value cannot be reached by signed

        ldx eindex l_source, w_source, 0, (!e_source)
        bmi exit    ; if b0d0 is set on source then source is negative, target is always larger

        ; otherwise its safe to comapre as unsigned
        cpy tardelta
        bcc exit

    ; signed vs signed
    .elseif s_source && s_target
        ldx eindex l_target, w_target, 0, (!e_target)
        cpx #$80
        ldx eindex l_source, w_source, 0, (!e_source)

        bcs __negative
        bmi exit        ; tS [skips V and C ][ sets V and C ]

        cpy tardelta    ; ts 
        bcs exit1
        bcc exit

        __negative:
        bpl exit1       ; Ts [ sets V and C ]

        cpy tardelta    ; TS
        bcs exit1
        bcc exit
    .else
    ; unsigned vs
        bcs exit
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