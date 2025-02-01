.include "../../lib/core/include.asm"   ; include the include system (fun right?)

__libroot__ "../../lib"                 ; specify location of libroot (includes libcore)

; global static includes
includefrom memory, flush

.segment "HEADER"
    header \
        prgrom: 1, \
        mapper: nrom

.segment "CODE"    

reset:
    ldz (ar + xr), 1, out               ; lax #$00 with no warning (not reccomended)
    ldz                                 ; lda #$00 (ez)
    ldz xr                              ; ldx #$00 
    ldz (ar + xr + yr)                  ; clean all gpr
    jmp reset

.segment "VECTORS"
    .addr $0000
    .addr reset
    .addr $0000