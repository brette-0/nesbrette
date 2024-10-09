    .enum
        noptr       = 0
        ioptr       = 1
        inline      = 2
        big         = 4
        unroll      = 8
        absolute    = 16
        big         = 32
        u16         = 64
        u24         = 96
        u32         = 128
        u64         = 256
        u128        = 512
        u256        = 1024
        u512        = 2048
        u1024       = 4096
        u2048       = 8192
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
            isabsolute = CONFIG_MODULES_MATH_FORCE_ABSOLUTE
        .else
            .if bitwidth .and (.not isinline)
                .fatal "cannot declare as absolute if not inline, use CONFIG_MODULES_MATH_FORCE_ABSOLUTE"
            .endif
        .endif

        .ifndef isabsolute  ; inline only
            isabsolute = CONFIG_MODULES_MATH_FORCE_ABSOLUTE
        .else
            .if isabsolute .and (.not isinline)
                .fatal "cannot declare as absolute if not inline, use CONFIG_MODULES_MATH_FORCE_ABSOLUTE"
            .endif
        .endif

        .ifndef isunrolled  ; inline only
            isunrolled = CONFIG_MODULES_MATH_FORCE_UNROLL
        .else
            .if isunrolled .and (.not isinline)
                .fatal "cannot declare as unrolled if not inline, use CONFIG_MODULES_MATH_FORCE_UNROLL"
            .endif
        .endif

        .ifndef isbig       ; inline only
            isbig = CONFIG_MODULES_MATH_BIG_ENDIAN
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
                    ldx #(bitwidth >> 5)
                    jsr nesbrette::modules::math::__add_noptr__body
                .else
                    ldy #(bitwidth >> 5)
                    jsr nesbrette::modules::math::__add_ioptr__body
                .endif
            .else
                .if mode == noptr
                    jsr nesbrette::modules::math::__add_noptr_fetch_width
                .else
                    jsr nesbrette::modules::math::__add_ioptr_fetch_width
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
        .if arg1 & absolute
            isabsolute = 1
            .endif
        .if arg1 & unroll
            isunrolled = 1
            .endif
        .if arg1 & big
            isbig      = 1
            .endif
        .if arg1 & ~(u16-1)
            bitwidth = ~(u16-1)
            .endif

        add arg2 arg3 arg4 arg5 ; call with reduced args
        .exitmacro              ; leave macro (recurse back into proir call)
            
    .endmacro                   ; close macro (complete definition)