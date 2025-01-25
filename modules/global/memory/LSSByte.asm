.macro LSSByte __target__, __indexreg__, __returnreg__, __offset__
    .local targettype, targetlabel, targetsize, indexreg, returnreg

    targettype .set 0
    detype __target__, targettype

    .ifnblank __offset__
        .if !(is_null __offset__)
            ldx #00
        .endif
    .endif

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
    
    targetlabel = ilabel  __target__
    targetsize  = typeval targettype

    .if targetsize > 21
        .fatal "LSSByte cannot index array longer than 21 bytes"
    .endif

    .if targetsize < 1
        .fatal "LSSByte cannot index array shorter than 1 byte"
    .endif

    .repeat targetsize, iter
        lda eindex targetlabel, targetsize, iter, endian targettype
        beq @exit
        inr indexreg
    .endrepeat

    @exit:
    .if returnreg <> indexreg
        trr indexreg, returnreg
    .endif
.endmacro