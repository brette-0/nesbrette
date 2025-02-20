.ifndef compare

.macro compare __source__, __target__, __reg$__, __modes$__, __fallback$__
    .local phase2, exit, smaller, w_source, w_target, t_target, t_source, l_target, l_source, _reg, m_comp, m_load, fallback
    /*

        TODO: Rewrite optional parameter validation
        TODO: MOVE FIXED OFFSET TO RAM REQUEST SYSTEM

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
                C   - Greater than or equal to#
                    TODO: Make C be signed compare
                V   - Greater than


        usage:
            compare Source, Target
            compare Source, Target, wabsx: wabsy
    */

    request temp, 2

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

    .ifblank __reg$__
        r_data = yr
    .else
        r_data = setireg __reg$__
    .endif

    .ifblank __modes$__
        m_load = wabs
        m_comp = wabs
    .else
        m_load = setmam .left( 1, __modes$__)
        m_comp = setmam .right(1, __modes$__)
    .endif

; TODO: SCAN IS BACKWARDS NOW, IT FINDS THE HIGHEST DELTA BYTE
;       SUBTRACTIONS WILL THEN USE INDEXED DIRECT
;       USES TEMP MEM FOR DELTAS       
;
;       Z is bitwise equality. N is math equality

    lda #$00

    .repeat w_target, iter
        ldr r_data: m_load, eindex l_source, w_source, iter, endian ~t_source
        cpr r_data: m_comp, eindex l_target, w_target, iter, endian ~t_target
        bne phase2
    .endrepeat

    str r_data: wabs, temp  ; store largest delta -
    ldr r_data: (wabsx + (r_comp = yr)), eindex l_target, w_target, iter, endian ~t_target
    str r_data: wabs, temp+1; store larget delta +

    .if .max(0, w_source - w_target)
        ldr r_data: imm, fallback
    
        .repeat .max(0, w_source - w_target), iter
            cpr r_data: m_comp, eindex l_target, w_target, (iter + w_source - w_target), ~endian t_target
            bne phase2
        .endrepeat
    .endif

    ora #ZF + CF
    bne exit
    
    phase2:
        ; if we have reached here there are two possibilities
        ; load[r] <> comp[r] || fallback <> comp[r]

    /*

        If sign difference with negative value, early exit

    */

    .if signed t_source && (!signed t_target)
        ldr r_data: wabs, temp
        bmi exit
        ; unsigned compare now suffices

        cpr r_data: wabs, (temp + 1)
        bcc exit
    .elseif signed t_target && (!signed t_source)
        ldr r_data: wabs, temp
        bpl exit
        ; unsigned compare now suffices

        cpr r_data: wabs, (temp + 1)
        bcs exit
    .elseif signed t_source && signed t_target
        ldr r_data: wabs, (temp + 1)
        cpr r_data: imm, $80
        ldr r_data: wabs, temp
        

        bcs __negative
        bmi exit1

        cpr r_data: wabs, (temp + 1)
        bcs exit1
        bcc exit

        __negative:
        bpl exit1

        cpr r_data: wabs, (temp + 1)
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
.endmacro
.endif