.macro juggle __regions__
    .local l_ctarget, t_ctarget, w_ctarget

    l_ctarget .set .ident(.left(1, __regions__))
    t_ctarget .set .ident(.sprintf("t_%s", .left(1, __regions__)))
    w_ctarget .set typeval t_ctarget

    ; if nothing to swap
    .if .tcount(__regions__) < 2
        ; TODO: decide if this needs a warning?
        .exitmacro
    .endif


    .repeat w_ctarget, iter
        ; endian is inverted because how stack works, this is the easist way to reverse the push
        ldr wabs: ar, eindex l_ctarget, w_ctarget, iter, (!endian t_ctarget)
        pha
    .endrepeat

    .repeat .tcount(__regions__), iter
        ; do not account for iter 0, -1 as __regions__[0, -1] is accounted for
        .if (iter > 0) && (iter < (((.tcount(__regions__) - 1) >> 1))
            .out .sprintf("%d", iter)
            .out strindex __regions__, iter
            l_ctarget .set .ident(strindex __regions__, iter)
            ;t_ctarget .set .ident(.sprintf("t_%s", strindex __regions__, iter))
            ;w_ctarget .set typeval t_ctarget

    ;        l_ntarget .set index __regions__, iter + 1
    ;        detype l_ntarget, t_ntarget

    ;        memcpy t_ctarget: l_ctarget, t_ntarget: l_ntarget
        .endif
    .endrepeat

    l_ctarget .set .ident(.right(1, __regions__))
    t_ctarget .set .ident(.sprintf("t_%s", .right(1, __regions__)))
    w_ctarget .set typeval t_ctarget

    .repeat w_ctarget, iter
        pla
        str wabs: ar, eindex l_ctarget, w_ctarget, iter, (endian t_ctarget)
    .endrepeat
.endmacro