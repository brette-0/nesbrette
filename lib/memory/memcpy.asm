/*

    possible behaviors:
        w_src = w_tar (good, all data is copied out)
        w_src > w_tar (bad, some data is copied out to w_tar)
        w_src < w_tar 
            store 'fill' in w_tar   (not actually extra code)

*/


.macro memcpy __source__, __target__, __reg$__, __modes$__, __stwm$__, __fill$__, __zero$__
    .local t_source, t_target, i_source, i_target, m_source, m_target, r_source, r_target, w_source, w_target, l_source, l_target, _reg, stwm
    
    ; (nb_int: ident) __source__ 
    ; (nb_int: ident) __target__ 
    ; (gpr) __reg$__
    ; (mode: mode) __modes$__


    ; null defaults
    t_source .set null
    t_target .set null
        
    
    ; detype typed params
    detype __source__, t_source
    detype __target__, t_target

    ; _reg = __reg$__ ?? ar
    _reg .set null
    .ifnblank __reg$__
        _reg .set __reg$__
    .endif
    null_coalset _reg, ar

    

    
    m_source .set null
    m_target .set null

    i_source .set isindexed m_source
    i_target .set isindexed m_target

    .ifnblank __modes$__
        m_source .set  .left(1, __modes$__)
        m_target .set .right(1, __modes$__)

        .if     (m_source > inabs) || (m_source < imp)
            .fatal ""   ; invalid mam
        .elseif (m_target > inabs) || (m_target < imp)
            .fatal ""   ; invalid mam
        .elseif i_source && (i_source = i_target)
            .fatal ""   ; conflict gpr 
        .endif
        ; TODO: handle invalid instructions AOT here
    .endif

    ; stwm = __stwm$__ ?? (SourceTargetWidthMismatchException ?? warning)
    .ifnblank __stwm$__
        deferror __stwm$__, stwm
    .else
        .ifdef SourceTargetWidthMismatchException
            deferror SourceTargetWidthMismatchException, stwm
        .else
            deferror warning, stwm
        .endif
    .endif

    null_coalset m_source, wabs
    null_coalset m_target, wabs
    
    l_source = .right(1, __source__)
    l_target = .right(1, __target__)

    w_source = typeval t_source
    w_target = typeval t_target

    ; fill = __fill$__ ?? 1
    .ifnblank __fill$__
        fill = __fill$__
    .else   
        fill = 1
    .endif
    
    ; width of task is smallest range of legal data
    w_task = .min(w_source, w_target)

    .if     w_source < w_target
        report SourceTargetWidthMismatchException, "SourceTargetWidthMismatchException: nesbrette will write trailing zeroes into the target."
    .elseif w_source > w_target
        report SourceTargetWidthMismatchException, "SourceTargetWidthMismatchException: Target cannot store all data, and therefore will only store a masked result."
    .endif

    .if (w_source < w_target) && fill
        stz (w_target - w_source): (eindex l_target, w_target, w_source, endian t_target), __regs$__, __zero$__
    .endif

    .repeat w_task, iter
        ldr m_source: _reg, eindex l_source, w_source, iter, (endian t_source)
        str m_target: _reg, eindex l_target, t_target, iter, (endian t_target)
    .endrepeat
.endmacro