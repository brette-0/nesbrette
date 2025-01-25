.macro LSSByte __target__, __indexreg__, __returnreg__, __offset__
    .local targettype, targetlabel, targetsize, indexreg, returnreg

    targettype .set 0
    detype __target__, targettype

    .ifnblank __offset__
        .if !(is_null __offset__)
            ldx #00
        .endif
    .endif

    .ifblank __indexreg__
        indexreg = xr
    .elseif .xmatch(__index__, y)
        indexreg = yr
    .elseif .xmatch(__index__, x)
        indexreg = xr
    .else
        .fatal "Invalid indexing register specified"
    .endif

    .ifblank __returnreg__
        returnreg = ar
    .elseif .xmatch(__index__, y)
        returnreg = yr
    .elseif .xmatch(__index__, x)
        returnreg = xr
    .elseif .xmatch(__index__, a)
        returnreg = ar
    .else
        .fatal "Invalid indexing register specified"
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