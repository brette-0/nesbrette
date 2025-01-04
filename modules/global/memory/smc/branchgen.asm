/*

    nesbrette

    branchgen takes a 'body' and its size and unrolls it with 'returns' handled by scope.

    body code should use sets


    example:


    .macro __temp
        dex
        lda ADDRESSES_MATH_MULT_MOD + t_set
        t_set .set (t_set - 1)
        .endmacro
*/

.macro branchgen __body__, __branch__, __width__, __amt__
    .local l_branch, p_branches, n_branches, __branchgen_set

    __branchgen_set .set __amt__
    l_branch    = __width__ - 2
    p_branches  = (128 - l_branch) / __width__
    n_branches  = abs(-120 / __width__)

    .repeat (__amt__ / (l_branch + p_branches + n_branches)) \
        + (__amt__ .mod (l_branch + p_branches + n_branches) <> 0), iter

        __branch (l_branch + p_branches + n_branches)
        __branchgen_set .set (__branchgen_set - (l_branch + p_branches + n_branches))
        .endif

    .endmacro


.macro __branch __amt__
    ; must be called from parent
    .local exit

    .repeat .min(__amt__ - 1 - (__amt__ > (p_branches + 1)), p_branches), iter
        __body__
        .if     .match (__branch__, eq)
            beq @exit
        .elseif .match (__branch__, ne)
            bne @exit
        .elseif .match (__branch__, cs)
            bcs @exit
        .elseif .match (__branch__, cc)
            bcc @exit
        .elseif .match (__branch__, mi)
            bmi @exit
        .elseif .match (__branch__, pl)
            bpl @exit
        .elseif .match (__branch__, vs)
            bvs @exit
        .elseif .match (__branch__, vc)
            bvc @exit
        .endif

        .endrepeat
    .if (__amt__ > (p_branches + 1))
        __body__
        .if     .match (__branch__, eq)
            bne @continue
        .elseif .match (__branch__, ne)
            beq @continue
        .elseif .match (__branch__, cs)
            bcc @continue
        .elseif .match (__branch__, cc)
            bcs @continue
        .elseif .match (__branch__, mi)
            bpl @continue
        .elseif .match (__branch__, pl)
            bmi @continue
        .elseif .match (__branch__, vs)
            bvc @continue
        .elseif .match (__branch__, vc)
            bvs @continue
        .endif
        @exit:
            rts
        @continue:
    .else
        __body__
        @exit:
            rts
    .endif
    .repeat .min(__amt__, n_branches), iter
        __body__
        .if     .match (__branch__, eq)
            bne @exit
        .elseif .match (__branch__, ne)
            beq @exit
        .elseif .match (__branch__, cs)
            bcc @exit
        .elseif .match (__branch__, cc)
            bcs @exit
        .elseif .match (__branch__, mi)
            bpl @exit
        .elseif .match (__branch__, pl)
            bmi @exit
        .elseif .match (__branch__, vs)
            bvc @exit
        .elseif .match (__branch__, vc)
            bvs @exit
        .endif
        .endrepeat
    .endmacro