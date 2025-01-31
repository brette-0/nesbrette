; global/math
.if INCLUDES_NESBRETTE_MATH_CMULT
    WARNINGS_MATH_CMULT_MULTZERO    = 1 ; constant multiply by zero
    WARNINGS_MATH_CMULT_OOB         = 1 ; multiplier dangerously large
.endif

; global/math/trig [ table issue, doesn't depend on macros/functions to determine redundancy ]
WARNINGS_MATH_TRIG_DUAL_TABLE   = 1 ; residual table installed


; global/math/add|sub
WARNINGS_MATH_ADD_SUB_BORROW    = 1
; when unrolled borrow logic is being written for signed math (speed & size)