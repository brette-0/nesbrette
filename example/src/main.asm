.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib/"                ; specify location of libroot (includes libcore)

.segment "HEADER"
    header

.segment "CODE"

.scope code
    reset:
        jmp reset
.endscope

.segment "VECTORS"
    .addr $0000
    .addr code::reset
    .addr $0000