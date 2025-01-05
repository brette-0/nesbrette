.macro juggle __tokens__, __widths__
    ; (final element should have no width)
    ; t0 => t-1
    memcpy  index(0, __tokens__),         index(.tcount(__tokens__),     __tokens__), index(0,        __widths__)
    
    .repeat .tcount(__tokens__), iter
        .if iter <> 0   ; zero is handled outside the loop
            memcpy index(iter, __tokens__),index(iter - 1, __tokens__),  __tokens__), index(iter - 1, __widths__)
            .endif
        .endrepeat
    
    .endmacro