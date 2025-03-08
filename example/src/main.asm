includefrom synth, stack

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom


.segment "MEMORY"

foo: .res 4
bar: .res 4

.segment "CODE"

typeas foo, u32
typeas bar, u32

reset:
    lds
    lda $100

; TODO: work on LUA scripts (we need devtools
; TODO: Use "+op" to indicate determinstic positive and "-op" for determinsitic negative

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000