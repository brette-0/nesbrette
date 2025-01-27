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

.define confined(o, w) .hibyte(o) = .hibyte(o + w)

.define index(collection, _index) .right(1, {.left((_index << 1) + 1, collection)})
.define append(collection, value) {.left(.tcount(collection), collection), value}
.define isarray(unindicated_token) (.tcount(.left(2, unindicated_token)) = 2)

.define ispo2(n) ((n - 1) & n) = 0
.define abs(n) .max(n, -n)