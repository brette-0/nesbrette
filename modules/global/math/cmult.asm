; untested

; constant multiply

.macro cmult __multiplier__, __temp__, __output__, __osize__
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

    .repeat iter, 4 ; ca65 preprocessor nums are 32bit
        .if .not (__multiplier__ >> (iter * 8))
            _msize_ = iter
        .endif
        .endrepeat

    .if __multiplier__ == 0
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

    ; most and least significant set bit macros, works for both accumulator and address mode
    .repeat iter, 8 * _msize_
        .if __multiplier__ >> (((8 * _msize_) - 1) - iter)
            _mssb_ = (((8 * _msize_) - 1) - iter)
        .endif
        .endrepeat

    .repeat iter, 8 * _msize_
        .if __multiplier__ & (1 << iter)
            _lssb_ = iter
        .endif
        .endrepeat

    .ifblank __output__ ; accumulator mode      
        .if _msize_ > 1 .and WARNINGS_MATH_CMULT_OOB
            .warning "Constant Multiplication : Multiplier out of bounds"
        .endif

        .repeat iter, _lssb_
                asl
            .endrepeat

        .if .not (__multiplier__ - 1) & __multiplier__
            .exitmacro
        .endif
        
        sta _temp_
        clc
        .repeat iter, _mssb_ - _lssb_
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


    .repeat iter, _lssb_
        .repeat _iter, _msize_
            asl _temp_ + _iter
            .endrepeat
        .endrepeat

    .if .not (__multiplier__ - 1) & __multiplier__
        .exitmacro
        .endif
    
    ldx #$00
    .repeat iter, __osize__
        lda __output__, iter
        stx __output__, iter
        sta _temp_, iter
        .endrepeat

    clc
    .repeat iter, _mssb_ - _lssb_
        .repeat _iter, _msize_
            asl _temp_ + iter
            .endrepeat
        .if __multiplier__ >> (iter + _lssb_)
            .repeat _iter, __osize__
                lda __output__ + iter
                adc _temp_     + iter
                sta __output__ + iter
                .endrepeat
            .endif
        .endrepeat
    .endmacro