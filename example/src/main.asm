.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"

reset:
    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000