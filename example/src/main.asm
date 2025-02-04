.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; global static includes
includefrom memory, flush
includefrom memory, memcpy

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"    

Temp  = $200
Temp2 = $204

typeas Temp,  bu16
typeas Temp2, bu32

reset:
    ;stz t_Temp: Temp
    memcpy Temp, Temp2
    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000