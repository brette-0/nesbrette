.enum
    ; register
    a   = -1
    x   = -2
    y   = -3

    ; cpu status
    z   = -1
    c   = -2
    i   = -4
    d   = -8
    b   = -16
    ; 
    o   = -64
    n   = -128

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

    null = (1 << 31)
.endenum