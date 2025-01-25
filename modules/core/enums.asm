.enum
    ; register
    ar   = -1
    xr   = -2
    yr   = -3

    ; cpu status
    zf   = -1
    cf   = -2
    if   = -4
    df   = -8
    bf   = -16
    ; 
    of   = -64
    nf   = -128

    ; endian
    little = -1
    small  = little
    big    = -2
    large  = big

    ; directness
    implied   = -1
    immediate = -2
    direct    = -3  ; either absolute or zp
    indirect  = -4  ; any of the indirect modes

    ; flag states
    unset = 0
    clear = unset
    set = 1

    ; handy kw to resolve jsr->rts
    return = 1

    null = (1 << 31)
.endenum