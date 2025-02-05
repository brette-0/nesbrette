``memory``
==========

The majority of higher bit math functions is dealing with memory due to thin buses and registers. Analysing memory often can yield circumstantial optimisations, copying memory often is faster than indirectly fetching new targets and a great way to evade code debt is to utilise the well written ``juggle`` method.


``memcpy t:source, t:target``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``includefrom memory, memcpy``

.. TODO: inabsy/inabsx for memcpy

.. code-block::

    required:
        (ca65_int)          __gpr__         fails on invalid GPR
        (int: ptr)          __source__
        (int: ptr)          __target__

    optional:
        (gpr)               __reg$__        fails on invalid GPR
        (mode: mode)        __modes$__      fails on invalid modes
        (error)             __stwm$__       fails on invalid error level
        (ca65_bool)         __fill$__       
        (gpr)               __zero$__       fails on invalid GPR

    dependacies:
        libcore

Transfers one variable to another variable with a 'clone' operation with width and endian context. Always stores as much as the target type requires, but if the source width is shorter than the target then by default the target will have zeroes in its higher bytes.

To prevent redundant loads, you can pass a register that holds zero into the ``__zero$__`` parameter. Without a non-null definition for ``__zero$__``, ``nesbrette`` will load a zero into the 'data GPR' after performing the transfer ensuring that a GPR's value is a deterministic constant at the end (zero).

``memcpy`` can also peform indexed transfers between registers for advanced memory handling with use of the ``__mode$__`` parameter. Naturally be wary of what 'instructions' have what memory address modes when specifying register and modes.

``memcpy`` may raise a ``SourceTargetWidthMismatchException`` in which the operations are of differing widths. Now while this is supported by ``nesbrette``, its quite possible that it was done on accident and therefore has the optional ``__stwm$__`` parameter to set the error level of this occurance.

Finally you may choose to opt out of 'filling' by setting ``__fill$__`` to ``0``. Should it be that the source is greater than the target *only* enough information to fit the width of the target will be specified.

.. code-block::

    memcpy u32: Source, u32: Target
    memcpy Source, Target
    mempcy Source, Target, xr
    mempcy Source, Target, ar, absx: absy
    mempcy Source, Target, null, null, fatal
    mempcy Source, Target, null, null, null, 0
    mempcy Source, Target, ar, null, null, 1, yr
    mempcy Source, Target, ar, null, null, 1, yr, clearfirst

``ldz __gpr__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``includefrom memory, flush``

.. note::

    .. code-block::

        required:
            (ca65_int)          __gpr__         fails on invalid GPR

        dependacies:
            libcore

    Loads any GPR with ``$00``.

    .. code-block::

        ldz                     ; lda #$00                  2b 2c
        ldz xr                  ; ldx #$00                  2b 2c


``stz __target__, __reg$__, __zero$__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

    .. code-block::

        required:
            (nb: int, ident: addr) __target__
        
        optional:
            (token | gpr: gpr?)     __reg$__        fails on invalid GPRs
            (ca65_bool)             __zero$__       No room for error


        dependacies:
            libcore

    Stores ``$00`` at set variable in memory with optional indexing with token or ``enum`` with optional 'load->store' ``gpr`` specifism and 'assume gpr 'r' is already zero'.

    .. code-block::

        stz Score               ; (4 * w_Score) + 2c : (3 * w_Score) + 2b 
        stz u32: Score          ; =
        stz ScoreLen: Score     ; =
        stz Region, y           ; + w_Score * 1.5c +0b
        stz Region, null : x    ; (4 * w_Score) + 2c : (3 * w_Score) + 2b 
        stz Region, y, 1        ; -2c, -2b

``compare __source__, __target__, __reg$__, __modes$__, __fallback$__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``includefrom memory, compare``

.. note::

    .. code-block::

        required:
            (int: ptr)              __source__          
            (int: ptr)              __target__          
            
        optional:
            (gpr)                   __reg$__            fails on invalid GPR
            (mam: mam)              __modes$__          fails on invalid modes
            (ca65_int)              __fallback$__       accessed immediately
        
        dependacies:
            libcore

    Compares two arrays against each other as if they were architecture words for the following responses in CPU Status:

    .. code-block::
        
        Z = On Equal
        C = On Equal or Greater Than
        V = On Greater Than
        N = On Sign Difference

    Usage:

    .. code-block::

        compare Source, Target
        compare Source, Target, yr
        compare Source, Target, yr, wabs: wabsx
        compare Source, Target, yr, wabs: wabsx, $ff