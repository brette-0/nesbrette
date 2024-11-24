; untested

; constant multiply

.macro cmult __multiplier__, __temp__, __output__, __osize__
    .local _msize_, _lssb_, _mssb_
    ; both modes require a temporary ram address
    .ifblank __temp__
        .ifdef CONSTANTS_MATH_CMULT_TEMP
            _temp_ = CONSTANTS_MATH_CMULT_TEMP
        .else
            .fatal "Constant Multiply demands temporary address, either use CONSTANTS_MATH_CMULT_TEMP or pass a constant as a macro parameter"
        .endif
    .else
        _temp_ = __temp__
    .endif

    .ifblank __multiplier__
        .fatal "Constant Multiplier must have Multiplier operand"
    .endif

    .if !__multiplier__
        .if WARNINGS_MATH_CMULT_MULTZERO
            .warning "Constant multiplication by Zero : Check the value journey of the passed label"
        .endif
        
        lda #$00                        ; return a in accumulator mode
        .ifnblank __osize__             ; or if in address mode, write to output
            .repeat iter, __osize__
                sta __output__ + iter
                .endrepeat
            .endif
        .exitmacro
    .endif

    .repeat 4, iter ; ca65 preprocessor nums are 32bit
        .if !(__multiplier__ >> (iter * 8))
            .ifndef _msize_
                _msize_ = iter
                .endif
            .endif
        .endrepeat

    ; most and least significant set bit macros, works for both accumulator and address mode
    .repeat 8 * _msize_, iter
        .if __multiplier__ >> (((8 * _msize_) - 1) - iter)
            .ifndef _mssb_
                _mssb_ = (((8 * _msize_) - 1) - iter)
                .endif
            .endif
        .endrepeat

    .repeat 8 * _msize_, iter
        .if __multiplier__ & (1 << iter)
            .ifndef _lssb_
                _lssb_ = iter
                .endif
            .endif
        .endrepeat

    .ifblank __output__ ; accumulator mode      
        .if _msize_ > 1 .and WARNINGS_MATH_CMULT_OOB
            .warning "Constant Multiplication : Multiplier out of bounds"
        .endif

        .repeat _lssb_, iter
                asl
            .endrepeat

        .if .not (__multiplier__ - 1) & __multiplier__
            .exitmacro
        .endif
        
        sta _temp_
        clc
        .repeat _mssb_ - _lssb_, iter
            asl _temp_
            .if __multiplier__ >> (iter + _lssb_)
                adc _temp_
                .endif
            .endrepeat
        .exitmacro
    .endif

    ; address mode

    .ifblank __osize__
        .fatal "Must specifcy Constant Ouput Size in bytes"
    .endif

    .if _msize_ > __osize__ .and WARNINGS_MATH_CMULT_OOB
        .warning "Constant Multiplication : Multiplier out of bounds"
        .endif


    .repeat _lssb_, iter
        .repeat _msize_, _iter
            asl _temp_ + _iter
            .endrepeat
        .endrepeat

    .if .not (__multiplier__ - 1) & __multiplier__
        .exitmacro
        .endif
    
    ldx #$00
    .repeat __osize__, iter
        lda __output__, iter
        stx __output__, iter
        sta _temp_, iter
        .endrepeat

    clc
    .repeat _mssb_ - _lssb_, iter
        .repeat _msize_, _iter
            asl _temp_ + iter
            .endrepeat
        .if __multiplier__ >> (iter + _lssb_)
            .repeat __osize__, _iter
                lda __output__ + iter
                adc _temp_     + iter
                sta __output__ + iter
                .endrepeat
            .endif
        .endrepeat
    .endmacro