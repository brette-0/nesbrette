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
; tyx/txy is documented as i6502 (NOT CA65 MACPACK OR STACK METHOD)
.macro tyr __target__
    .ifndef IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr && (.ifdef IDTABLE)
        tyx
    .elseif __target__ = ar
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; teseted and working
.macro txr __target__
    .ifndef IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        txa
    .elseif __target__ = yr
        txy
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

; teseted and working
.macro trx __target__
    .ifndef IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        tax
    .elseif __target__ = yr
        tyx
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; teseted and working
.macro try __target__

    .ifndef IDTABLE
        .fatal "This method depends on an Identity Table"
    .endif

    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txy
    .elseif __target__ = ar
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro ldr __typed__, __value__, __cpre$__

    _ldr_reg    .set null
    _ldr_mode   .set null

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

    _ldr_reg    .set  .left(1, __typed__)
    _ldr_mode   .set .right(1, __typed__)

    ; parameter 'hotswap' for mode:reg
    .if _ldr_reg < ar
        .if _ldr_mode < ar
            .fatal .sprintf("ConstantParameterValueException: neither l:%d or r:%d is large enough to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _ldr_temp .set _ldr_mode
        _ldr_mode .set _ldr_reg
        _ldr_reg  .set _ldr_temp
    .elseif _ldr_mode > inabs
        .if _reg > yr
            .fatal .sprintf("ConstantParameterValueException: both l:%d amd r:%d is too large to be either a register or a memory address mode.", _reg, _mode)
        .endif
        _ldr_temp .set _ldr_mode
        _ldr_mode .set _ldr_reg
        _ldr_reg  .set _ldr_temp
    .endif

    .if (_ldr_mode = inabs) || (_ldr_mode = imp)
        .fatal "InvalidMemoryAddressModeException : ldr cannot load by indirect unindexed or with implied operand"
    .endif

    .if ((_ldr_mode = zp) || (_ldr_mode = zpx) || (_ldr_mode = zpy) || (_ldr_mode = inabsy) || (_ldr_mode = inabsx) || (_ldr_mode = imm)) && (__value__ > $ff)
        report cpre, "ConstantParameterRangeException: The provided value will cannot fit entirely within the operand length of the requested memory address mode."
    .endif

    .if     _ldr_reg = ar
        .if     _ldr_mode = inabsy
            lda [__value__], y
        .elseif _ldr_mode = inabsx
            lda [__value__, x]
        .elseif _ldr_mode = abst
            lda (_mode | $800)
        .elseif _ldr_mode = absy
            lda (_mode | $800), y
        .elseif _ldr_mode = absx
            lda (_mode | $800), x
        .elseif _ldr_mode = imm
            lda #__value__
        .elseif (_ldr_mode = zp) || (_ldr_mode = wabs)
            lda __value__
        .elseif (_ldr_mode = zpx) || (_ldr_mode = wabsx)
            lda __value__, x
        .elseif (_ldr_mode = zpy) || (_ldr_mode = wabsy)
            lda __value__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif

    .elseif _ldr_reg = xr
        .if (_ldr_mode = zpx) || (_ldr_mode = wabsx) || (_ldr_mode = absx) || (_ldr_mode = inabsy) || (_ldr_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : ldr(x) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _ldr_mode = abst
            ldx (_mode || $800)
        .elseif _ldr_mode = absy
            ldx (_ldr_mode || $800), y
        .elseif _ldr_mode = imm
            ldx #__value__
        .elseif (_ldr_mode = zp) || (_ldr_mode = wabs)
            ldx __value__
        .elseif (_ldr_mode = zpy) || (_ldr_mode = wabsy)
            ldx __value__, y
        .else
            .fatal "InvalidMemoryAddressModeException: Could not recognize the provided memory address mode."
        .endif
    
    .elseif _ldr_reg = yr

                .if (_ldr_mode = zpx) || (_ldr_mode = wabsx) || (_ldr_mode = absx) || (_ldr_mode = inabsy) || (_ldr_mode = inabsx)
            .fatal "InvalidMemoryAddressModeException : ldr(y) cannot load by indirect unindexed or with implied operand"
        .endif

        .if     _ldr_mode = abst
            ldy (_mode || $800)
        .elseif _ldr_mode = absy
            ldy (_mode || $800), x
        .elseif _ldr_mode = imm
            ldy #__value__
        .elseif (_ldr_mode = zp) || (_ldr_mode = wabs)
            ldy __value__
        .elseif (_ldr_mode = zpx) || (_ldr_mode = wabsx)
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

.macro cpr __typed_reg__, __address__
    .local mode, treg
    detype __typed_reg__, mode

    .if mode = imp || mode = inabs
        .fatal "Invalid Memory Address Mode for Compare A/X/Y"
    .endif

    .if !INCLUDES_NESBRETTE_SYNTH_IDTABLE && !( isconst treg ) && !(isconst ( ilabel __typed_reg__ ))
        .fatal "Identity table must be included in order to perform this action."
    .endif

    treg = .right(1, __typed_reg__)
    .if treg = ar
        .if (mode = imm || mode = zp || mode = zpx || mode = zpy) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cmp #__value__
            .exitmacro
        .elseif mode = abst
            cmp __value__ | $800
        .elseif mode = absy
            cmp __value__ | $800, y
        .elseif mode = absx
            cmp __value__ | $800, x
        .elseif mode = zp || mode = wabs
            cmp __value__
        .elseif mode = zpy || mode = wabsy
            cmp __value__, y
        .elseif mode = zpx || mode = wabsx
            cmp __value__, x
        .elseif mode = inabsy
            cmp [__value__], y
        .elseif mode = inabsx
            cmp [__value__, x]
        .endif
    .elseif treg = yr
        .if mode = zpy || mode = wabsy || mode = wabsx || mode = absx || mode = zpx || mode = absy || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Compare Y"
        .endif

        .if (mode = imm || mode = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cpy #__value__
            .exitmacro
        .elseif mode = abst
            cpy __value__ | $800
        .elseif mode = zp || mode = wabs
            cpy __value__
        .endif
    .elseif treg = xr
        .if mode = zpx || mode = wabsx || mode = wabsy || mode = absy || mode = zpy || mode = absx || mode = inabsy || mode = inabsx
            .fatal "Invalid Memory Address Mode for Compare X"
        .endif

        .if (mode = imm || mode = zp) && __target__ > $ff
            .fatal "Invalid Operand Size"
        .endif

        .if mode = imm
            cpx #__value__
            .exitmacro
        .elseif mode = abst
            cpx __value__ | $800
        .elseif mode = zp || mode = wabs
            cpx __value__
        .endif
    .else
        .fatal "Invalid Register Specified"
    .endif

.endmacro