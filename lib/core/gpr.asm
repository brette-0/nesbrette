; teseted and working
.macro inr __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        inx
    .elseif __target__ = yr
        iny
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; teseted and working
.macro der __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        dex
    .elseif __target__ = yr
        dey
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; teseted and working
.macro tar __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        tax
    .elseif __target__ = yr
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; teseted and working
.macro tra __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txa
    .elseif __target__ = yr
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro ldr __typed__, __value__, __cpre$__
    .local _reg, _mode, _temp, cpre

    _reg    .set null
    _mode   .set null

    .if .paramcount < 2
        .fatal "ldr requires two operands : (__mode__ : __reg__) & __value__"
    .endif

    .ifblank __cpre$__
        .ifdef ConstantParameterRangeException
            deferror ConstantParameterRangeException, cpre
        .else
            deferror fatal, cpre
        .endif
    .else
        deferror __cpre$__, cpre
    .endif

    _reg    .set  .left(1, __typed__)
    _mode   .set .right(1, __typed__)

    ; parameter 'hotswap' for mode:reg
    .if _reg < ar
        .if _mode < ar
            .fatal .sprintf("ConstantParameterValueException: neither l:%d or r:%d is large enough to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _temp .set _mode
        _mode .set _reg
        _reg  .set _temp
    .elseif _mode > inabs
        .if _reg > yr
            .fatal .sprintf("ConstantParameterValueException: both l:%d amd r:%d is too large to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _temp .set _mode
        _mode .set _reg
        _reg  .set _temp
    .endif

    .if (_mode = inabs) || (_mode = imp)
        .fatal "InvalidMemoryAddressModeException : ldr cannot load by indirect unindexed or with implied operand"
    .endif

    .if ((_mode = zp) || (_mode = zpx) || (_mode = zpy) || (_mode = inabsy) || (_mode = inabsx) || (_mode = imm)) && (__value__ > $ff)
        report cpre, "ConstantParameterRangeException: The provided value will cannot fit entirely within the operand length of the requested memory address mode."
    .endif

    .if     _reg = ar
        .if     _mode = inabsy
            lda [__value__], y
        .elseif _mode = inabsx
            lda [__value__, x]
        .elseif _mode = abst
            lda (__value__ | $800)
        .elseif _mode = absy
            lda (__value__ | $800), y
        .elseif _mode = absx
            lda (__value__ | $800), x
        .elseif _mode = imm
            lda #__value__
        .elseif (_mode = zp) || (_mode = wabs)
            lda __value__
        .elseif (_mode = zpx) || (_mode = wabsx)
            lda __value__, x
        .elseif (_mode = zpy) || (_mode = wabsy)
            lda __value__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif

    .elseif _reg = xr
        .if (_mode = zpx) || (_mode = wabsx) || (_mode = absx) || (_mode = inabsy) || (_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : ldr(x) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _mode = abst
            ldx (__value__ || $800)
        .elseif _mode = absy
            ldx (__value__ || $800), y
        .elseif _mode = imm
            ldx #__value__
        .elseif (_mode = zp) || (_mode = wabs)
            ldx __value__
        .elseif (_mode = zpy) || (_mode = wabsy)
            ldx __value__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    
    .elseif _reg = yr

                .if (_mode = zpx) || (_mode = wabsx) || (_mode = absx) || (_mode = inabsy) || (_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : ldr(y) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _mode = abst
            ldy (__value__ || $800)
        .elseif _mode = absy
            ldy (__value__ || $800), x
        .elseif _mode = imm
            ldy #__value__
        .elseif (_mode = zp) || (_mode = wabs)
            ldy __value__
        .elseif (_mode = zpx) || (_mode = wabsx)
            ldy __value__, x
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    .else
        .fatal "InvalidGeneralPurposeRegister: ldr requires use of singular GPRs (a xOR x xor Y)"
    .endif
.endmacro

.macro str __typed__, __address__, __cpre$__, __iwle$__
    .if .paramcount < 2
        .fatal "str requires two operands : (__mode__ : __reg__) & __address__"
    .endif

    .ifblank __cpre$__
        .ifdef ConstantParameterRangeException
            deferror ConstantParameterRangeException, cpre
        .else
            deferror fatal, cpre
        .endif
    .else
        deferror __cpre$__, cpre
    .endif

    .ifblank __iwle$__
        .ifdef InvalidWriteLocationException
            deferror InvalidWriteLocationException, iwle
        .else
            deferror fatal, iwle
        .endif
    .else
        deferror __iwle$__, iwle
    .endif

    _str_reg    .set  .left(1, __typed__)
    _str_mode   .set .right(1, __typed__)

    ; parameter 'hotswap' for mode:reg
    .if _str_reg < ar
        .if _str_mode < ar
            .fatal .sprintf("ConstantParameterValueException: neither l:%d or r:%d is large enough to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _str_temp .set _str_mode
        _str_mode .set _str_reg
        _str_reg  .set _str_temp
    .elseif _str_mode > inabs
        .if _str_reg > yr
            .fatal .sprintf("ConstantParameterValueException: both parameters l:%d or r:%d are too large to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _str_temp .set _str_mode
        _str_mode .set _str_reg
        _str_reg  .set _str_temp
    .endif

    .if (_str_mode = inabs) || (_str_mode = imp) || (_str_mode = imm)
        .fatal "InvalidMemoryAddressModeException : str cannot load by indirect unindexed, immediate or with implied operand"
    .endif

    .if ((_str_mode = zp) || (_str_mode = zpx) || (_str_mode = zpy) || (_str_mode = inabsy) || (_str_mode = inabsx) || (_str_mode = imm)) && (__address__ > $ff)
        report cpre, "ConstantParameterRangeException: The provided value will cannot fit entirely within the operand length of the requested memory address mode."
    .endif

    .if     _str_reg = ar
        .if     _str_mode = inabsy
            sta [__address__], y
        .elseif _str_mode = inabsx
            sta [__address__, x]
        .elseif _str_mode = abst
            sta (__address__ | $800)
        .elseif _str_mode = absy
            sta (__address__ | $800), y
        .elseif _str_mode = absx
            sta (__address__ | $800), x
        .elseif (_str_mode = zp) || (_str_mode = wabs)
            sta __address__
        .elseif (_str_mode = zpx) || (_str_mode = wabsx)
            sta __address__, x
        .elseif (_str_mode = zpy) || (_str_mode = wabsy)
            sta __address__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif

    .elseif _str_reg = xr
        .if (_str_mode = zpx) || (_str_mode = wabsy) || (_str_mode = absy) || (_str_mode = wabsx) || (_str_mode = absx) || (_str_mode = inabsy) || (_str_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : str(x) cannot load by indexed wabs/abs or indirect"
        .endif

        .if     _str_mode = abst
            stx (__address__ | $800)
        .elseif (_str_mode = zp) || (_str_mode = wabs)
            stx __address__
        .elseif (_str_mode = zpy)
            stx __address__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    
    .elseif _str_reg = yr
        .if (_str_mode = zpx) || (_str_mode = wabsy) || (_str_mode = absy) || (_str_mode = wabsx) || (_str_mode = absx) || (_str_mode = inabsy) || (_str_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : str(y) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _str_mode = abst
            sty (_mode | $800)
        .elseif (_str_mode = zp) || (_str_mode = wabs)
            sty __address__
        .elseif (_str_mode = zpx)
            sty __address__, x
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    .else
        .fatal "InvalidGeneralPurposeRegister: str requires use of singular GPRs (a xOR x xor Y)"
    .endif

    prg8000 .set is_prgram8000 LIBCORE_MAPPER

    .if (iwle <> 0)  && (__address__ >= $8000) && (!prg8000)
        report iwle, "InvalidWriteLocationException: Target is read only memory!"
    .endif

.endmacro

.macro cpr __typed__, __value__, __cpre$__

    _cpr_reg    .set null
    _cpr_mode   .set null

    .if .paramcount < 2
        .fatal "cpr requires two operands : (__mode__ : __reg__) & __value__"
    .endif

    .ifblank __cpre$__
        .ifdef ConstantParameterRangeException
            deferror ConstantParameterRangeException, cpre
        .else
            deferror fatal, cpre
        .endif
    .else
        deferror __cpre$__, cpre
    .endif

    _cpr_reg    .set  .left(1, __typed__)
    _cpr_mode   .set .right(1, __typed__)

    ; parameter 'hotswap' for mode:reg
    .if _cpr_reg < ar
        .if _cpr_mode < ar
            .fatal .sprintf("ConstantParameterValueException: neither l:%d or r:%d is large enough to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _cpr_temp .set _cpr_mode
        _cpr_mode .set _cpr_reg
        _cpr_reg  .set _cpr_temp
    .elseif _cpr_mode > inabs
        .if _reg > yr
            .fatal .sprintf("ConstantParameterValueException: both l:%d amd r:%d is too large to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _cpr_temp .set _cpr_mode
        _cpr_mode .set _cpr_reg
        _cpr_reg  .set _cpr_temp
    .endif

    .if (_cpr_mode = inabs) || (_cpr_mode = imp)
        .fatal "InvalidMemoryAddressModeException : cpr cannot load by indirect unindexed or with implied operand"
    .endif

    .if ((_cpr_mode = zp) || (_cpr_mode = zpx) || (_cpr_mode = zpy) || (_cpr_mode = inabsy) || (_cpr_mode = inabsx) || (_cpr_mode = imm)) && (__value__ > $ff)
        report cpre, "ConstantParameterRangeException: The provided value will cannot fit entirely within the operand length of the requested memory address mode."
    .endif

    .if     _cpr_reg = ar
        .if     _cpr_mode = inabsy
            cmp [__value__], y
        .elseif _cpr_mode = inabsx
            cmp [__value__, x]
        .elseif _cpr_mode = abst
            cmp (_mode | $800)
        .elseif _cpr_mode = absy
            cmp (_mode | $800), y
        .elseif _cpr_mode = absx
            cmp (_mode | $800), x
        .elseif _cpr_mode = imm
            cmp #__value__
        .elseif (_cpr_mode = zp) || (_cpr_mode = wabs)
            cmp __value__
        .elseif (_cpr_mode = zpx) || (_cpr_mode = wabsx)
            cmp __value__, x
        .elseif (_cpr_mode = zpy) || (_cpr_mode = wabsy)
            cmp __value__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif

    .elseif _cpr_reg = xr
        .if (_cpr_mode = zpy) || (_cpr_mode = absy) || (_cpr_mode = wabsy) || (_cpr_mode = zpx) || (_cpr_mode = wabsx) || (_cpr_mode = absx) || (_cpr_mode = inabsy) || (_cpr_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : cpr(x) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _cpr_mode = abst
            cpx (_mode || $800)
        .elseif _cpr_mode = imm
            cpx #__value__
        .elseif (_cpr_mode = zp) || (_cpr_mode = wabs)
            cpx __value__
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    
    .elseif _cpr_reg = yr

                .if (_cpr_mode = zpx) || (_cpr_mode = absx) || (_cpr_mode = wabsx) || (_cpr_mode = zpy) || (_cpr_mode = wabsx) || (_cpr_mode = absx) || (_cpr_mode = inabsy) || (_cpr_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : cpr(y) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _cpr_mode = abst
            cpy (_mode || $800)
        .elseif _cpr_mode = imm
            cpy #__value__
        .elseif (_cpr_mode = zp) || (_cpr_mode = wabs)
            cpy __value__
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    .else
        .fatal "InvalidGeneralPurposeRegister: cpr requires use of singular GPRs (a xOR x xor Y)"
    .endif
.endmacro