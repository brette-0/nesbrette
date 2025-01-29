.macro __eval__body __t_target__, __w_target__, __l_target__, __reg__, __flagmask__
    ; expects all parameters to be validated

    pha ; cpu stat          ::+2
    pha ; saved a           ::+1
    pha ; saved __reg__     ::+0


    .if __flagmask__ & (abs zf)
        .repeat __w_target__, iter
            ldr wabs: __reg__, (eindex __w_target__: __l_target__, iter)
            bne @fail
        .endrepeat


    ora #(abs zf)
    .endif

    .if __flagmask__ & (abs vf)
        succeed_nf_target = @fail1_a
    .else
        succeed_nf_target = @fail2
    .endif

    .if __flagmask__ & (abs nf) || __flagmask__ & (abs vf)
        @fail:
            ldr wabs: __reg__, (eindex __w_target__: __l_target__, 0)
            bpl succeed_nf_target
            ora #(abs nf)

        @fail1_a:
            asl
            bpl @fail2
            ora #(abs vf)
    .endif

    @fail2:
        sts 2
        pla ; dump old __reg__
        tar __ireg__
        pla ; dump a
        plp ; new cpu stat
    .endmacro

.macro eval __target__, __ireg__
    .local t_target, w_target, l_target

    t_target .set 0
    detype __target__, t_target

    w_target = typeval targettype
    l_target  = ilabel __target__

    _ireg = setireg __ireg__

    .ifblank __flags__
        __flags__ = (abs (zf + nf + vf))
    .endif

    __eval__body t_target, w_target, l_target, _reg, __flags__
.endmacro