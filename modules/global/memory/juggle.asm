; untested

.macro juggle __tokens__, __widths__, __temp__, __polarity__
    ; (final element should have no width)
    ; t0 => t-1


    .if .tcount(__widths___) = 1
        __fixed_width__ = .index(__widths__, 0)
        .endif

    .if __polarity__
        memcpy index(.tcount(__tokens__) - 1, __temp__, index(.tcount(__tokens__) - 1, __widths__)
    .else
        memcpy index(0, __tokens__), __temp__, index(0, __widths__)
    .endif
    
    .repeat .tcount(__tokens__), iter
        .if iter <> 0 .or iter = .tcount(__tokens__)          ; zero is handled outside the loop
            .if __polarity__
                src .set index(iter, __tokens__)
                tar .set index(iter - 1, __tokens__)
                taw .set index(iter - 1, __widths__)
            .else
                src .set index(iter - 1, __tokens__)
                tar .set index(iter, __tokens__)
                taw .set index(iter, __widths__)
            .endif

            .ifdef __fixed_width__
                taw .set __fixed_width__
                .endif

            memcpy src, tar, taw
            .endif
        .endrepeat
    
    .if __polarity__
        memcpy __temp__, index(0, __tokens__), index(0, __widths__)
    .else
        memcpy __temp__, index(.tcount(__tokens__) - 1, __tokens__), index(.tcount(__tokens__) - 1, __widths__)      
    .endif
    .endmacro