
.macro poly __func__, __il$__, __ih$__
    .local il, ih

    il .set 0
    ih .set 256

    .ifnblank __il$__
        il .set __il$__
    .endif

    .ifnblank __ih$__
        ih .set __ih$__
    .endif

    .define i()  (il + ir)
    .repeat (ih - il), ir
        .byte __func__
    .endrepeat
.endmacro

.macro table __name__, __il$__, __ih$__, __func$__
    .local il, ih

    il .set 0
    ih .set 256

    .ifnblank __il$__
        il .set __il$__
    .endif

    .ifnblank __ih$__
        ih .set __ih$__
    .endif

    .if     .xmatch(__name__, id)
        ; generate idtable
        table poly, i, 0, 256
        .exitmacro               ; y = x (limit 0 <+ x < 256)
    .elseif .xmatch(__name__, sin)
        ; generate sin table
    .elseif .xmatch(__name__, cos)
        ; generate cos table
    .elseif .xmatch(__name__, tan)
        ; generate tan table
    .elseif .xmatch(__name__, asin)
        ; generate asin table
    .elseif .xmatch(__name__, acos)
        ; generate acos table
    .elseif .xmatch(__name__, atan)
        ; generate atan table
    .elseif .xmatch(__name__, sct)
        ; generate sct table
    .elseif .xmatch(__name__, csc)
        ; generate csc table
    .elseif .xmatch(__name__, cot)
        ; generate cot table
    .elseif .xmatch(__name__, asct)
        ; generate asct table
    .elseif .xmatch(__name__, acsc)
        ; generate acsc table
    .elseif .xmatch(__name__, acot)
        ; generate acot table
    .elseif .xmatch(__name__, bcd)
        ; generate bcd table
    .elseif .xmatch(__name__, poly)
        
    .else
    .endif
.endmacro