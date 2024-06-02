.define _MMC5_MACROS_included 1

.if MAPPER = 5
    .macro mmc5_square
        ; a = base
        sta $5205
        sta $5206
        .endmacro 
    .endif