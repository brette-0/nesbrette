.ifndef compare

.macro compare __source__, __target__
    .local phase2, exit, smaller, w_source, w_target, t_target, t_source, l_target, l_source, _reg, m_comp, m_load, fallback
    /*

        TODO: Rewrite optional parameter validation
        TODO: Write Width Mismatch Fallback
        TODO: Consider Constant $ff, $01 instead of calculated
        (int: ptr)  __source__
        (int: ptr)  __target__

        limits:
            needs a, x & y
            needs 2 bytes of nb_temp-ram
            
            needs 1 extra byte of nb_temp-ram for compares in which the smaller array is signed

        response:
            cpu stat
                Z   - equal to bitwise
                C   - Greater than or equal to
                V   - Greater than
                N   - equal to numerically
    */

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

    srcdelta .set null
    tardelta .set null

    malloc srcdelta, 1
    malloc tardelta, 1

    fill .set null
    .if w_source <> w_target
        
        malloc fill, 1
    .endif

    .if w_source > w_target
        .if signed w_target
            lda eindex l_target, w_target, 0, (!e_target)
            ora #$7f
            bmi __isneg
            lda #$00
            __isneg:    ; effective sex
        .else
            fill .set $00
        .endif
    .elseif
        .if signed w_source
            lda eindex l_source, w_source, 0, (!e_source)
            ora #$7f
            bmi __isneg
            lda #$00
            __isneg:    ; effective sex
        .else
            fill .set $00
        .endif
    .endif
    php         ; ldsstat
    pla
    and #~(CF + NF + OF + ZF)
    
    ; this looks wrong, but its right because we index backwards naturally
    ldx #eindex 0, w_source, 0, (!e_source)

    .if     w_source = w_target
        .repeat w_target - 1, iter
            ldy eindex l_target, w_target, iter, endian ~t_target
            cpy eindex l_source, w_source, iter, endian ~t_source
            bne phase2
            ner xr, (!endian w_target)
        .endrepeat

        ldy eindex l_target, w_target, (w_target - 1), endian ~t_target
        cpy eindex l_source, w_source, (w_target - 1), endian ~t_source
        bne phase2
    .elseif w_target > w_source
        ; mam changes because signed may result negative
        .if signed t_source
            ldy fill
        .else
            ldy #fill
        .endif

        .repeat w_target - w_source, iter
            cpy eindex l_source, w_source, iter, endian ~t_source
            bne phase2
            ner xr, (!endian w_target)
        .endrepeat

        .repeat w_source - 1, iter
            ldy eindex l_target, w_target, iter, endian ~t_target
            cpy eindex l_source, w_source, (iter + w_target - w_source), endian ~t_source
            bne phase2
            ner xr, (!endian w_target)
        .endrepeat

        ldy eindex l_target, w_target, (w_target - 1), endian ~t_target
        cpy eindex l_source, w_source, (w_target - 1), endian ~t_source
        bne phase2
    .else
        .if signed t_target
            ldy fill
        .else
            ldy #fill
        .endif
        
        .repeat w_source - w_target, iter
            cpy eindex l_target, w_target, iter, endian ~t_target
            bne phase2
            ner xr, (!endian w_target)
        .endrepeat

        .repeat w_source - 1, iter
            ldy eindex l_target, w_target, (iter + w_source - w_target), endian ~t_target
            cpy eindex l_source, w_source, iter, endian ~t_source
            bne phase2
            ner xr, (!endian w_target)
        .endrepeat

        ldy eindex l_target, w_target, (w_target - 1), endian ~t_target
        cpy eindex l_source, w_source, (w_target - 1), endian ~t_source
        bne phase2
    .endif

    e_source = endian t_source
    e_target = endian t_target

    s_source = signed t_source
    s_target = signed t_target

    .if    s_source = s_target
        ora #ZF + CF + NF
        bne exit
    .else
        ; load hibyte

        .if     w_source >= w_target
            ldy eindex l_source, w_source, 0, (!e_source)
            bmi _n
        .elseif s_source
            ldy fill
            bmi _n
        .endif

        .if     w_target >= w_source
            ldy eindex l_target, w_target, 0, (!e_target)
            bmi _n
        .elseif s_target
            ldy fill
            bmi _n
        .endif
        
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
    .if     (!s_source) && s_target
        .if w_target >= w_source
            ldx eindex l_target, w_source, 0, (!e_source)
            bmi exit1  ; if b0d0 is set on target then target is negative, source is always larger
        .elseif s_target
            ldx fill
            bmi exit1
        .endif

        ; otherwise its safe to comapre as unsigned
        cpy tardelta
        bcc exit
    .elseif s_source && (!s_target)
        .if w_source >= w_target
            ldx eindex l_source, w_source, 0, (!e_source)
            bmi exit  ; if b0d0 is set on target then target is negative, source is always larger
        .elseif s_source
            ldx fill
            bmi exit
        .endif

        ; otherwise its safe to comapre as unsigned
        cpy tardelta
        bcc exit
    .elseif s_source && s_target
        .if w_target >= w_source
            ldx eindex l_target, w_target, 0, (!e_target)
        .else
            ldx fill
        .endif
        cpx #$80
        
        .if w_source >= w_target
            ldx eindex l_source, w_source, 0, (!e_source)
        .else
            ldx fill
        .endif

        bcs __negative
        bmi exit        ; tS [skips V and C ][ sets V and C ]

        __compare:
        cpy tardelta    ; ts 
        bcs exit1
        bcc exit

        __negative:
        bmi __compare   ; TS
        bpl exit1       ; Ts [ sets V and C ]
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
    .if w_source <> w_target
        dealloc fill, 1
    .endif

    dealloc tardelta, 1
    dealloc srcdelta, 1
.endmacro
.endif