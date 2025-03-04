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

.define ispo2(n) ((n - 1) & n) = 0
.define abs(n) .max(n, -n)
.define confined(o, w) .hibyte(o) = .hibyte(o + w)

.macro callback __target__ 
    lda #>(__target__ - 1)
    pha
    lda #>(__target__ - 1)
    pha
.endmacro

.macro contains __out__, __context__, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48, _49, _50, _51, _52, _53, _54, _55, _56, _57, _58, _59, _60, _61, _62, _63, _64, _65, _66, _67, _68, _69, _70, _71, _72, _73, _74, _75, _76, _77, _78, _79, _80, _81, _82, _83, _84, _85, _86, _87, _88, _89, _90, _91, _92, _93, _94, _95, _96, _97, _98, _99
        .ifblank _0
                .exitmacro
        .else
                .if .xmatch(__context__, _0)
                        __out__ .set 1
                .else
                        contains __out__, __context__, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12, _13, _14, _15, _16, _17, _18, _19, _20, _21, _22, _23, _24, _25, _26, _27, _28, _29, _30, _31, _32, _33, _34, _35, _36, _37, _38, _39, _40, _41, _42, _43, _44, _45, _46, _47, _48, _49, _50, _51, _52, _53, _54, _55, _56, _57, _58, _59, _60, _61, _62, _63, _64, _65, _66, _67, _68, _69, _70, _71, _72, _73, _74, _75, _76, _77, _78, _79, _80, _81, _82, _83, _84, _85, _86, _87, _88, _89, _90, _91, _92, _93, _94, _95, _96, _97, _98, _99
                .endif
        .endif
.endmacro

.macro strindex __out__, __ctx__, __array__, __last$__
    .local foo, last

    last .set 0
    .ifnblank __last$__
        last .set __last$__
    .endif

    .repeat .strlen(__array__), iter
        .if .strat(__array__, iter) = __ctx__ && (!.def(foo))
            .if !last
                foo := null
            .endif
            __out__ .set iter
            .exitmacro
        .endif
    .endrepeat
.endmacro

; I seriously doubt we will raise anything ot the 8th exponent, but if you do
; feel free to let me know in a bug report because I can arrange this to be longer
.define expo(__base__, __exp__)\
        1                          * \
        ((__base__ * (__exp__ > 0)) | (__exp__ <= 0)) * \
        ((__base__ * (__exp__ > 1)) | (__exp__ <= 1)) * \
        ((__base__ * (__exp__ > 2)) | (__exp__ <= 2)) * \
        ((__base__ * (__exp__ > 3)) | (__exp__ <= 3)) * \
        ((__base__ * (__exp__ > 4)) | (__exp__ <= 4)) * \
        ((__base__ * (__exp__ > 5)) | (__exp__ <= 5)) * \
        ((__base__ * (__exp__ > 6)) | (__exp__ <= 6)) * \
        ((__base__ * (__exp__ > 7)) | (__exp__ <= 7)) 

; TAKEN FROM CC65 SRC AS IS AND IS TESTED

; bge - jump if unsigned greater or equal
.macro  bge     Arg
        bcs     Arg
.endmacro

; blt - Jump if unsigned less
.macro  blt     Arg
        bcc     Arg
.endmacro

; bgt - jump if unsigned greater
.macro  bgt     Arg
        beq     *+4
        bcs     Arg
.endmacro

; ble - jump if unsigned less or equal
.macro  ble     Arg
        beq     Arg
        bcc     Arg
.endmacro

; bnz - jump if not zero
.macro  bnz     Arg
        bne     Arg
.endmacro

; bze - jump if zero
.macro  bze     Arg
        beq     Arg
.endmacro

.macro  jeq     Target
        .if     .match(Target, 0)
        bne     *+5
        jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                beq     Target
        .else
                bne     *+5
                jmp     Target
        .endif
.endmacro
.macro  jne     Target
        .if     .match(Target, 0)
                beq     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bne     Target
        .else
                beq     *+5
                jmp     Target
        .endif
.endmacro
.macro  jmi     Target
        .if     .match(Target, 0)
                bpl     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bmi     Target
        .else
                bpl     *+5
                jmp     Target
        .endif
.endmacro
.macro  jpl     Target
        .if     .match(Target, 0)
                bmi     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bpl     Target
        .else
                bmi     *+5
                jmp     Target
        .endif
.endmacro
.macro  jcs     Target
        .if     .match(Target, 0)
                bcc     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bcs     Target
        .else
                bcc     *+5
                jmp     Target
        .endif
.endmacro
.macro  jcc     Target
        .if     .match(Target, 0)
                bcs     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bcc     Target
        .else
                bcs     *+5
                jmp     Target
        .endif
.endmacro
.macro  jvs     Target
        .if     .match(Target, 0)
                bvc     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bvs     Target
        .else
                bvc     *+5
                jmp     Target
        .endif
.endmacro
.macro  jvc     Target
        .if     .match(Target, 0)
                bvs     *+5
                jmp     Target
        .elseif .def(Target) .and .const((*-2)-(Target)) .and ((*+2)-(Target) <= 127)
                bvc     Target
        .else
                bvs     *+5
                jmp     Target
        .endif
.endmacro