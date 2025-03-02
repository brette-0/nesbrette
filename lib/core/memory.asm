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
        .define __malloc SLOW
    .else
        .fatal
    .endif
    
    .if (__amt__ + CURRENT___malloc_USAGE) > (__malloc_END - __malloc_START)
        .fatal
    .endif

    __label__ .set CURRENT_FAST_RAM_USAGE
    CURRENT___malloc_USAGE .set CURRENT___malloc_USAGE + __amt__
    
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

    .if (CURRENT__dealloc_USAGE - __amt__) < 0
        .fatal
    .endif

    __label__ .set null
    CURRENT___dealloc_USAGE .set CURRENT___dealloc_USAGE - __amt__

    .undefine __dealloc
.endmacro