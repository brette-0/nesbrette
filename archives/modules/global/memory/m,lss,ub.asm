.define MSSB(__constint__) \
    ((__constint__ & %10000000000000000000000000000000 > %01111111111111111111111111111111) * 32) | \
    ((__constint__ & %01000000000000000000000000000000 > %10111111111111111111111111111111) * 31) | \
    ((__constint__ & %00100000000000000000000000000000 > %11011111111111111111111111111111) * 30) | \
    ((__constint__ & %00010000000000000000000000000000 > %11101111111111111111111111111111) * 29) | \
    ((__constint__ & %00001000000000000000000000000000 > %11110111111111111111111111111111) * 28) | \
    ((__constint__ & %00000100000000000000000000000000 > %11111011111111111111111111111111) * 27) | \
    ((__constint__ & %00000010000000000000000000000000 > %11111101111111111111111111111111) * 26) | \
    ((__constint__ & %00000001000000000000000000000000 > %11111110111111111111111111111111) * 25) | \
    ((__constint__ & %00000000100000000000000000000000 > %11111111011111111111111111111111) * 24) | \
    ((__constint__ & %00000000010000000000000000000000 > %11111111101111111111111111111111) * 23) | \
    ((__constint__ & %00000000001000000000000000000000 > %11111111110111111111111111111111) * 22) | \
    ((__constint__ & %00000000000100000000000000000000 > %11111111111011111111111111111111) * 21) | \
    ((__constint__ & %00000000000010000000000000000000 > %11111111111101111111111111111111) * 20) | \
    ((__constint__ & %00000000000001000000000000000000 > %11111111111110111111111111111111) * 19) | \
    ((__constint__ & %00000000000000100000000000000000 > %11111111111111011111111111111111) * 18) | \
    ((__constint__ & %00000000000000010000000000000000 > %11111111111111101111111111111111) * 17) | \
    ((__constint__ & %00000000000000001000000000000000 > %11111111111111110111111111111111) * 16) | \
    ((__constint__ & %00000000000000000100000000000000 > %11111111111111111011111111111111) * 15) | \
    ((__constint__ & %00000000000000000010000000000000 > %11111111111111111101111111111111) * 14) | \
    ((__constint__ & %00000000000000000001000000000000 > %11111111111111111110111111111111) * 13) | \
    ((__constint__ & %00000000000000000000100000000000 > %11111111111111111111011111111111) * 12) | \
    ((__constint__ & %00000000000000000000010000000000 > %11111111111111111111101111111111) * 11) | \
    ((__constint__ & %00000000000000000000001000000000 > %11111111111111111111110111111111) * 10) | \
    ((__constint__ & %00000000000000000000000100000000 > %11111111111111111111111011111111) * 9)  | \
    ((__constint__ & %00000000000000000000000010000000 > %11111111111111111111111101111111) * 8)  | \
    ((__constint__ & %00000000000000000000000001000000 > %11111111111111111111111110111111) * 7)  | \
    ((__constint__ & %00000000000000000000000000100000 > %11111111111111111111111111011111) * 6)  | \
    ((__constint__ & %00000000000000000000000000010000 > %11111111111111111111111111101111) * 5)  | \
    ((__constint__ & %00000000000000000000000000001000 > %11111111111111111111111111110111) * 4)  | \
    ((__constint__ & %00000000000000000000000000000100 > %11111111111111111111111111111011) * 3)  | \
    ((__constint__ & %00000000000000000000000000000010 > %11111111111111111111111111111101) * 2)  | \
    ((__constint__ & %00000000000000000000000000000001 > %11111111111111111111111111111110) * 1)
    
.define LSSB(__constint__) \
    33 - ( \
    ((__constint__ & %00000000000000000000000000000001 > %01111111111111111111111111111111) * 32) | \
    ((__constint__ & %00000000000000000000000000000010 > %10111111111111111111111111111111) * 31) | \
    ((__constint__ & %00100000000000000000000000000000 > %11011111111111111111111111111111) * 30) | \
    ((__constint__ & %00000000000000000000000000000100 > %11101111111111111111111111111111) * 29) | \
    ((__constint__ & %00000000000000000000000000010000 > %11110111111111111111111111111111) * 28) | \
    ((__constint__ & %00000000000000000000000000100000 > %11111011111111111111111111111111) * 27) | \
    ((__constint__ & %00000000000000000000000001000000 > %11111101111111111111111111111111) * 26) | \
    ((__constint__ & %00000000000000000000000010000000 > %11111110111111111111111111111111) * 25) | \
    ((__constint__ & %00000000000000000000000100000000 > %11111111011111111111111111111111) * 24) | \
    ((__constint__ & %00000000000000000000001000000000 > %11111111101111111111111111111111) * 23) | \
    ((__constint__ & %00000000000000000000010000000000 > %11111111110111111111111111111111) * 22) | \
    ((__constint__ & %00000000000000000000100000000000 > %11111111111011111111111111111111) * 21) | \
    ((__constint__ & %00000000000000000001000000000000 > %11111111111101111111111111111111) * 20) | \
    ((__constint__ & %00000000000000000010000000000000 > %11111111111110111111111111111111) * 19) | \
    ((__constint__ & %00000000000000000100000000000000 > %11111111111111011111111111111111) * 18) | \
    ((__constint__ & %00000000000000001000000000000000 > %11111111111111101111111111111111) * 17) | \
    ((__constint__ & %00000000000000010000000000000000 > %11111111111111110111111111111111) * 16) | \
    ((__constint__ & %00000000000000100000000000000000 > %11111111111111111011111111111111) * 15) | \
    ((__constint__ & %00000000000001000000000000000000 > %11111111111111111101111111111111) * 14) | \
    ((__constint__ & %00000000000010000000000000000000 > %11111111111111111110111111111111) * 13) | \
    ((__constint__ & %00000000000100000000000000000000 > %11111111111111111111011111111111) * 12) | \
    ((__constint__ & %00000000001000000000000000000000 > %11111111111111111111101111111111) * 11) | \
    ((__constint__ & %00000000010000000000000000000000 > %11111111111111111111110111111111) * 10) | \
    ((__constint__ & %00000000100000000000000000000000 > %11111111111111111111111011111111) * 9)  | \
    ((__constint__ & %00000001000000000000000000000000 > %11111111111111111111111101111111) * 8)  | \
    ((__constint__ & %00000010000000000000000000000000 > %11111111111111111111111110111111) * 7)  | \
    ((__constint__ & %00000100000000000000000000000000 > %11111111111111111111111111011111) * 6)  | \
    ((__constint__ & %00001000000000000000000000000000 > %11111111111111111111111111101111) * 5)  | \
    ((__constint__ & %00010000000000000000000000000000 > %11111111111111111111111111110111) * 4)  | \
    ((__constint__ & %00100000000000000000000000000000 > %11111111111111111111111111111011) * 3)  | \
    ((__constint__ & %01000000000000000000000000000000 > %11111111111111111111111111111101) * 2)  | \
    ((__constint__ & %10000000000000000000000000000000 > %11111111111111111111111111111110) * 1))
    
.define MSUB(__constint__) MSSB (__constint__ ^ $ffffffff)
.define LSUB(__constint__) LSSB (__constint__ ^ $ffffffff)

.macro mssbyte __target__, __regs__, __offset__
    .local targettype, targetlabel, targetsize, indexreg, returnreg
    
    targettype .set 0
    detype __target__, targettype

    targetlabel = ilabel  __target__
    targetsize  = typeval targettype

    indexreg  .set 0
    returnreg .set 0

    .ifblank __regs__
        indexreg  .set xr
        returnreg .set ar
    .else
        setireg __indexreg__, indexreg
    .endif

    .ifblank __offset__
        ldr xr: imm, targetsize
    .elseif !(is_null __offset__)
        ldr xr: imm, 21
    .endif
    
    .if targetsize > 21
        .fatal "mssbyte cannot index array longer than 21 bytes"
    .endif

    .if targetsize < 1
        .fatal "mssbyte cannot index array shorter than 1 byte"
    .endif

    .repeat targetsize, iter
        ldr _reg: wabs, (eindex t_target: l_target, iter)
        beq @exit
        der _ireg
    .endrepeat

    @exit:
    .if _reg <> _ireg
        trr _ireg, _reg
    .endif
.endmacro

.macro lssbyte __target__, __indexreg__, __returnreg__, __offset__
    .local t_target, l_target, w_target, indexreg, returnreg

    t_target .set 0
    detype __target__, t_target

    .ifnblank __offset__
        .if !(is_null __offset__)
            ldx #00
        .endif
    .endif

    .ifblank __regs__
        indexreg = xr
        returnreg = ar
    .else
        _ireg = setireg .right(1, __regs__)
        _reg  = setreg  .left(1, __regs__ )
    .endif

    l_target  = ilabel  __target__
    w_target  = typeval targettype

    .if w_target > 21
        .fatal "lssbyte cannot index array longer than 21 bytes"
    .endif

    .if w_target < 1
        .fatal "lssbyte cannot index array shorter than 1 byte"
    .endif

    .repeat w_target, iter
        ldr _reg: wabs, (eindex t_target: l_target, iter)
        beq @exit
        inr _ireg
    .endrepeat

    @exit:
    .if _reg <> _ireg
        trr _reg, _ireg
    .endif
.endmacro

.macro msubyte __target__, __regs__, __offset__
    .local targettype, targetlabel, targetsize, indexreg, returnreg
    
    targettype .set 0
    detype __target__, targettype

    targetlabel = ilabel  __target__
    targetsize  = typeval targettype

    indexreg  .set 0
    returnreg .set 0

    .ifblank __regs__
        indexreg  .set xr
        returnreg .set ar
    .else
        setireg __indexreg__, indexreg
    .endif

    .ifblank __offset__
        ldr xr: imm, targetsize
    .elseif !(is_null __offset__)
        ldr xr: imm, 21
    .endif
    
    .if targetsize > 21
        .fatal "mssbyte cannot index array longer than 21 bytes"
    .endif

    .if targetsize < 1
        .fatal "mssbyte cannot index array shorter than 1 byte"
    .endif

    .repeat targetsize, iter
        ldr _reg: wabs, (eindex t_target: l_target, iter)
        bne @exit
        der _ireg
    .endrepeat

    @exit:
    .if _reg <> _ireg
        trr _ireg, _reg
    .endif
.endmacro

.macro lsubyte __target__, __indexreg__, __returnreg__, __offset__
    .local t_target, l_target, w_target, indexreg, returnreg

    t_target .set 0
    detype __target__, t_target

    .ifnblank __offset__
        .if !(is_null __offset__)
            ldx #00
        .endif
    .endif

    .ifblank __regs__
        indexreg = xr
        returnreg = ar
    .else
        _ireg = setireg .right(1, __regs__)
        _reg  = setreg  .left(1, __regs__ )
    .endif

    l_target  = ilabel  __target__
    w_target  = typeval targettype

    .if w_target > 21
        .fatal "lssbyte cannot index array longer than 21 bytes"
    .endif

    .if w_target < 1
        .fatal "lssbyte cannot index array shorter than 1 byte"
    .endif

    .repeat w_target, iter
        ldr _reg: wabs, (eindex t_target: l_target, iter)
        bne @exit
        inr _ireg
    .endrepeat

    @exit:
    .if _reg <> _ireg
        trr _reg, _ireg
    .endif
.endmacro

.macro mssb __target__, __ireg__    ; LSSB, MSUB, LSUB (Typed)
    .local _reg, _ireg

    .ifblank __regs__
        _ireg = yr   ; since 'mssbyte' uses x
    .else
        _ireg = setreg __ireg__
    .endif

    .if .paramcount
        ; __mem__

        .if _ireg = yr
            mssbyte __target__, _reg: xr
        .else
            mssbyte __target__, _reg: yr
        .endif
    .endif

    ldr _ireg: imm, $ff
    @loop:
        inr _ireg
        lsr
        bne @loop
    tra _ireg

    adc #$00
.endmacro

.macro lssb __target__, __ireg__    ; LSSB, MSUB, LSUB (Typed)
    .local _reg, _ireg

    .ifblank __regs__
        _ireg = yr   ; since 'mssbyte' uses x
    .else
        _ireg = setreg __ireg__
    .endif

    .if .paramcount
        ; __mem__

        .if _ireg = yr
            lssbyte __target__, _reg: xr
        .else
            lssbyte __target__, _reg: yr
        .endif
    .endif

    ldr _ireg: imm, $09

    @loop:
        der _ireg
        asl
        bne @loop
    tra _ireg
.endmacro

.macro msub __target__, __ireg__    ; LSSB, MSUB, LSUB (Typed)
    .local _reg, _ireg

    .ifblank __regs__
        _ireg = yr   ; since 'mssbyte' uses x
    .else
        _ireg = setreg __ireg__
    .endif

    .if .paramcount
        ; __mem__

        .if _ireg = yr
            msubyte __target__, _reg: xr
        .else
            msubyte __target__, _reg: yr
        .endif
    .endif

    ldr _ireg: imm, $ff
    @loop:
        inr _ireg
        lsr
        beq @loop
    tra _ireg

    adc #$00
.endmacro

.macro lsub __target__, __ireg__    ; LSSB, MSUB, LSUB (Typed)
    .local _reg, _ireg

    .ifblank __regs__
        _ireg = yr   ; since 'mssbyte' uses x
    .else
        _ireg = setreg __ireg__
    .endif

    .if .paramcount
        ; __mem__

        .if _ireg = yr
            lsubyte __target__, _reg: xr
        .else
            lsubyte __target__, _reg: yr
        .endif
    .endif

    ldr _ireg: imm, $09

    @loop:
        der _ireg
        asl
        beq @loop
    tra _ireg
.endmacro