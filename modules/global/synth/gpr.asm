.macro inr __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        inx
    .elseif __target__ = yr
        iny
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro der __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        dex
    .elseif __target__ = yr
        dey
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro tar __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        tax
    .elseif __target__ = yr
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

; tyx/txy is documented as i6502 (NOT CA65 MACPACK OR STACK METHOD)
.macro tyr __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        tyx
    .elseif __target__ = ar
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro txr __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        txa
    .elseif __target__ = yr
        txy
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro tra __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txa
    .elseif __target__ = yr
        tya
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro trx __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = ar
        tax
    .elseif __target__ = yr
        tyx
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro try __target__
    .ifblank __target__
        .fatal "Register must be specified"
    .elseif __target__ = xr
        txy
    .elseif __target__ = ar
        tay
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro trr __src__, __tar__
    .if __src__ = __tar__
        .exitmacro
    .endif

    .if    __src__ = ar
        tar __tar__
    .elseif __src__ = xr
        txr __tar__
    .elseif __src = yr
        tyr __tar__
    .else
         .fatal "Invalid register specified"
    .endif
.endmacro