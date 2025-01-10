; global/header
.if INCLUDES_NESBRETTE_HEADER
    .include .concat(libroot, "global/header/header.asm")
.endif

.if INCLUDES_NESBRETTE_LOGIC_LSHIFT
    .include .concat(libroot, "global/logic/lshift.asm")
.endif

.if INCLUDES_NESBRETTE_LOGIC_RSHIFT
    .include .concat(libroot, "global/logic/rshift.asm")
.endif

.if INCLUDES_NESBRETTE_LOGIC_LSSB
    .include .concat(libroot, "global/logic/lssb.asm")    ; homes LSSB(sym)
.endif

.if INCLUDES_NESBRETTE_LOGIC_MSSB
    .include .concat(libroot, "global/logic/mssb.asm")    ; homes MSSB(sym)
.endif

;.if INCLUDES_NESBRETTE_MATH_ISPO2
;    .include .concat(libroot, "global/math/ispo2.asm")    ; homes ispo2(sym)
;.endif

; global/math
.if INCLUDES_NESBRETTE_MATH_ADD
    .include .concat(libroot, "global/math/add.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_SUB
    .include .concat(libroot, "global/math/sub.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_CMULT
    .include .concat(libroot, "global/math/cmult.asm")
.endif

; global/math/trig
.if INCLUDES_NESBRETTE_MATH_TRIG_SIN
    .include .concat(libroot, "global/math/trig/sin.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_COS
    .include .concat(libroot, "global/math/trig/cos.asm")
.endif

; global/idtable
.if INCLUDES_NESBRETTE_IDTABLE_INSTRUCTIONS
    .include .concat(libroot, "global/idtable/i6502.asm")
.endif

.if INCLUDES_NESBRETTE_IDTABLE_ILLEGAL
    .include .concat(libroot, "global/idtable/i6502x.asm")
.endif