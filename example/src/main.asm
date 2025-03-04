.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"

reset:
    jmp reset

; TODO: work on LUA scripts (we need devtools
; TODO: Use "+op" to indicate determinstic positive and "-op" for determinsitic negative

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000