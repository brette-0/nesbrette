; Acc mode (untested) | Addr Mode (untested)



; constant multiply
; depends on lshift (acc) | MSSB(sym) | LSSB(sym)

.macro cmult __multiplier__, __output__, __osize__, __temp__
    .local _temp_, _mode_

    .enum 
        acc  = 0
        addr = 1
    .endenum

    .ifblank __multiplier__
        .fatal "Constant Multiplier must have Multiplier operand"
    .endif

    _mode_ = .ifnblank(__output__)          ; bool --> int --> enum

    .if _mode_ = addr
        .ifblank __osize__
            .fatal "Requires output size to complete cmult action"
            .endif
        .endif
    .else
        __output__ = null
        __osize__  = null
    .endif

    ; both modes require a temporary ram address
    .ifndef __temp__                                ; use ifndef not ifnblank because __temp__ is no longer a 'true' parameter, but can be defined immediately as result of param2
        .ifdef CONSTANTS_MATH_CMULT_TEMP
            _temp_ = CONSTANTS_MATH_CMULT_TEMP
        .else
            .fatal "Constant Multiply demands temporary address, either use CONSTANTS_MATH_CMULT_TEMP or pass a constant as a macro parameter"
        .endif
    .else
        _temp_ = __temp__
    .endif

    .if !__multiplier__
        .if WARNINGS_MATH_CMULT_MULTZERO .and _mode_ = acc
            .warning "Constant Multiply Against Zero invalidates previous Accumolator Load"
        .endif
        lda #$00
        
        .repeat null_coalesce(__osize__, 0), iter
            sta __output__ + iter
            .endrepeat
        .exitmacro
        .endif

    .if .not ispo2(__multiplier__)                                          ; if not power of 2
        clc
        sta _temp_

        .if _mode_ == addr                                                    ; clear higher bytes of temp, that the multiplier doesn't overwrite
            lda #$00
            .repeat iter, __osize__ + 1 - ((MSSB __multiplier__) >> 3)
                sta _temp_ + iter + 1
                .endrepeat
            .repeat iter, (MSSB __multiplier__) >> 3
                lda #((MSSB __multiplier__) >> (3 * iter)) & $ff                           ; scale int as bytes
                sta _temp_ + iter                                           ; store little endian
                .endrepeat
            .endif

        
        
        .repeat (MSSB __multiplier__) - (LSSB __multiplier__), iter                                       ; repeat by 'detailed range'
            .if _mode_ = addr
                .repeat iter, __osize__
                    asl _temp_ + iter
                    .endrepeat
            .else
                asl _temp_                                                  ; adjust temporary multiplier
                .endif
            
            .if (__multiplier__ >> (iter + (LSSB __multiplier__) + 1)) & 1                 ; check definition of bit of multiplier
                .if mode = addr
                    add __osize__ __output__ _temp_                         ; add temp to to output
                .else
                    adc _temp_
                .endif    
            .endif
            .endrepeat
        .endif

    lshift (LSSB __multiplier__), __output__, __osize__                     ; adjust for known multiplicant of two power (may pass null)
    .undefine acc, addr                                                     ; remove enum definitions
    .endmacro