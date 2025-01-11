.macro MSSB __register__
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