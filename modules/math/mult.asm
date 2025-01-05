.macro mult __outwidth__, __basewidth__, __modwidth__, __baseref__, __modref__
    .ifdef __baseref__
        memcpy __baseref__, ADDRESSES_MATH_MULT_OUT, __basewidth__
        .endif
    
    .ifdef __modref__
        memcpy __modref__,  ADDRESSES_MATH_MULT_MOD, __modref__
        .endif


    
    