; untested

.macro __lshift__acc, __amt__, __sol__
    ; sol -> shift overflow level 

    .if (__amt__) > 7
        report __sol__, .sprintf("Shifting by %d will result in consistent zero", __amt__) 
        ldz
    .elseif (__amt__) > 5
        .repeat (9 - __amt__), _
            ror
        .endrepeat
        and #~((1 << (__amt__)) - 1)
    .else
        .repeat __amt__, _
            asl
        .endrepeat
    .endif
.endmacro

;.macro __rshift__acc
;.endmacro

.macro __lshift__mem
    ; mem mode

    t_out .set 0
    detype __param0__, t_out

    w_out = typeval t_out
    _amt = __param1__
    l_out = ilabel __param0__

    .if _amt >= (w_out * 8)
        ; warn too large
        .endif

    ; byte shift (moving bytes)
    .repeat w_out - (_amt >> 3), iter
        ldr _reg: _reg, (eindex l_out, w_out, iter, endian t_out)
        str _reg: wabs, (eindex l_out, w_out, (iter + (_amt >> 3)), endian t_out)
        .endrepeat

    ; cleaning tail
    ldz _reg
    .repeat (__amt__ >> 3), iter
        str _reg: wabs, (l_out + width - (_amt >> 3) + iter)
        .endrepeat

    ; shifting all remaining bytes by "fine detail"
    .if _amt & %111
        clc
        .repeat (_amt & %111), _
            .repeat w_out - (_amt >> 3), iter
                rol l_out + w_out - (_amt >> 3) -  iter
                .endrepeat
            .endrepeat
        .endif 
.endmacro

.macro __rshift__mem
.endmacro

.macro lshift __param0__, __param1__, __reg__, __sol__
    ; mode (mem)
    ; __param0__ type: addr (target)
    ; __param1__ int        (amount)
    ; __reg__?   gpr: gpr   (registers)
    ; __sol__?   int        local shift overflow warning level override

    ; mode (acc)
    ; __param0__ int        (amount)
    ; __param1__?null|blank (void)
    ; __reg__?   null|blank (void)
    ; __sol__?   int        local shift overflow warning level override
    

    ; sol -> shift overflow level
    .local t_out, w_out, l_out, _reg, _amt

    .ifblank __sol__
        __sol__ = null
    .endif

    sol = null_coalesce __sol__, shift_overflow

    .ifblank __param1__
        __lshift__acc __param0__
        .exitmacro
    .elseif is_null __param1__
        __lshift__acc __param0__, __sol__
        .exitmacro
    .endif

    ; mem specific 
    .ifndef __reg__
        _reg = ar
    .else
        _reg = setreg __reg__
    .endif

    __lshift__mem l_out, w_out, __param1__, _reg, s_out, e_out, sol
.endmacro

; untested

;.macro rshift  __param0__, __param1__, __reg__
;    .local t_out, w_out, l_out, _reg, _amt
;   
;
;   .if .paramcount = 1
;        _amt = __param0__
;
;        .if (_amt) > 7
;            .if WARNING_LOGIC_SHIFT_OVERFLOW
;                .warning "Amount to shift by will always result in zero"
;            .endif
;            ldz
;        .elseif (_amt) > 5
;            .repeat (9 - _amt), _
;                rol
;                .endrepeat
;            and #(1 << (8 - _amt)) - 1
;        .else
;            .repeat _amt, _
;                lsr
;                .endrepeat
;        .endif
;    .else
;        t_out .set 0
;        detype __param0__, t_out
;
;        w_out = typeval t_out
;        _amt = __param1__
;        l_out = ilabel __param0__
;
;        .ifndef __reg__
;            _reg = ar
;        .else
;            _reg = setreg __reg__
;        .endif
;
;
;        .if _amt >= (__width__ * 8)
;            ; warn too large
;            .endif
;
;        ; byte shift (moving bytes)
;        .repeat __width__ - (_amt >> 3), iter
;            ldr wabs: _reg, (eindex w_out: l_out, (iter - (_amt >> 3)))
;            str wabs: _reg, (eindex w_out: l_out, iter)
;            .endrepeat
;
;        ; cleaning trail
;        ldz
;        .repeat (_amt >> 3), iter
;            sta eindex w_out: l_out, iter
;            .endrepeat
;
;        ; shifting all remaining bytes by "fine detail"
;        .if _amt & %111
;            clc
;            .repeat (_amt & %111), _
;                .repeat w_out - (_amt >> 3), iter
;                    ror l_out + (_amt >> 3) +  iter
;                    .endrepeat
;                .endrepeat
;            .endif
;    .endif
;.endmacro