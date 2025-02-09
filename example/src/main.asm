.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; global static includes
;includefrom memory, flush
;includefrom memory, memcpy
;includefrom memory, compare
;includefrom memory, xsxb
includefrom memory, shift

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom


.segment "MEMORY"
Temp  := $200
Temp2 := $204


.segment "CODE"
typeas Temp,  u24
typeas Temp2, u32

reset:
    rshift Temp, 9

        ;rshift Temp, 9
    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000