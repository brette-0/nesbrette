``core``
========

To refer to how to use ``nesbrette`` core features, please refer to `tutorials <https://nesbrette.readthedocs.io/en/latest/index.html>`_ .Use of the following methods will not yield immediate benefit, the ``core`` member set is designed to clarify and optimise nesbrette engine behaviors and therefore should only really be used for advanced expansions of ``nesbrette``.

``signed token`` - Query Sign Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__
        
        paramtype = itype __param__
        .if signed paramtype
            .warning "Signed operation is slower!"
        .endif
    .endmacro

``endian token`` - Query Sign Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__
        
        paramtype = itype __param__
        .if endian paramtype
            .warning "Big Endian operation is inappropriate!"
        .endif
    .endmacro
    
``eindex int:, int`` - Endian Index
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda eindex Health, 0
    
``type type: label`` - Type of
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        paramtype = itype __param__
            ; this must be stored (gc issue?)
    .endmacro
    
``typeval int`` - Value Segment from Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        paramtype = itype __param__
        .if (typeval paramtype) = 8
            .warning "64bit Math is Expensive!"
        .endif
    .endmacro
    
``typeas label, type`` - Allocate Type Define
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    Score = $0300
    typeas Score, u32
    
``dedtype int`` - Deduce Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda VRAM_BUFFER_LEN
    clc
    adc #(dedtype Score)
    sta VRAM_BUFFER_LEN

This function fetches the type assigned to the token passed. The token can always be evluated as ``t_{token}`` and should always have the same scope as the target token.

``isdecimal int`` - Is Type Decimal?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (isdecimal Score)
        .out "Score is Decimal, passing..."
    .else
        .fatal "Failed : Incorrect Type"
    .endif


``detype type?: token`` - Decode Typing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    temp .set 0
    detype __param__, temp
            ; this is really the only possible way

    .if temp ... 

.. note::
    ``detype`` does **not** like untyped values, please validate against untyped tokens before attempting to pass them to a typed field.


``null_coalesce int`` - Null Coalesce
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if __param__ = null
        __param__ .set 10
    .endif

Perhaps the one feature I really like about ``C#`` is how it handles ``null`` on the high level, so I decided that `null-coalescence <https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/null-coalescing-operator>`_ should be created for ``nesbrette`` as the existence of ``null`` was already designed with type defaulting in mind.

``is_null int`` - is Null
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (is_null __param__)
        .fatal "NullReferenceException said C sharp"
    .endif

``null`` is define as type '``i0``' in which typelessness is '``u0``', it can also be evaluated by comparing it to ``(1 << 31)``.

``setreg int`` - Set Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisreg = setreg __param__

``setmreg int`` - Set Multiple Registers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisreg = setreg __param__

``setmam int`` - Set Memory Address Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisreg = setreg __param__

``mamreg int`` - Indexing Register of Memory Address Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisreg = setreg __param__


``setireg int`` - Set Indexing Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisireg = setireg __param__

.. note::
    The above ``setreg`` and ``setireg`` expects unvalidated parameters to error check against the register indicator enums. It should be noted that these operations do not have contextual memory for prior calls within scope and therefore will not yield an error if two registers are requested for differing operations. The function will return ``null`` for GPR indicating failure, response is offloaded to handler.

``ralloc out, int, int`` - Allocate Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    ralloc MyReg, ThisReg, ThatReg
        ; loads MyReg with Enum for the register that isnt either ThisReg or ThatReg

.. note::
    The above ``setreg`` and ``setireg`` expects unvalidated parameters to error check against the register indicator enums. It should be noted that these operations do not have contextual memory for prior calls within scope and therefore will not yield an error if two registers are requested for differing operations. The function will return ``null`` for GPR indicating failure, response is offloaded to handler.

``confined int, int`` - If Confined
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    ArrayStart = $3fe
    typeas ArrayStart, u32

    .if !(confined ArrayStart)
        .fatal "Cannot Mitigate Page Overlap"
    .endif

Simply encaging your code within a page can reduce the amount of updates needed, especially if using ``SMC`` - inevitably page confinement imposes an 'artificial' limit to the member's capability - but a good solution often can exceed typical demand while obeying page confinement which overall leads to more optimised code.


``ispo2 int`` - Is Power of two?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (ispo2 __param__)
        ; optimized mode
    .else
        ; suboptimal mode
    .endif

``abs int`` - Absolute
~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #(abs ExtremeValue)

``inr gpr`` - Incrment Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    @timer:
        ldr ar:: tar, inreg
        inr
        rcp inreg:: $30
        bne @timer


``der gpr`` - Decrment Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    @timer:
        ldr ar:: tar, inreg
        der
        bne @timer

``tar gpr`` - Transfer A to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    tar inreg   ; a -> x

``tyr gpr`` - Transfer Y to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    tyr inreg   ; y -> x

``txr gpr`` - Transfer X to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    txr inreg   ; x -> y

``tra gpr`` - Transfer Register to a
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    tra inreg   ; y -> a

``try gpr`` - Transfer Register to Y
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    try inreg   ; x -> y

``trx gpr`` - Transfer Register to X
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    trx inreg   ; y -> x

``trr gpr: gpr`` - Transfer Register to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg  = yr
    outreg = xr

    trr yr::xr  ; y -> x


``ldr mode: reg, int, error`` - Load Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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


``str mode: reg, int, error, error`` - Store Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

``cpr mode: reg, int, error`` - Compare Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    required:
        (mode: gpr)         __reg_mode__    gpr and mode must be valid
        (ca65_int)          __value__       Must be within u16 range

    optional:
        (nb_error)          __cpre$__       must be valid error level

    dependacies:
        libcore

Compares any register against a memory location with a specified memory address mode. This instruction *may* throw a 
``ConstantParameterRangeException`` which indicates the desired source pointer cannot be accesed entirely by the desired opcode dicated by the memory address mode. 

.. code-block::

    cpr wabs: ar, $ea 
    cpr  zpx: yr, $ea, warnings

``contains int, int, int, int, int...`` - Contains xmatch
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    required:
        (ca65_int)          __item__        Value to compare against rightside
        (ca65_int)          {x}_            100 labels to comparea against

    dependacies:
        libcore

Recursively compares up to 100 times using ``.xmatch`` with context against item and sets context to ``null`` on match.

.. code-block::

    contains Secret, UnsafeAreas