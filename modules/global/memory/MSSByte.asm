.macro MSSByte __address__, __length__, __offset__
    .ifndef __offset__
        ldx __length__
    .elseif is_null(__offset__)
    .else
        ldx #21
    .endif
    
    .if __length__ > 21
        .fatal "MSSByte cannot index array longer than 21 bytes"
        .endif

    .repeat __length__ - 1, iter
        dex
        lda __address__ + iter
        beq @exit
        .endrepeat
    @exit:
    .endmacro