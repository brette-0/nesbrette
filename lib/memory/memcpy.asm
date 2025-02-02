.macro memcpy __source__, __target__, __reg$__, __modes$__
    ; (nb_int: ident) __source__ 
    ; (nb_int: ident) __target__ 
    ; (gpr) __reg$__
    ; (mode: mode) __modes$__
        
    detype __source__, t_source
    detype __source__, t_target

    _reg .set ar

    .ifblank __reg$__
        _reg .set __reg$__
    .endif

    m_source .set (setreg __source__)   ; gpr?
    m_target .set (setreg __target__)   ; gpr?

    .ifnblank __modes$__
        m_source .set  .left(1, __source__)
        m_source .set .right(1, __source__)
    .endif

    null_coalset m_source, imm
    null_coalset m_target, imm

    l_source = .right(1, __source__)
    l_source = .right(1, __target__)

    ; width of task is smallest range of legal data
    w_task = .min((typeval t_source), (typeval t_target))

    .if (typeval t_source) <> (typeval t_target)
        report
    .endif

    .ifnblank __reg$__
        _reg .set __reg$__
    .endif

    .repeat w_task, iter
        ldr m_source: _reg, (eindex l_source, w_task, iter, (endian t_source))
        str m_target: _reg, (eindex t_source, w_task, iter, (endian t_source))
    .endrepeat
.endmacro