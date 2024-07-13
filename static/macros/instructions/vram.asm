.macro point_nt table x y
    ; %0010 ttyy yyyy xxxx
    .if (y > 29) .and WARNINGS_OOB_VRAM
        .warning "This call will write to attr tables, if this is in error please consider using point_attr"
    .endif

    .if (x > 32) .or (y > 32)
        .error "Invalid values attempted to write to point_nt"
    .endif

    lda #($20 | (table << 2) | (y >> 4))
    sta PPUADDR

    lda #((y << 4) & $c0) | x)
    sta PPUADDR

    .endmacro

.macro point_attr table x y
    ; %0010 ttyy yyyy xxxx
    ; returns a with mask
    .if (y > 29) .and WARNINGS_OOB_VRAM
        .warning "This call will write to attr tables, if this is in error please consider using point_attr"
    .endif

    .if (x > 32) .or (y > 32)
        .error "Invalid values attempted to write to point_nt"
    .endif

    lda #($23 | (table << 2))
    sta PPUADDR

    lda ((y >> 4) | (x >> 4))
    sta PPUADDR

    lda #(($03 << ((x & $04) >> 1)) << ((y & $04) >> 2))
    .endmacro


.macro wait_vblank
    .local here
    @here:
        bit PPUSTATUS
        bpl @here
    .endmacro