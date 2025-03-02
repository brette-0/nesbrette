``Tutorials``
=============

``1. Setup``
~~~~~~~~~~~~

To start your first project using ``nesbrette``, download the latest ``nesbrette`` source from github, ensure your using one of the mappers described as having compatibility. If you need a mapper that currently is not suppoted, create a Gihtub issue with the Mapper tag and I should be able to devise a solution within a reasonable timeframe.

.. code-block::

    .include "../../lib/core/include.asm"   ; include the include system

    __libroot__ "../../lib"                 ; access include system

    .segment "HEADER"
        header \                            ; call easy header setup
            prgrom: 1, \
            mapper: nrom

The first line is only required if you haven't passed ``nesbrette/core/include.asm`` to the assembler as an include. The function ``__libroot__`` will 'locate' the ``nesbrette`` modules root and include the core depenancies. This will not take up any space in ROM. The only other thing that has been performed at this point is the definition of two assembler variables ``TEMP_RAM_START`` and ``TEMP_RAM_END`` that poitn to Zero Page.

These exist so that features that depend on RAM may automatically resolve fragmentation, conflicts and handle allocation with miniminal to no user input

The ``header`` macro is *very* useful and *very* simple to use. By default it assumes you want a completely empty cartridge and with the user of optional keyword argumenets in no particular order it will modify the default to provided specififics. For certain elements, ``nesbrette`` accepts non-numerical responses like 'nrom' for Mapper but for unsupported mappers you may use a number instead but it is reccomended to wait for official support.

The reason why you *must* use this is because it generate many defines that are required by ``nesbrette`` as functions may require information on the present hardware to determine the appropriate outcome. 

``2. Syntax``
~~~~~~~~~~~~~

In order to use ``nesbrette`` you will need to use typed labels, to type a label simply do:

.. code-block::

    Label = $200
    typeas Label, u32

Then each time you pass ``Label`` it's context of being an unsigned 32 bit integer is made aware to any macro accessing it. Similarly we can use the use of the type prefix character to specify a type, consider this casting from original type or ``void``.

.. code-block::

    add u32: foo, bar

It should be noted that ``ca65hl`` uses colons for multi-line instruction for its ``if``, ``elseif``, ``for`` and ``while`` macros and therefore *will* not work here. Despite this, ``nesbrette`` can still type deduce labels that have been pre-typed.

As part of ``nesbrette``'s safety oriented features, ``nesbrette`` will forbid erroneous interaction with registers in CPU Space as well as stack. While the ``rule`` macro does exist to modify these safety nets in the current scope, there exists an overrule prefix that will modify the behavior of the instruction.

.. code-block::

    sta PPUCTRL     ; store PPUCTRL, SPPUCTRL 
    sta !PPUCTRL    ; store PPUCTRL

    lda PPUCTRL     ; loads SPPUCTRL
    lda !PPUCTRL    ; loads PPUCTRL

    lda IODATA1     ; loads IODATA1
    lda !IODATA1    ; loads IODATA1

    sta IODATA1     ; invalid
    sta !IODATA1    ; stores IODATA1 (FRAMECTRL, no shadow)

``nesbrette`` uses square brackets for indirectness and supports nothing else for it, ``ca65hl`` 'Custom Syntax' has been adjsuted to avoid indexing nothing allowing ``jmp inabs`` to return, illegal isntruction support has also been established.

``3. Optimisation``
~~~~~~~~~~~~~~~~~~~

``nesbrette`` is designed register parameterised where possible, meaning if you currently do not wish to corrupt the contents of a register but depend on a feature that by default will use the register in question you can and should pass the free register an argument into the function. If needed, pass ``null`` into the spaces leading up to it in order to not specify something potentially inappropriate. It should be noted that chained instructions in a ``ca65hl`` header for ``if``, ``elseif``, ``for`` or ``while`` do not accept multiple argumenets which may force you to adjust your solution.

Review the function in the documentation as there will be information on how to optimise the use of a specific function. ``nesbrette`` prefers CPU optimisation with reasonable RAM consumption at low code side, but it may be that the solution we provide may not align with your requirements. In such a situation you may ``.delmacro feature`` and begin working on your own to replace it.

Some features benefit from Identity Tables being present, in order to generate one of those use ``table id`` or ``table poly, x`` to generate the needed table. When generating a table you should only ever generate for the spaces needed which is why ``nesbrette`` offers range specification. If you require an interlaced table, ``nesbette`` does not offer support.


.. TODO: look into interlaced tables
.. TODO: see if I can get ca65hl to support comments in macro calls
.. TODO: add link to idtables