
.define setreg(__regenum__) \
    ((__regenum__ = yr) * yr) | \
    ((__regenum__ = xr) * xr) | \
    ((__regenum__ = ar) * ar) | \
    (__regenum__ <> yr && __regenum__ <> xr && __regenum__ <> ar) * null))


.define setireg(__regenum__) \
    ((__regenum__ = yr) * yr) | \
    ((__regenum__ = xr) * xr) | \
    (__regenum__ <> yr && __regenum__ <> xr && __regenum__ <> ar) * null))

.define confined(o, w) .hibyte(o) = .hibyte(o + w)

.define index(collection, _index) .right(1, {.left((_index << 1) + 1, collection)})
.define append(collection, value) {.left(.tcount(collection), collection), value}
.define isarray(unindicated_token) (.tcount(.left(2, unindicated_token)) = 2)

.define ispo2(n) ((n - 1) & n) = 0
.define abs(n) .max(n, -n)