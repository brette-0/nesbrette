.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; include statics
;includefrom memory, compare

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "MEMORY"

.segment "CODE"

Temp1:
    .word $0000

Temp2:
    .word $0001

; Z is total equivalence
; N is numerical equivlance

typeas Temp1, u16
typeas Temp2, i16

reset:
    ;compare Temp1, Temp2


.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000