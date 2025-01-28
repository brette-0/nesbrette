; untested
.macro compare __base__, __compare__, __status__, __regs__
    .local t_base, t_comp, _ireg, _reg

    .ifblank __base__
        .fatal "long compare needs base value to compare"
    .endif 

    .ifblank __compare__
        .fatal "long compare needs compare value to compare"
    .endif

    t_base .set 0
    t_comp .set 0

    detype __base__, t_base
    detype __compare__, t_comp

    .ifblank __regs__
        _ireg = xr
        _reg  = ar
    .else
        _reg   =  setreg (.left(1,  __regs__))
        _ireg  = setireg (.right(1, __regs__))
    .endif

    .if (typeval __base__) <> (typeval <> t_comp)
        .warning "Compares are of differing sizes, will only compare smaller region"
    .endif

    .if (typeval __base__) = 0 || (typeval __valcompare) = 0
        .warning "Compared Emptiness"
        .exitmacro
    .endif

    .if ((endian __base__) <> (endian __compare__)) && (isconst __base__) && (isconst __compare__)
        .fatal "Cannot compare values with differing endians within one loop"
    .endif

    /*
        Alright, fine : you can, but not without specifying that you want to use all three registers
        I don't think thats fair on the user, so I won't add it. Unroll the code if you need to or just
        don't miss match endianness.  
    */

    .ifblank __status__
        .fatal "long compare needs specified cpu status flags"
    .endif

    .if ( abs __status__ ) <> status & (abs (zf + cf)) && WARNINGS_MEMORY_COMPARE_UNSUPPORTED_FLAGS
        .warning "long compare will not set all flags, but will clear them"
    .endif

    ldstat
    and #~__status__   ; clear values we intend to change (if a funtion exists, elsewise nuke)

    .if __status__ & (abs zf)
        __eqcompare __base__, __compare__, __width__, _ireg, _reg
    .endif

    .if __status__ & (abs cf)
        __valcompare __base__, __compare__, __width__, _ireg, _reg
    .endif

    ststat

    .endmacro

.macro __eqcompare  __base__, __compare__, __width__, _ireg, _reg
    ; 'engine' macro performs no validation : assumes parameters are validated on entry

    
    .if _reg = ar
        pha
    .endif

    .if  __width__ > 0
        .repeat __width__, iter
            ldr _reg: wabs, (eindex __width__: __base__, iter)
            rcp _reg: wabs, (eindex __width__: __compare__, iter)
            bne @exit
        .endrepeat
    .else
        @loop:
            der _ireg
            ldr (wabs + _ireg): _reg
            rcp (wabs + _ireg): _reg
            bne @loop

            rcp _ireg: imm, $00
            bne @loop
    .endif
    
    .if _reg = a
        pla                                 ; fetch original a
        ora #(abs zf)                        ; set z
        .exitmacro

        @exit:
            pla
            .exitmacro                      ; leave with original
    .else
        ora #(abs zf)                        ; set z
        @exit:
            .exitmacro                      ; leave with original
    .endif
.endmacro


.macro __valcompare  __base__, __compare__, __width__, _ireg, _reg
    ; 'engine' macro performs no validation : assumes parameters are validated on entry

    .if _reg = ar
        pha
    .endif

    .if __width__ > 0
        .repeat __width__, iter
            ldr _reg: wabs, (eindex __width__: __base__, iter)
            rcp _reg: wabs, (eindex __width__: __compare__, iter)
            bcc @exit
        .endrepeat
    .else
        @loop:
            der _ireg
            ldr (wabs + _ireg): _reg
            rcp (wabs + _ireg): _reg
            bcc @loop

            rcp _ireg: imm, $00
            bne @loop
    .endif

    .if _reg = ar
        pla                                 ; fetch original a
        ora #(abs cf)                       ; set z
        .exitmacro

        @exit:
            pla
            .exitmacro                      ; leave with original
    .else
        ora #(abs cf)                       ; set z
        @exit:
            .exitmacro                      ; leave with original
    .endif
.endmacro

/*

    Do not set N, we can let the user handle that.
    The issue arises with type semantics and general N flag abuse being typical

*/