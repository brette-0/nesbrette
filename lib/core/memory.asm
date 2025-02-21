CURRENT_RAM_USAGE .set 0

.macro malloc __label__, __amt__
    .if (__amt__ + CURRENT_RAM_USAGE) > (TEMP_RAM_END - TEMP_RAM_START)
        .fatal
    .endif

    __label__ .set CURRENT_RAM_USAGE
    CURRENT_RAM_USAGE .set CURRENT_RAM_USAGE + __amt__
.endmacro

.macro dealloc __label__, __amt__
    .if (CURRENT_RAM_USAGE - __amt__) < 0
        .fatal
    .endif

    __label__ .set null
    CURRENT_RAM_USAGE .set CURRENT_RAM_USAGE - __amt__
.endmacro