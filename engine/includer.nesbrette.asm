.ifndef __includeif__ 
    .macro __includeif__ path condition
        .if condition
            .include path
            .endif
        .endmacro
.endif

; global/header
__includeif__ "modules/global/header/header.asm"        INCLUDES_NESBRETTE_HEADER

; global/math
__includeif__ "modules/global/math/add.asm"             INCLUDES_NESBRETTE_MATH_ADD
__includeif__ "modules/global/math/sub.asm"             INCLUDES_NESBRETTE_MATH_SUB
__includeif__ "modules/global/math/cmult.asm"           INCLUDES_NESBRETTE_MATH_CMULT

; global/math/trig
__includeif__ "modules/global/math/trig/sin.asm"        INCLUDES_NESBRETTE_MATH_TRIG_SIN
__includeif__ "modules/global/math/trig/cos.asm"        INCLUDES_NESBRETTE_MATH_TRIG_COS

; global/idtable
__includeif__ "modules/global/idtable/i6502.asm"        INCLUDES_NESBRETTE_IDTABLE_INSTRUCTIONS
__includeif__ "modules/global/idtable/i6502x.asm"       INCLUDES_NESBRETTE_IDTABLE_ILLEGAL
