; Acc mode (working) | Addr Mode (unimplemented)

; constant multiply


.ifndef lshift
    .fatal "Error : Missing Dependancy 'lshift'. Ensure that you have enabled INCLUDES_NESBRETTE_LOGIC_LSHIFT"
.endif

.macro cmult __multiplier__, __temp__;, __output__, __osize__
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
            .warning "Constant Multiply Against Zero invalidates previous Accumolator Load"
        .endif
        lda #$00
        .exitmacro
        .endif

    .repeat 8, iter
        .ifndef _lssb_
            .if (__multiplier__ >> iter) & 1
                _lssb_ = iter
                .endif
            .endif
        .endrepeat
    
    .repeat 8, iter
        .ifndef _mssb_
            .if (__multiplier__ >> (7 - iter)) & 1
                _mssb_ = 7 - iter
                .endif
            .endif
        .endrepeat

    .if (_lssb_ <> _mssb_)                                  ; if not power of 2
        clc
        sta _temp_
        .repeat _mssb_ - _lssb_, iter                       ; repeat by 'detailed range'
            asl _temp_                                      ; adjust temporary multiplier
            .if (__multiplier__ >> (iter + _lssb_ + 1)) & 1 ; check definition of bit of multiplier
                adc _temp_
                .endif
            .endrepeat
        .endif

    lshift _lssb_                                           ; adjust for known multiplicant of two power
    .endmacro