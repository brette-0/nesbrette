.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; include statics
includefrom memory, compare

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"

Temp1:
    .word $1122, $3344

Temp2:
    .word $5566, $7788

typeas Temp1, u32
typeas Temp2, u32

.macro MyMacro Param1, Param2

.endmacro


reset:



.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000