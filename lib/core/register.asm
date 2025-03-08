.define setmam(__mam__) \
        ((__mam__ = imp)    * imp   ) | \
        ((__mam__ = imm)    * imm   ) | \
        ((__mam__ = zp)     * zp    ) | \
        ((__mam__ = zpx)    * zpx   ) | \
        ((__mam__ = zpy)    * zpy   ) | \
        ((__mam__ = wabs)   * wabs  ) | \
        ((__mam__ = wabsx)  * wabsx ) | \
        ((__mam__ = wabsy)  * wabsy ) | \
        ((__mam__ = abst)   * abst  ) | \
        ((__mam__ = absx)   * absx  ) | \
        ((__mam__ = absy)   * absy  ) | \
        ((__mam__ = inabs)  * inabs ) | \
        ((__mam__ = inabsx) * inabsx) | \
        ((__mam__ = inabsy) * inabsy) | \
        (((__mam__ <> imp   ) && \
          (__mam__ <> imm   ) && \
          (__mam__ <> zp    ) && \
          (__mam__ <> zpx   ) && \
          (__mam__ <> zpy   ) && \
          (__mam__ <> wabs  ) && \
          (__mam__ <> wabsx ) && \
          (__mam__ <> wabsy ) && \
          (__mam__ <> abst  ) && \
          (__mam__ <> absx  ) && \
          (__mam__ <> absy  ) && \
          (__mam__ <> inabs ) && \
          (__mam__ <> inabsx) && \
          (__mam__ <> inabsy)  ) \
          * null)

.define mamreg(__mam__) \
        ((__mam__ = imp)    * null) | \
        ((__mam__ = imm)    * null) | \
        ((__mam__ = zp)     * null) | \
        ((__mam__ = zpx)    * xr  ) | \
        ((__mam__ = zpy)    * yr  ) | \
        ((__mam__ = wabs)   * null) | \
        ((__mam__ = wabsx)  * xr  ) | \
        ((__mam__ = wabsy)  * yr  ) | \
        ((__mam__ = abst)   * null) | \
        ((__mam__ = absx)   * xr  ) | \
        ((__mam__ = absy)   * yr  ) | \
        ((__mam__ = inabs)  * null) | \
        ((__mam__ = inabsx) * xr  ) | \
        ((__mam__ = inabsy) * yr  )

; tested working
; returns (gpr?)
; params : (ca65_int)
.define setreg(__reg__) \ 
     ((__reg__ = yr) * yr) | \
     ((__reg__ = xr) * xr) | \
     ((__reg__ = ar) * ar) | \
    (((__reg__ <> yr) && (__reg__ <> xr) && (__reg__ <> ar)) * null)

; tested working
; returns (gpr?)
; params : (ca65_int)
.define csetreg(__reg__) \ 
     (.xmatch(__reg__, y) * yr) | \
     (.xmatch(__reg__, x) * xr) | \
     (.xmatch(__reg__, a) * ar) | \
     ((!(.xmatch(__reg__, a) ||.xmatch(__reg__, x) ||.xmatch(__reg__, y))) * null)

; returns (ca65_int)
; params : (ca65_int)
.define setmreg(__regsnum__) \
     ( (__regsnum__ = yr) * yr)                         | \
     ( (__regsnum__ = xr) * xr)                         | \
     ( (__regsnum__ = (yr + xr)) * (yr + xr))           | \
     ( (__regsnum__ = ar) * ar)                         | \
     ( (__regsnum__ = (yr + ar)) * (yr + ar))           | \
     ( (__regsnum__ = (xr + ar)) * (xr + ar))           | \
     ( (__regsnum__ = (xr + ar + yr)) * (xr + ar + yr)) | \
     ( ((__regsnum__ <> (xr + ar + yr)) && (__regsnum__ <> (xr + yr)) && (__regsnum__ <> (ar + xr)) && (__regsnum__ <> (ar + yr)) && (__regsnum__ <> yr) && (__regsnum__ <> xr) && (__regsnum__ <> ar)) * null)

; returns (igpr?)
; params : (ca65_int)
.define setireg(__regenum__) \
     ((__regenum__ = yr) * yr) | \
     ((__regenum__ = xr) * xr) | \
    (((__regenum__ <> yr) && (__regenum__ <> xr) * null)

.macro iralloc __send__, __used__
    .ifblank __send__
        .fatal  ; needs target
    .endif

    .ifblank __used__
        __send__ .set yr
    .elseif __used__ = xr
        __send__ .set yr
    .else
        __send__ .set xr
    .endif
.endmacro

.macro ralloc __send__, __used1__, __used2__
    .ifblank __send__
        .fatal  ; needs target
    .endif

    .ifblank __used1__
        __send__ .set ar
    .elseif is_null __used1__
        __send__ .set ar
    .elseif __used1__ = ar
        __send__ .set xr
    .elseif __used1__ = xr
        __send__ .set yr
    .elseif __used1__ = yr
        __send__ .set ar
    .endif

    ; at the end
    .ifnblank __used2__
        ralloc __send__, __used2__
    .endif
.endmacro

; TODO: Decode syntax here, or else __operand__ will evaluate 
.macro ld __reg__, __operand__, __index__
    .ifblank    __reg__
        .fatal 
    .endif

    overrule .set .xmatch(.left(1, {__operand__}), !)
    .if overrule
        .out .string(.right(1, __operand__))
    .endif

    .if     .xmatch(__reg__, a)
        lda .right(.tcount(__operand__) - overrule, __operand__), __index__
    .elseif .xmatch(__reg__, x)
        ldx .right(.tcount(__operand__) - overrule, __operand__), __index__
    .elseif .xmatch(__reg__, y)
        ldy .right(.tcount(__operand__) - overrule, __operand__), __index__
    .elseif __reg__ = ar
        lda .right(.tcount(__operand__) - overrule, __operand__), __index__
    .elseif __reg__ = xr
        ldx .right(.tcount(__operand__) - overrule, __operand__), __index__
    .elseif __reg__ = yr
        ldy .right(.tcount(__operand__) - overrule, __operand__), __index__
    .else
        .fatal
    .endif
.endmacro

.macro st __reg__, __operand__, __index__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, a)
        sta __operand__, __index__
    .elseif .xmatch(__reg__, x)
        stx __operand__, __index__
    .elseif .xmatch(__reg__, y)
        sty __operand__, __index__
    .elseif __reg__ = ar
        sta __operand__, __index__
    .elseif __reg__ = xr
        stx __operand__, __index__
    .elseif __reg__ = yr
        sty __operand__, __index__
    .else
        .fatal
    .endif
.endmacro

.macro cp __reg__, __operand__, __index__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, a)
        cmp __operand__, __index__
    .elseif .xmatch(__reg__, x)
        cpx __operand__, __index__
    .elseif .xmatch(__reg__, y)
        cpy __operand__, __index__
    .elseif __reg__ = ar
        cmp __operand__, __index__
    .elseif __reg__ = xr
        cpx __operand__, __index__
    .elseif __reg__ = yr
        cpy __operand__, __index__
    .else
        .fatal
    .endif
.endmacro

.macro in __reg__, __operand__, __index__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, x)
        inx __operand__, __index__
    .elseif .xmatch(__reg__, y)
        iny __operand__, __index__
    .elseif __reg__ = xr
        inx __operand__, __index__
    .elseif __reg__ = yr
        iny __operand__, __index__
    .else
        inc __operand__, __index__
    .endif
.endmacro

.macro de __reg__, __operand__, __index__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, x)
        dex __operand__, __index__
    .elseif .xmatch(__reg__, y)
        dey __operand__, __index__
    .elseif __reg__ = xr
        dex __operand__, __index__
    .elseif __reg__ = yr
        dey __operand__, __index__
    .else
        dec __operand__, __index__
    .endif
.endmacro

.macro ta __reg__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, x)
        tax __operand__, __index__
    .elseif .xmatch(__reg__, y)
        tay __operand__, __index__
    .elseif __reg__ = xr
        tax __operand__, __index__
    .elseif __reg__ = yr
        tay __operand__, __index__
    .else
        sta __operand__, __index__
    .endif
.endmacro

.macro tx __reg__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, x)
        txa __operand__, __index__
    .elseif .xmatch(__reg__, y) && .defined(ID_TABLE)
        txy __operand__, __index__
    .elseif __reg__ = xr 
        txa __operand__, __index__
    .elseif __reg__ = yr && .defined(ID_TABLE)
        txy __operand__, __index__
    .else
        stx __operand__, __index__
    .endif
.endmacro

.macro ty __reg__
    .ifblank    __reg__
        .fatal 
    .elseif .xmatch(__reg__, a)
        tya __operand__, __index__
    .elseif .xmatch(__reg__, x) && .defined(ID_TABLE)
        tyx __operand__, __index__
    .elseif __reg__ = ar 
        tya __operand__, __index__
    .elseif __reg__ = xr && .defined(ID_TABLE)
        txy __operand__, __index__
    .else
        tyx __operand__, __index__
    .endif
.endmacro

.macro t __src__, __tar__
    .if     .xmatch(__src__, __tar__)
        .fatal
    .elseif .xmatch(__src__, a)
        .define __t_op ta
    .elseif .xmatch(__src__, x)
        .define __t_op ta
    .elseif .xmatch(__src__, y)
        .define __t_op ta
    .endif

    __t_op __tar__
    .undefine __t_op
.endmacro