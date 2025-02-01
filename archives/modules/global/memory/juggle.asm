; untested

.warning "deprecrated"

.macro juggle __tokens__, __temp__
    .local t_temp, l_temp, src, tar, taw

    ; juggle amt (signed) later
    ; (final element should have no width)
    ; t0 => t-1

    memcpy (index __tokens__, .tcount(__tokens__) - 1), __temp__
    t_temp .set 0

    detype (index __tokens__, .tcount(__tokens__) - 1), t_temp
    l_temp = ilabel (index __tokens__, 0)


    taw .set 0

    .repeat .tcount(__tokens__), iter
        .if iter <> 0 || iter = .tcount(__tokens__)          ; zero is handled outside the loop
            src .set index iter, __tokens__
            tar .set index iter - 1, __tokens__
            
            dedtype tar, taw
            memcpy taw: src, tar
        .endif
    .endrepeat
    
    memcpy t_temp: __temp__, l_temp
    .endmacro