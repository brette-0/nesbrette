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

; local/math
.if INCLUDES_NESBRETTE_MATH_MULT
    .include .concat(libroot, "math/mult.asm")
.endif

; global/math/trig
.if INCLUDES_NESBRETTE_MATH_TRIG
    .include .concat(libroot, "global/math/trig.asm")
.endif

; global/synth
.if INCLUDES_NESBRETTE_SYNTH_INSTRUCTIONS
    .include .concat(libroot, "global/synth/s6502.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_IDTABLE
    .include .concat(libroot, "global/synth/i6502.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_ILLEGAL_ID
    .include .concat(libroot, "global/synth/i6502x.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_STACK
    .include .concat(libroot, "global/synth/stack.asm")
.endif

; global/memory
.if INCLUDES_NESBRETTE_MEMORY_STZ
    .include .concat(libroot, "global/memory/stz.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_COMPARE
    .include .concat(libroot, "global/memory/compare.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_EVAL
    .include .concat(libroot, "global/memory/eval.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_JUGGLE
    .include .concat(libroot, "global/memory/juggle.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_MEMCPY
    .include .concat(libroot, "global/memory/memcpy.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_SHIFT
    .include .concat(libroot, "global/memory/shift.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_MSSSUB
    .include .concat(libroot, "global/memory/m,ss,ub.asm")
.endif