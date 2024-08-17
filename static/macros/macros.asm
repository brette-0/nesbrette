; label inclusion

.include "system.asm"



.macro __includeif__ condition path
    .if condition
        .include path
    .endif
    .endmacro


.macro __memclear__ address, width
    .local __clearmem__
    .ifndef address, width
        stx $01
        sta $00
        lda #$00
        @__clearmem__:
            sta ($00), y
            dey
            bne @__clearmem__
            
        .exitmacro
    .endif

    lax #$00
    @__clearmem__:
        sta address, x
        inx
        bne @__clearmem__

    .endmacro


.macro __libinclude__ path
    .include (path .concat "/constants.nesbrette.asm")
    .include (path .concat "/addresses.nesbrette.asm")
    .include (path .concat "/includes.nesbrette.asm")

    ; scan modules
    .include "math.asm"
    .include "logic.asm"
    .include "rng.asm"
    .include "bias.asm"

    .endmacro


__includeif__ MACROS_INCLUDE_INES2 "static/macros/instructions/ines2.asm"
__includeif__ (MACROS_INCLUDE_MMC5 .and Maper = 5)  "static/macros/instructions/ines2.asm"
__includeif__ MACROS_INCLUDE_VRAM "static/macros/instructions/vram.nes"