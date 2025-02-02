``ldr``
---------

``ldr __reg_mode__, __value__, __cpre$__``
""""""""""""""""""""""""""""""""""""""""""

``libcore``

.. note::

    .. code-block::

        required:
            (mode: gpr)         __reg_mode__    gpr and mode must be valid
            (ca65_int)          __value__       Must be within u16 range

        optional:
            (nb_error)          __cpre$__       must be valid error level

        dependacies:
            libcore

    Loads any GPR with any value with any mode. This is used for the backend mostly, as the syntax here is designed to be functional above all.
    This instruction *may* throw a ``ConstantParameterRangeException`` which indicates the desired source pointer cannot be accesed entirely by the desired opcode dicated by the memory address mode. 

    .. code-block::

        ldr imm: ar, $ea
        ldr zpx: yr, $ea, warning


``str __reg_mode__, __address__, __cpre$__, __iwle$__``
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

``libcore``

.. note::

    .. code-block::

        required:
            (mode: gpr)         __reg_mode__    gpr and mode must be valid
            (ca65_int)          __value__       Must be within u16 range

        optional:
            (nb_error)          __cpre$__       must be valid error level
            (nb_error)          __iwle$__       must be valid error level

        dependacies:
            libcore

    Store any GPR into any address with any memory address mode. Same as ``ldr`` this syntax isn't designed to be tidy but functional and is frequently accesed by the backend. Will throw the same range exception, or may throw an ``InvalidWriteLocationException`` which indicates that you are attempting to write to ROM. If your header is set up correctly this **should** not fire on PRG-RAM Bankable mappers.

    .. code-block::

        str wabs: ar, $ea 
        str zpx: yr, $ea, warning
        str zpx: yr, $ea, warning, fatal