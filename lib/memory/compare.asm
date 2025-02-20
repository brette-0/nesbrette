.ifndef compare

.macro compare __source__, __target__, __reg$__, __modes$__, __fallback$__
    .local phase2, exit, smaller, w_source, w_target, t_target, t_source, l_target, l_source, _reg, m_comp, m_load, fallback

    /*

        TODO: Rewrite optional parameter validation

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
                Z   - equal to
                [ TODO: USE N FLAG FOR SIGNED DIFFERENCE WITH SIGNED ARRAY TYPES ]
                    {
                        reasoning : N does not behave in a semantically typical
                                    way alike how Z and C does.
                    }
                C   - Greater than or equal to
                V   - Greater than


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

    .if (!w_source) || (!w_target)
        ; invalid type
    .endif

    l_source = .right(1, __source__)
    l_target = .right(1, __target__)
    
    ; validate modes and registers

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

; TODO: FAULTY (see header)
;    ldr r_data: m_load, eindex l_source, w_source, (w_source - 1), endian t_source
;    cpr r_data: m_comp, eindex l_target, w_target, (w_target - 1), endian t_target

;    bpl nosigndiff
;    ora #NF
;    nosigndiff:

    exit:
    pha
    plp ; ststat (not warranting a whole ass dependancy)
.endmacro

.endif