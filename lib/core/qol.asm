; tested working
; returns (gpr?)
; params : (ca65_int)
.define setreg(__regenum__) \
     ((__regenum__ = yr) * yr) | \
     ((__regenum__ = xr) * xr) | \
     ((__regenum__ = ar) * ar) | \
    (((__regenum__ <> yr) && (__regenum__ <> xr) && (__regenum__ <> ar)) * null)

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

.define index(collection, _index) .right(1, {.left((_index << 1) + 1, collection)})
.define append(collection, value) {.left(.tcount(collection), collection), value}


.define isarray(unindicated_token) (.tcount(.left(2, unindicated_token)) = 2)

.define ispo2(n) ((n - 1) & n) = 0
.define abs(n) .max(n, -n)
.define confined(o, w) .hibyte(o) = .hibyte(o + w)


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