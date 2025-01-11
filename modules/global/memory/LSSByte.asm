.macro LSSByte __address__, __length__, __offset__
    .if is_null(__offset__)
    .else
        ldx #00
    .endif
    
    .if __length__ > 21
        .fatal "LSSByte cannot index array longer than 21 bytes"
        .endif

    lda __address__ + iter
    beq @exit
    .repeat __length__ - 2, iter
        .if iter
            inx
            lda __address__ + iter
            beq @exit
        .endif
        .endrepeat
    @exit:
    .endmacro