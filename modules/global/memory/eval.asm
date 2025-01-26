.macro eval __target__, __reg__
    .local targettype, targetsize, tlabel

    targettype .set 0
    detype __target__, targettype

    targetsize  = typeval targettype
    tlabel      = ilabel __target__

    pha ; cpu stat          ::+2
    pha ; saved a           ::+1
    pha ; saved __reg__     ::+0

    lda #$00

    ; get z
    .repeat targetsize, iter
        ldr wabs:: __reg__, (eindex tlabel, targetsize, iter, endian targettype)
        bne @fail
    .endrepeat

    ora #$02
    @fail:

    ldr wabs:: __reg__, (eindex tlabel, targetsize, 0, endian targettype)
    bpl @fail2
    ora #$80
    
    @fail2:

    sts 2
    pla ; dump old __reg__
    tar __reg__
    pla ; dump a
    plp ; new cpu stat
.endmacro