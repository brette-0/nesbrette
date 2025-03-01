``memory``
==========

The majority of higher bit math functions is dealing with memory due to thin buses and registers. Analysing memory often can yield circumstantial optimisations, copying memory often is faster than indirectly fetching new targets and a great way to evade code debt is to utilise the well written ``juggle`` method.


``memcpy t:source, t:target, __reg$__, __modes$__, __stwm$__, __fill$__, __zero$__, __order$__``
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

Optionally, you may choose to opt out of 'filling' by setting ``__fill$__`` to ``0``. Should it be that the source is greater than the target *only* enough information to fit the width of the target will be specified.

``memcpy`` will access source offset from different ends depending on the positivity of the source-target offset delta. Should it be that the target is *ahead* of the source information then we will copy data from the right, then how it is stored is dependant on the similarity of the source-target endians. The purpose of this is to negate possible corruption when moving chunks of a width greater than the distance they will move.

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

``compare __source__, __target__, __skip$__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``includefrom memory, compare``

.. note::

    .. code-block::

        required:
            (int: ptr)              __source__          
            (int: ptr)              __target__          
            
        uses:
            a                       CPU Status Payload
            x                       Off-Hand Register
            y                       Data Register

            ram:
                srcdelta 1          Source at Greatest Numerical Difference
                tardelta 1          Target at Greatest Numerical Difference

                // when comparing different length arrays, where the shorter
                // is negative, compare will request an additional byte
        
                fill     1          'Const' to contextualise OOB Accesses.
        dependacies:
            libcore

    Compares two arrays against each other as if they were architecture words for the following responses in CPU Status:

    .. code-block::
        
        Z = On Equal
        N = On Numerical Equivalence
        C = On Equal or Greater Than
        V = On Greater Than

    Optimisations:

    **1. Cast to Unsigned**
    
    .. code-block::
        
        data1 = $200
        data2 = $200

        typeas data1, i32
        typeas data2, i32

        compare data1, data2
        compare u32: data1, u32: data2
        
    If *any* number is deterministically positive up to this point, you can compare with a cast to unsigned (which is free) which removes signature checks. However, if this is done with numbers that *may* be neative, you may run the risk of producing erroneous outcomes.

    **2. Cast to Smaller**
    
    .. code-block::
        
        data1 = $200
        data2 = $200

        typeas data1, i32
        typeas data2, i32

        compare data1, data2
        compare i16: data1, i16: data2
        
    ``compare`` will scan *all* the bytes given until it finds difference, which means there is a size and speed penalty to be paid for *potential* difference. If you can prove that at a certain point a variable contains constant memory then you should design your code to acknowledge that and ``nesbrette`` assists you here by allowing you to cast to smaller number types to redundant cycles.

    It should be noted that ``compare`` does not require the types to match endians, signature or width and smaller width *always* results in gained speed performance. However, it *should* be noted that while calling ``compare`` comes with a base ``2 byte`` nesbrette label stack penalty, should you have the smaller array be signed then you incur an dditional ``1 byte`` of nesbrette label stack being consumed.
    
    Usage:

    .. code-block::

        compare Source, Target



``rshift __amt__``
~~~~~~~~~~~~~~~~~~


``rshift __t:int__, __amt__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``lshift __amt__``
~~~~~~~~~~~~~~~~~~


``lshift __t:int__, __amt__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``shift __amt__``
~~~~~~~~~~~~~~~~~~


``shift __t:int__, __amt__``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~