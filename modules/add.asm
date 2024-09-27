    .enum
        noptr       = 0
        iptr        = 1
        optr        = 2
        ioptr       = 3
        inline      = 4
        unroll      = 8
        u16         = 16
        u24         = 24
        u32         = 32
        u64         = 64
        absolute    = 128
    .endenum


.macro add_vptr_retarget_out ramaddr tar
    .if ADDRESSES_MATH_ADD_OUT < 0
        .if tar < 0
            lda #tar
            sta ramaddr + 3
            .if ADDRESSES_MATH_ADD_MOD < $100
                sta ramaddr + 7
            .else
                sta ramaddr + 8
            .endif
        .else
            .fatal "cannot retarget with two byte operand, if target is zeropage. Add absolute flag?"
        .endif
    .else
        .if tar > $ffff
            .fatal "impossible target"
            .endif
        
        mod_zp = ADDRESSES_MATH_ADD_MOD < $100

        lda #(tar & $ff)
        sta ramaddr + 3
        sta ramaddr + 8 + mod_zp

        lda #(tar >> 8)
        sta ramaddr + 4
        sta ramaddr + 9 + mod_zp

    .endif
    .endmacro 

.macro add_vptr_retarget_out tar
    .if ADDRESSES_MATH_ADD_OUT < 0
        .if tar < 0
            lda #tar
            .if ADDRESSES_MATH_ADD_MOD < $100
                sta ramaddr + 5
            .else
                sta ramaddr + 6
            .endif
        .else
            .fatal "cannot retarget with two byte operand, if target is zeropage. Add absolute flag?"
        .endif
    .else
        .if tar > $ffff
            .fatal "impossible target"
            .endif
        
        out_zp = ADDRESSES_MATH_ADD_OUT < $100

        lda #(tar & $ff)
        sta ramaddr + 5 + out_zp

        lda #(tar >> 8)
        sta ramaddr + 6 + out_zp

    .endif
    .endmacro 


.macro add arg1 arg2 arg3 arg4
    .ifndef arg1
        ; begin evaluating            
        .ifndef mode
            mode = noptr
            .endif

        .ifndef isinline
            isinline = 0
            .endif

        .ifndef bitwidth
            bitwidth = 0    ; vwidth
            .endif

        .if isinline
            .if mode == noptr
                ; include noptr add
            .elseif mode == iptr
                ; include iptr add
            .elseif mode == optr
                ; include optr add
            .else
                ; include ioptr add
            .endif
        .else
            .if bitwidth
                ldx #(bitwidth >> 3)
                .if mode == noptr
                    jsr nesbrette::modules::math::__add_noptr__body
                .elseif mode == iptr
                    jsr nesbrette::modules::math::__add_noptr__body
                .elseif mode == optr
                    jsr nesbrette::modules::math::__add_noptr__body
                .else
                    jsr nesbrette::modules::math::__add_noptr__body
                .endif
            .else
                .if mode == noptr
                    jsr nesbrette::modules::math::__add_noptr_fetch_width
                .elseif mode == iptr
                    jsr nesbrette::modules::math::__add_noptr_fetch_width
                .elseif mode == optr
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

        add arg2 arg3 arg4  ; call with reduced args
        .exitmacro          ; leave macro (recurse back into proir call)
            
    .endmacro               ; close macro (complete definition)