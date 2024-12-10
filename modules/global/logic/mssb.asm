.repeat 255, iter
    _MSSB_TEMP_VALUE .set 0
    .if iter
        .repeat 8, shift
            .if ((iter >> (7 - shift)) & 1) .and (!_MSSB_TEMP_VALUE)
                _MSSB_TEMP_VALUE .set (7 - shift)
                .endif
            .endrepeat
            .ident(.sprintf("MSSB_VALUE_%d", iter)) .set _MSSB_TEMP_VALUE
        .endrepeat
    .endif

.define MSSB(n) .ident(.sprintf("MSSB_VALUE_%d", n))