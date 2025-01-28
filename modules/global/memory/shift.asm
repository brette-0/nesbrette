; untested

.macro lshift __param0__, __param1__, __reg__
    .local t_out, w_out, l_out, _reg, _amt

    .if .paramcount = 1
        ; acc mode

        _amt = __param0__

        .if (__amt__) > 7
            .if WARNING_LOGIC_SHIFT_OVERFLOW
                .warning "Amount to shift by will always result in zero"
            .endif
            ldz
        .elseif (_amt) > 5
            .repeat (9 - _amt), _
                ror
            .endrepeat
            and #~((1 << (_amt)) - 1)
        .else
            .repeat _amt, _
                asl
            .endrepeat
        .endif


    .else
        ; mem mode

        t_out .set 0
        detype __param0__, t_out

        w_out = typeval t_out
        _amt = __param1__
        l_out = ilabel __param0__

        .ifndef __reg__
            _reg = ar
        .else
            _reg = setreg __reg__
        .endif

        .if _amt >= (w_out * 8)
            ; warn too large
            .endif

        ; byte shift (moving bytes)
        .repeat w_out - (_amt >> 3), iter
            ldr _reg: _reg, (eindex t_out: l_out, iter)
            str wabs: _reg, (eindex t_out: l_out, (iter + (_amt >> 3)))
            .endrepeat

        ; cleaning tail
        ldz _reg
        .repeat (__amt__ >> 3), iter
            str wabs: _reg, (l_out + width - (_amt >> 3) + iter)
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
    .endif
.endmacro

; untested

.macro rshift  __param0__, __param1__, __reg__
    .local t_out, w_out, l_out, _reg, _amt
   

   .if .paramcount = 1
        _amt = __param0__

        .if (_amt) > 7
            .if WARNING_LOGIC_SHIFT_OVERFLOW
                .warning "Amount to shift by will always result in zero"
            .endif
            ldz
        .elseif (_amt) > 5
            .repeat (9 - _amt), _
                rol
                .endrepeat
            and #(1 << (8 - _amt)) - 1
        .else
            .repeat _amt, _
                lsr
                .endrepeat
        .endif
    .else
        t_out .set 0
        detype __param0__, t_out

        w_out = typeval t_out
        _amt = __param1__
        l_out = ilabel __param0__

        .ifndef __reg__
            _reg = ar
        .else
            _reg = setreg __reg__
        .endif


        .if _amt >= (__width__ * 8)
            ; warn too large
            .endif

        ; byte shift (moving bytes)
        .repeat __width__ - (_amt >> 3), iter
            ldr wabs: _reg, (eindex w_out: l_out, (iter - (_amt >> 3)))
            str wabs: _reg, (eindex w_out: l_out, iter)
            .endrepeat

        ; cleaning trail
        ldz
        .repeat (_amt >> 3), iter
            sta eindex w_out: l_out, iter
            .endrepeat

        ; shifting all remaining bytes by "fine detail"
        .if _amt & %111
            clc
            .repeat (_amt & %111), _
                .repeat w_out - (_amt >> 3), iter
                    ror l_out + (_amt >> 3) +  iter
                    .endrepeat
                .endrepeat
            .endif
    .endif
.endmacro