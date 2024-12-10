.repeat 255, iter
    _LSSB_TEMP_VALUE .set 0
    .if iter
        .repeat 8, shift
            .if ((iter >> shift) & 1) .and (!_LSSB_TEMP_VALUE)
                _LSSB_TEMP_VALUE .set shift
                .endif
            .endrepeat
            .ident(.sprintf("LSSB_VALUE_%d", iter)) .set _LSSB_TEMP_VALUE
        .endrepeat
    .endif

.define LSSB(n) .ident(.sprintf("LSSB_VALUE_%d", n))