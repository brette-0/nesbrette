Phase 3
=======

Mapper
    - Flop


Flop will use ``f16`` floating point math inside EDN8P.
Has MMC3 Limitations otherwise.

.. code-block::
    
    $2000       f16_lo
    $2001       f16_hi
    $2002       f16_op
        ; $00   (float)u16
        ; $01   (float)i16
        ; $02   (float)bu16
        ; $03   (float)bi16
        ; $04   (float)u8
        ; $05   (float)i8

        ; $06   (u16)float
        ; $07   (i16)float
        ; $08   (bu16)float
        ; $09   (bi16)float
        ; $0a   (u8)float
        ; $0b   (i8)float

        ; $0c   float place (treat as float, whatever it is)
        ; $0d

        ; 0x    cast
        ; 1x    +float
        ; 2x    -float
        ; 3x    *float
        ; 4x    /float
        ; 5x    ^float
        ; 6x    compare float
        ; 7x    negate float
        ; 8x    is normal
        ; 9x    point index
        ; ax    lost accuracy
        ; bx    round
            ; x is the amount of bits to round