/*

    Sine, Cosine, Tangent, Arcsine, Arcosine, Arctangent, Secant, Cosecant, cotangent, Arcsecant, Arcosecant, Arcotangent
    
    Wave (Custom Wave)

    Linear table
    X = Y
    X + 1 = Y

    TODO: Consider nan, inf, ninf, 

    If the user can gaurantee that the index will lie within foo and bar, then we can exclusively generate information for those regions.

    table Sine
    
    table Polynomial -(2i / 3), (i ^ 0.5), 4i
        ; f(x) = -(2x/3)^3 + 5i

    NOTE:
        Indicies will *always* yield positive results, even if there are negative roots.


    The process can depend on define evaluation if we use define abuse
    this way we wont need to calculate much, but we will need a clever way of handling indicies
*/

.macro gen __func__,  il, ih, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, z
    .local resp
    
    .repeat ih - il, iter
        math resp, __func__ a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, iter, z 
        .byte resp
    .endrepeat
.endmacro

.macro math __resp__, __func__, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, z
    .local resp
    __resp__ .set null

    __rest__ .set resp
.endmacro

/*

    TABLE_NAME
    TABLE_SIZE


*/

.macro table __name__, __il$__, __ih$__
    .if     .xmatch(__name__, id)
        ; generate idtable
        gen x, 0, 256               ; y = x (limit 0 <+ x < 256)
    .elseif .xmatch(__name__, sin)
        ; generate sin table
    .elseif .xmatch(__name__, cos)
        ; generate cos table
    .elseif .xmatch(__name__, tan)
        ; generate tan table
    .elseif .xmatch(__name__, asin)
        ; generate asin table
    .elseif .xmatch(__name__, acos)
        ; generate acos table
    .elseif .xmatch(__name__, atan)
        ; generate atan table
    .elseif .xmatch(__name__, sct)
        ; generate sct table
    .elseif .xmatch(__name__, csc)
        ; generate csc table
    .elseif .xmatch(__name__, cot)
        ; generate cot table
    .elseif .xmatch(__name__, asct)
        ; generate asct table
    .elseif .xmatch(__name__, acsc)
        ; generate acsc table
    .elseif .xmatch(__name__, acot)
        ; generate acot table
    .elseif .xmatch(__name__, bcd)
        ; generate bcd table
    .else
    .endif
.endmacro