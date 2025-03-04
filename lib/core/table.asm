; TODO: perform checks to identify if its poly i (idtable)
.macro poly __func__, __il$__, __ih$__, __b$__, __c$__, __d$__, __e$__, __f$__, __g$__, __h$__, __j$__, __k$__, __l$__, __m$__, __n$__, __o$__, __p$__, __q$__, __r$__, __s$__, __t$__, __u$__, __v$__, __w$__, __z$__
    .local il, ih

    il .set 0
    ih .set 256

    .ifnblank __il$__
        .if !is_null __il$__
            il .set __il$__
        .endif
    .endif

    .ifnblank __ih$__
        .if !is_null __ih$__
            ih .set __ih$__
        .endif
    .endif

    .define i()  (il + ir)
    .define b()  (__b$__)
    .define d()  (__d$__)
    .define e()  (__e$__)
    .define f()  (__f$__)
    .define g()  (__g$__)
    .define h()  (__h$__)
    .define j()  (__j$__)
    .define k()  (__k$__)
    .define l()  (__l$__)
    .define m()  (__m$__)
    .define n()  (__n$__)
    .define o()  (__o$__)
    .define p()  (__p$__)
    .define q()  (__q$__)
    .define r()  (__r$__)
    .define s()  (__s$__)
    .define t()  (__t$__)
    .define u()  (__u$__)
    .define v()  (__v$__)
    .define w()  (__w$__)
    .define z()  (__z$__)

    .repeat (ih - il), ir
        .byte __func__
    .endrepeat

    .undefine i
    .undefine b
    .undefine d
    .undefine e
    .undefine f
    .undefine g
    .undefine h
    .undefine j
    .undefine k
    .undefine l
    .undefine m
    .undefine n
    .undefine o
    .undefine p
    .undefine q
    .undefine r
    .undefine s
    .undefine t
    .undefine u
    .undefine v
    .undefine w
    .undefine z
.endmacro

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

.define numerical_width(__num__)\
    (__num__ > $0000_0000) + (__num__ > $0000_00ff) + (__num__ > $0000_ff00) + (__num__ > $00ff_0000)