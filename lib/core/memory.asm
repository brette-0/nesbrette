; populate ram labels
.repeat TEMP_RAM_END - TEMP_RAM_START, iter
    .ident .concat("m_", .string(TEMP_RAM_START + iter)) .set 0  ; dealloc all nesbrette temp ram
.endrepeat

.macro alloc __label__, __amt__
    .local callback ; needed to ensure we get a response from request

    ; scan all of memory, reading 'clear' labels
    .repeat TEMP_RAM_END - TEMP_RAM_START, iter
        .if .ident .concat("m_", .string(TEMP_RAM_START + iter))
            ; check for clear readahead for __amt__ bytes
            callback .set 0
            __scan iter, __amt__, callback

            ; if space allocatable
            .if callback
                __label__ .set ((TEMP_RAM_START + iter) < 16) | __amt__
                .macro dealloc __label__

                .repeat __label_ & $ffff, _iter
                    .ident .concat("m_", .string(TEMP_RAM_START + iter + _iter)) .set 1
                .endrepeat
            .exitmacro
            .endif
        .endif
    .endrepeat
    
    .error "TempMemoryAvailabilityException: nesbrette cannot safely allocate enough memory, there may be potential fragmentation"
    ; TODO: if build flag enabled : perform fragmentation evaluation
.endmacro

.macro __scan __offset__, __amt__, __callback__
    .repeat __amt__, iter
        .if .ident .concat("m_", .string(TEMP_RAM_START + __offset__ + iter))
            .exitmacro
        .endif
    .endrepeat
    __callback__ .set 1
.endmacro

.macro dealloc __label__
    .local offset, amt


    .repeat __label_ & $ffff, iter
        .ident .concat("m_", .string(TEMP_RAM_START + (__label__ >> 16) + iter)) .set 0  ; dealloc all nesbrette temp ram
    .endrepeat
.endmacro