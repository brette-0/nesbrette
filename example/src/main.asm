.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)


.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"

table:
    poly (b + 1) * (b + 1), 0, 256, expo i, 2

reset:
    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000