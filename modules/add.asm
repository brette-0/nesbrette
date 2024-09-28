    .enum
        noptr       = 0
        ioptr       = 1
        inline      = 2
        big         = 4
        unroll      = 8
        u16         = 16
        u24         = 24
        u32         = 32
        u64         = 64
        absolute    = 128
        big         = 256
    .endenum

; add macros to mod vptr targets

.macro add arg1 arg2 arg3 arg4 arg5
    .ifndef arg1
        ; begin evaluating            
        .ifndef mode
            mode = noptr
            .endif

        .ifndef isinline
            isinline = 0
            .endif

        .ifndef bitwidth    ; inline only
            isabsolute = 0
        .else
            .if bitwidth .and (.not isinline)
                .fatal "cannot declare as absolute if not inline, use CONFIG_MODULES_MATH_FORCE_ABSOLUTE"
            .endif
        .endif

        .ifndef isabsolute  ; inline only
            isabsolute = 0
        .else
            .if isabsolute .and (.not isinline)
                .fatal "cannot declare as absolute if not inline, use CONFIG_MODULES_MATH_FORCE_ABSOLUTE"
            .endif
        .endif

        .ifndef isunrolled  ; inline only
            isunrolled = 0
        .else
            .if isunrolled .and (.not isinline)
                .fatal "cannot declare as unrolled if not inline, use CONFIG_MODULES_MATH_FORCE_UNROLL"
            .endif
        .endif

        .ifndef isbig       ; inline only
            isbig = 0
        .else
            .if isbig .and (.not isbig)
                .fatal "cannot declare as big endian if not inline, use CONFIG_MODULES_MATH_BIG_ENDIAN"
            .endif
        .endif

        

        
        .if isinline
            .if mode == noptr
                .include nesbrette + "/modules/math/add_noptr.asm"
            .else
                .include nesbrette + "/modules/math/add_ioptr.asm"
            .endif
        .else
            .if bitwidth
                .if mode == noptr
                    ldx #(bitwidth >> 3)
                    jsr nesbrette::modules::math::__add_noptr__body
                .else
                    ldy #(bitwidth >> 3)
                    jsr nesbrette::modules::math::__add_noptr__body
                .endif
            .else
                .if mode == noptr
                    jsr nesbrette::modules::math::__add_noptr_fetch_width
                .else
                    jsr nesbrette::modules::math::__add_noptr_fetch_width
                .endif
            .endif
        .endif

    .else
        ; log params
        .if (arg1 & ioptr) != noptr
            mode     = arg1 & ioptr
            .endif
        .if arg1 & inline
            isinline = 1
            .endif
        .if arg1 & ~(inline + ioptr)
            bitwidth = arg1 & ~(unroll + ioptr)
            .endif
        .if arg1 & absolute
            isabsolute = 1
            .endif
        .if arg1 & unroll
            isunrolled = 1
            .endif
        .if arg1 & big
            isbig      = 1
            .endif

        add arg2 arg3 arg4 arg5 ; call with reduced args
        .exitmacro              ; leave macro (recurse back into proir call)
            
    .endmacro                   ; close macro (complete definition)