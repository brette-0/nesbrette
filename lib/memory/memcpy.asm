/*
    TODO: Test 'order of steps' parameter '__order$__'
*/


.macro memcpy __source__, __target__, __reg$__, __modes$__, __stwm$__, __fill$__, __zero$__, __order$__
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

    e_target = endian t_target

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

        .if   (m_source > absx)
            .fatal "UnsupportedFeatureException: memcpy will never use indirectness, its always slow."          ; unsupported
        .elseif (m_target > inabs) || (m_target < imp)
            .fatal "InvalidMemoryAddressModeException: This memory address mode isnt recognized."               ; erroneous mam
        .elseif i_source && (i_source = i_target)
            .fatal "IntereferingRegisterUseException: Cannot index by same register used for data transfer."    ; conflict gpr 
        .elseif (i_source <> ar) && (i_target <> ar)
            .fatal "InvalidMemoryAddressModeException: Cannot store X/Y with indexed memory address mode."      ; invalid mam
        .endif
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

    ; fill = __fill$__ ?? 1
    .ifnblank __zero$__
        zero = __zero$__
    .else   
        zero = _reg
    .endif

    .if (w_source < w_target) && fill && .blank(__order$__)
        .if (zero = _reg)
            ldz zero
        .endif

        .repeat w_target - w_source, iter
            str m_target: _reg, eindex l_target, w_target, (w_target - w_source + iter), e_target
        .endrepeat
    .endif

    .if     w_source < w_target
        report stwm, "SourceTargetWidthMismatchException: nesbrette will write trailing zeroes into the target."
    .elseif w_source > w_target
        report stwm, "SourceTargetWidthMismatchException: Target cannot store all data, and therefore will only store a masked result."
    .endif

    .repeat .min(w_source, w_target), iter
        ldr m_source: _reg, eindex l_source, w_source, iter, (endian t_source)
        str m_target: _reg, eindex l_target, w_target, iter, (endian t_target)
    .endrepeat

    .if (w_source < w_target) && fill && (!.blank(__order$__))
        .if (zero = _reg)
            ldz zero
        .endif

        .repeat w_target - w_source, iter
            str m_target: _reg, eindex l_target, w_target, (w_target - w_source + iter), e_target
        .endrepeat
    .endif
.endmacro