; global logic
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
.if INCLUDES_NESBRETTE_MATH_TRIG_SIN
    .include .concat(libroot, "global/math/trig/sin.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_COS
    .include .concat(libroot, "global/math/trig/cos.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_TAN
    .include .concat(libroot, "global/math/trig/cos.tan")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_CSC
    .include .concat(libroot, "global/math/trig/csc.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_COT
    .include .concat(libroot, "global/math/trig/cot.asm")
.endif

.if INCLUDES_NESBRETTE_MATH_TRIG_SEC
    .include .concat(libroot, "global/math/trig/sec.asm")
.endif

; global/synth
.if INCLUDES_NESBRETTE_SYNTH_INSTRUCTIONS
    .include .concat(libroot, "global/synth/s6502.asm")
.endif

; global/synth
.if INCLUDES_NESBRETTE_SYNTH_IDTABLE
    .include .concat(libroot, "global/synth/i6502.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_ILLEGAL_ID
    .include .concat(libroot, "global/synth/i6502x.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_INSTRUCTIONS
    .include .concat(libroot, "global/synth/i6502.asm")
.endif

.if INCLUDES_NESBRETTE_SYNTH_GPR
    .include .concat(libroot, "global/synth/gpr.asm")
.endif

; global/prep
.if INCLUDES_NESBRETTE_PREP_ALIGNED
    .include .concat(libroot, "global/prep/aligned.asm")
.endif

.if INCLUDES_NESBRETTE_PREP_COLLECTION
    .include .concat(libroot, "global/prep/collection.asm")
.endif

.if INCLUDES_NESBRETTE_PREP_EVAL
    .include .concat(libroot, "global/prep/evaluation.asm")
.endif

.if INCLUDES_NESBRETTE_PREP_NULL
    .include .concat(libroot, "global/prep/null.asm")
.endif

.if INCLUDES_NESBRETTE_PREP_RLOAD
    .include .concat(libroot, "global/prep/rload.asm")
.endif

; global/memory
.if INCLUDES_NESBRETTE_MEMORY_COMPARE
    .include .concat(libroot, "global/memory/compare.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_EVAL
    .include .concat(libroot, "global/memory/eval.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_FLUSH
    .include .concat(libroot, "global/memory/flush.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_JUGGLE
    .include .concat(libroot, "global/memory/juggle.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_MEMCPY
    .include .concat(libroot, "global/memory/memcpy.asm")
.endif

.if INCLUDES_NESBRETTE_MEMORY_MSSB
    .include .concat(libroot, "global/memory/MSSB.asm")
.endif