.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; include statics
includefrom memory, compare
includefrom synth, stack

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "MEMORY"

.segment "CODE"

Temp1:
    .byte $00, $00, $00, $00

Temp2:
    .byte $00, $00, $00, $01

typeas Temp1, u32
typeas Temp2, u32

reset:
    compare Temp1, Temp2


.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000