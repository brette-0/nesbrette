.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)


.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"

foo = $00

idtable:
    poly (i * i + i) / 2

reset:
    ldx #$00

    loop:
        lda idtable, x
        inx
        bne loop

    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000