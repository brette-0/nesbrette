CURRENT_FAST_RAM_USAGE .set 0
CURRENT_ZP_USAGE       .set 0
CURRENT_SLOW_RAM_USAGE .set 0

.macro malloc __label__, __amt__, __region$__

    .ifblank __region$__
        .define __malloc FAST_RAM
    .elseif .xmatch(__region$__, fast)
        .define __malloc FAST_RAM
    .elseif .xmatch(__region$__, zp)
        .define __malloc ZP
    .elseif .xmatch(__region$__, slow)
        .define __malloc SLOW_RAM
    .else
        .fatal
    .endif

    .if     .xmatch(__malloc, FAST_RAM)
        .if (__amt__ + CURRENT_FAST_RAM_USAGE) > (FAST_RAM_END - FAST_RAM_START)
            .fatal
        .endif

        __label__ .set CURRENT_FAST_RAM_USAGE + FAST_RAM_START
        CURRENT_FAST_RAM_USAGE .set CURRENT_FAST_RAM_USAGE + __amt__
    .elseif .xmatch(__malloc, ZP)
        .if (__amt__ + CURRENT_ZP_USAGE) > (ZP_END - ZP_START)
            .fatal
        .endif

        __label__ .set CURRENT_ZP_USAGE + ZP_START
        CURRENT_ZP_USAGE .set CURRENT_ZP_USAGE + __amt__
    .else
        .if (__amt__ + CURRENT_SLOW_RAM_USAGE) > (SLOW_RAM_END - SLOW_RAM_START)
            .fatal
        .endif

        __label__ .set CURRENT_SLOW_RAM_USAGE + SLOW_RAM_START
        CURRENT_SLOW_RAM_USAGE .set CURRENT_SLOW_RAM_USAGE + __amt__
    .endif

    .undefine __malloc
.endmacro

.macro dealloc __label__, __amt__, __region$__

    .ifblank __region$__
        .define __dealloc FAST_RAM
    .elseif .xmatch(__region$__, fast)
        .define __dealloc FAST_RAM
    .elseif .xmatch(__region$__, zp)
        .define __dealloc ZP
    .elseif .xmatch(__region$__, slow)
        .define __dealloc SLOW
    .else
        .fatal
    .endif

    .if     .xmatch(__malloc, FAST_RAM)
        __label__ .set null
        CURRENT_FAST_RAM_USAGE .set CURRENT_FAST_RAM_USAGE - __amt__

        .if (CURRENT__dealloc_USAGE - __amt__) < 0
            .fatal
        .endif
    .elseif .xmatch(__malloc, ZP)
        __label__ .set null
        CURRENT_ZP_USAGE .set CURRENT_ZP_USAGE - __amt__

        .if (CURRENT_ZP_USAGE - __amt__) < 0
            .fatal
        .endif    .else
    .elseif .xmatch(__malloc, SLOW_RAM)
        __label__ .set null
        CURRENT_SLOW_RAM_USAGE .set CURRENT_SLOW_RAM_USAGE - __amt__

        .if (CURRENT_SLOW_RAM_USAGE - __amt__) < 0
            .fatal
        .endif
    .else
        .fatal
    .endif

    .undefine __dealloc
.endmacro