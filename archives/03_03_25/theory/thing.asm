; TODO: Test this (time to use ca65hl square brackets as index instead of pointer math)
.macro __num__, __width__, __endian__
    .local num
    
    .if numerical_width(__num__) > __width__
        report warning, "TableEntryWidthException : The specified Width per entry is too low to accomodate accurate values for all entries"
    .endif

    num .set __num__
    lendian .set 0

    .ifnblank __endian$__
        .if !is_null __endian$__
            lendian .set __endian$__
        .endif
    .endif

    .if __endian__
        .repeat numerical_width(__num__), iter
            .byte num & $ff
            num .set num >> 8
        .endrepeat

        ; sign extend
        .if num < 0
            .res 4 - numerical_width(__num__), $ff
        .else
            .res 4 - numerical_width(__num__), $00
        .endif
    .else
        ; sign extend
        .if num < 0
            .res 4 - numerical_width(__num__), $ff
        .else
            .res 4 - numerical_width(__num__), $00
        .endif
        
        .repeat numerical_width(__num__), iter
            .byte num & ($ff << 8 * (numerical_width(__num__) - iter - 1))
            num .set num & ~($ff << 8 * (numerical_width(__num__) - iter - 1))
        .endrepeat
    .endif
.endmacro