``memcpy``
--------=-

``memcpy t:source, t:target``
""""""""""""""""""""""""""""""""""""""""

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


`View Source Code on Github <https://github.com/brette-0/nesbrette/blob/main/lib/memory/memcpy.asm>`_