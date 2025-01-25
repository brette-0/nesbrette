.macro MSSByte __target__, __indexreg__, __returnreg__, __offset__
    .local targettype, targetlabel, targetsize, indexreg, returnreg
    
    targettype .set 0
    detype __target__, targettype

    targetlabel = ilabel  __target__
    targetsize  = typeval targettype

    indexreg  .set 0
    returnreg .set 0

    .ifblank __indexreg__
        indexreg .set xr
    .else
        setireg __indexreg__, indexreg
    .endif

    .ifblank __returnreg__
        returnreg .set ar
    .else
        setreg __returnreg__, returnreg
    .endif

    .ifndef __offset__
        ldx #targetsize
    .elseif !(is_null __offset__)
        ldx #21
    .endif
    
    .if targetsize > 21
        .fatal "MSSByte cannot index array longer than 21 bytes"
    .endif

    .if targetsize < 1
        .fatal "MSSByte cannot index array shorter than 1 byte"
    .endif

    .repeat targetsize, iter
        lda eindex targetlabel, targetsize, iter, !(endian targettype)
        beq @exit
        der indexreg
    .endrepeat

    @exit:
    .endmacro