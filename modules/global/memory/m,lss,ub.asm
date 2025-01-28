.define mssb(__constint__) \
    ((__constint__ & %10000000000000000000000000000000 > %01111111111111111111111111111111) * %10000000000000000000000000000000) | \
    ((__constint__ & %01000000000000000000000000000000 > %10111111111111111111111111111111) * %01000000000000000000000000000000) | \
    ((__constint__ & %00100000000000000000000000000000 > %11011111111111111111111111111111) * %00100000000000000000000000000000) | \
    ((__constint__ & %00010000000000000000000000000000 > %11101111111111111111111111111111) * %00010000000000000000000000000000) | \
    ((__constint__ & %00001000000000000000000000000000 > %11110111111111111111111111111111) * %00001000000000000000000000000000) | \
    ((__constint__ & %00000100000000000000000000000000 > %11111011111111111111111111111111) * %00000100000000000000000000000000) | \
    ((__constint__ & %00000010000000000000000000000000 > %11111101111111111111111111111111) * %00000010000000000000000000000000) | \
    ((__constint__ & %00000001000000000000000000000000 > %11111110111111111111111111111111) * %00000001000000000000000000000000) | \
    ((__constint__ & %00000000100000000000000000000000 > %11111111011111111111111111111111) * %00000000100000000000000000000000) | \
    ((__constint__ & %00000000010000000000000000000000 > %11111111101111111111111111111111) * %00000000010000000000000000000000) | \
    ((__constint__ & %00000000001000000000000000000000 > %11111111110111111111111111111111) * %00000000001000000000000000000000) | \
    ((__constint__ & %00000000000100000000000000000000 > %11111111111011111111111111111111) * %00000000000100000000000000000000) | \
    ((__constint__ & %00000000000010000000000000000000 > %11111111111101111111111111111111) * %00000000000010000000000000000000) | \
    ((__constint__ & %00000000000001000000000000000000 > %11111111111110111111111111111111) * %00000000000001000000000000000000) | \
    ((__constint__ & %00000000000000100000000000000000 > %11111111111111011111111111111111) * %00000000000000100000000000000000) | \
    ((__constint__ & %00000000000000010000000000000000 > %11111111111111101111111111111111) * %00000000000000010000000000000000) | \
    ((__constint__ & %00000000000000001000000000000000 > %11111111111111110111111111111111) * %00000000000000001000000000000000) | \
    ((__constint__ & %00000000000000000100000000000000 > %11111111111111111011111111111111) * %00000000000000000100000000000000) | \
    ((__constint__ & %00000000000000000010000000000000 > %11111111111111111101111111111111) * %00000000000000000010000000000000) | \
    ((__constint__ & %00000000000000000001000000000000 > %11111111111111111110111111111111) * %00000000000000000001000000000000) | \
    ((__constint__ & %00000000000000000000100000000000 > %11111111111111111111011111111111) * %00000000000000000000100000000000) | \
    ((__constint__ & %00000000000000000000010000000000 > %11111111111111111111101111111111) * %00000000000000000000010000000000) | \
    ((__constint__ & %00000000000000000000001000000000 > %11111111111111111111110111111111) * %00000000000000000000001000000000) | \
    ((__constint__ & %00000000000000000000000100000000 > %11111111111111111111111011111111) * %00000000000000000000000100000000) | \
    ((__constint__ & %00000000000000000000000010000000 > %11111111111111111111111101111111) * %00000000000000000000000010000000) | \
    ((__constint__ & %00000000000000000000000001000000 > %11111111111111111111111110111111) * %00000000000000000000000001000000) | \
    ((__constint__ & %00000000000000000000000000100000 > %11111111111111111111111111011111) * %00000000000000000000000000100000) | \
    ((__constint__ & %00000000000000000000000000010000 > %11111111111111111111111111101111) * %00000000000000000000000000010000) | \
    ((__constint__ & %00000000000000000000000000001000 > %11111111111111111111111111110111) * %00000000000000000000000000001000) | \
    ((__constint__ & %00000000000000000000000000000100 > %11111111111111111111111111111011) * %00000000000000000000000000000100) | \
    ((__constint__ & %00000000000000000000000000000010 > %11111111111111111111111111111101) * %00000000000000000000000000000010) | \
    ((__constint__ & %00000000000000000000000000000001 > %11111111111111111111111111111110) * %00000000000000000000000000000001)
    
; lssb, msub, lsub

.macro MSSB __register__    ; LSSB, MSUB, LSUB (Typed)
    .ifblank __regiter__
        __register__ = x
        .endif
    
    .if __register__ = y
        ldy #$ff
        @loop:
            iny
            lsr
            bne @loop
        tya
    .elseif __register__ = x
        ldx #$ff
        @loop:
            inx
            lsr
            bne @loop
        txa
    .else
        .fatal "Invalid regsiter for MSSB"
    .endif

    adc #$00
    .endmacro


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

.macro LSSB __register__
    .ifblank __regiter__
        __register__ = x
        .endif
    
    .if __register__ = y
        ldy #$09
        @loop:
            dey
            asl
            bcc @loop
        tya
    .elseif __register__ = x
        ldx #$09
        @loop:
            dey
            asl
            bcc @loop
        txa
    .else
        .fatal "Invalid regsiter for MSSB"
    .endif
    .endmacro

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