.macro setreg __regenum__, __out__
    .if .xmatch(__index__, y)
        __out__ .set yr
    .elseif .xmatch(__index__, x)
        __out__ .set xr
    .elseif .xmatch(__index__, a)
        __out__ .set ar
    .else
        .fatal "Invalid register specified"
    .endif
.endmacro

.macro setireg __regenum__, __out__
    .if .xmatch(__index__, y)
        __out__ .set yr
    .elseif .xmatch(__index__, x)
        __out__ .set xr
    .else
        .fatal "Invalid indexing register specified"
    .endif
.endmacro

