.macro adr __reg__
    _opr_reg = setireg __reg__

    .if is_null _opr_reg
        .fatal "InvalidGeneralPurposeRegister: Must use an indexing register!"
    .endif

    adc IDTABLE, _reg
.endmacro

.macro sbr __reg__
    _opr_reg = setireg __reg__

    .if is_null _opr_reg
        .fatal "InvalidGeneralPurposeRegister: Must use an indexing register!"
    .endif

    sbc IDTABLE, _reg
.endmacro

.macro cpr __reg_reg__
    _opr_sreg .set .left(1, __reg_reg__)
    _opr_sreg .set setreg _opr_sreg
    _opr_treg .set .right(1, __reg_reg__)
    _opr_treg .set setireg _opr_treg
    
    .if is_null _opr_sreg
        .fatal "InvalidGeneralPurposeRegister: Must use a valid register!"
    .endif

    .if is_null _opr_treg
        .fatal "InvalidGeneralPurposeRegister: Must use a valid indexing register!"
    .endif

    .if _opr_treg = _opr_sreg
        .fatal "IntereferingRegisterUseException: Both Sides of Compare cannot be the same!"
    .endif

    .if _opr_sreg = ar
        .if _opr_treg = yr
            cmp IDTABLE, y
        .else
            cmp IDTABLE, x
        .endif
    .elseif _opr_sreg = xr
        cpx IDTABLE, y
    .elseif _opr_sreg = yr
        cpy IDTABLE, x
    .endif
.endmacro

.macro anr __reg__
    _opr_reg = setireg __reg__

    .if is_null _opr_reg
        .fatal "InvalidGeneralPurposeRegister: Must use an indexing register!"
    .endif

    and IDTABLE, _reg
.endmacro

.macro orr __reg__
    _opr_reg = setireg __reg__

    .if is_null _opr_reg
        .fatal "InvalidGeneralPurposeRegister: Must use an indexing register!"
    .endif

    ora IDTABLE, _reg
.endmacro

.macro xor __reg__
    _opr_reg = setireg __reg__

    .if is_null _opr_reg
        .fatal "InvalidGeneralPurposeRegister: Must use an indexing register!"
    .endif

    eor IDTABLE, _reg
.endmacro

.macro adx__reg__
    adr xr
.endmacro

.macro sbx __reg__
    sbr xr
.endmacro

.macro anx __reg__
    anr xr
.endmacro

.macro orx __reg__
    orr xr
.endmacro

.macro eox __reg__
    xor xr
.endmacro

.macro ady __reg__
    adr yr
.endmacro

.macro sby __reg__
    sbr yr
.endmacro

.macro any __reg__
    anr yr
.endmacro

.macro ory __reg__
    orr yr
.endmacro

.macro eoy __reg__
    xor yr
.endmacro

.macro biti __const__
    bit IDTABLE + __const__
.endif

.macro sev __nf$__
    biti $40 + ($80 * .ifnblank(__nf$__))
.endif

.macro laxi __const__
    lax IDTABLE + __const__
.endmacro

.macro tyxa
    lax IDTABLE, y
.endmacro

.macro cmpy
    cmp IDTABLE, y
.endmacro

.macro cmpx
    cmp IDTABLE, x
.endmacro

.macro cmpr __reg__
    _cmpr_reg = setireg __reg__

    .if is_null __reg__
        .fatal
    .endif

    .if _cmpr_reg = xr
        cmp IDTABLE, x 
    .else
        cmp IDTABLE, y
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

.macro trr
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