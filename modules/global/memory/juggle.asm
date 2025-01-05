.macro juggle __tokens__, __width__

    ; t0 => t-1
    memcpy  index(0, __tokens__),         index(.tcount(__tokens__),     __tokens__), __width__
    
    .repeat .tcount(__tokens__), iter
        .if iter <> 0   ; zero is handled outside the loop
            memcpy index(iter, __tokens__),index(iter - 1, __tokens__),  __tokens__), __width__
            .endif
        .endrepeat
    
    ; t-1 => t-2
    memcpy  index(.tcount(__tokens__)),   index(.tcount(__tokens__) - 1, __tokens__), __width__
    .endmacro