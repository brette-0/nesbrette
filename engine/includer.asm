; global/header
.if INCLUDES_NESBRETTE_HEADER
    .include "modules/global/header/header.asm"
.endif

.if INCLUDES_NESBRETTE_LOGIC_LSHIFT
    .include "modules/global/logic/lshift.asm"
.endif

.if INCLUDES_NESBRETTE_LOGIC_RSHIFT
    .include "modules/global/logic/rshift.asm"
.endif

.if INCLUDES_NESBRETTE_LOGIC_LSSB
    .include "modules/global/logic/lssb.asm"    ; homes LSSB(sym)
.endif

.if INCLUDES_NESBRETTE_LOGIC_MSSB
    .include "modules/global/logic/mssb.asm"    ; homes MSSB(sym)
.endif

.if INCLUDES_NESBRETTE_MATH_ISPO2
    .include "modules/global/math/ispo2.asm"    ; homes ispo2(sym)
.endif

; global/math
.if INCLUDES_NESBRETTE_MATH_ADD
    .include "modules/global/math/add.asm"
.endif

.if INCLUDES_NESBRETTE_MATH_SUB
    .include "modules/global/math/sub.asm"
.endif

.if INCLUDES_NESBRETTE_MATH_CMULT
    .include "modules/global/math/cmult.asm"
.endif

; global/math/trig
.if INCLUDES_NESBRETTE_MATH_TRIG_SIN
    .include "modules/global/math/trig/sin.asm"
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_COS
    .include "modules/global/math/trig/cos.asm"
.endif

; global/idtable
.if INCLUDES_NESBRETTE_IDTABLE_INSTRUCTIONS
    .include "modules/global/idtable/i6502.asm"
.endif

.if INCLUDES_NESBRETTE_IDTABLE_ILLEGAL
    .include "modules/global/idtable/i6502x.asm"
.endif