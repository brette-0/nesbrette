.if INCLUDES_NESBRETTE_MATH_ADD
    ADDRESSES_MATH_ADD_OUT      = $300
    ADDRESSES_MATH_ADD_MOD      = $300 + CONSTANTS_MATH_ADD_WIDTH
.endif

.if INCLUDES_NESBRETTE_MATH_SUB
    ADDRESSES_MATH_SUB_OUT      = $300
    ADDRESSES_MATH_SUB_MOD      = $300 + CONSTANTS_MATH_SUB_WIDTH
.endif