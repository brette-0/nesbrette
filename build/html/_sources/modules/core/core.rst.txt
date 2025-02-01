``core``
========

To refer to how to use ``nesbrette`` core features, please refer to `tutorials <https://nesbrette.readthedocs.io/en/latest/index.html>`_ .Use of the following methods will not yield immediate benefit, the ``core`` member set is designed to clarify and optimise nesbrette engine behaviors and therefore should only really be used for advanced expansions of ``nesbrette``.

``itype label:`` - Identify Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__
        
        paramtype = itype __param__
        .if (isnum paramtype)
            .out "It is a Number!"
        .else
            .out "It is not a Number!"
        .endif
    .endmacro
    


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
    
``label typed:`` - Access Parameter Label
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        .out .sprintf("%d", label __param__)
    .endmacro

``ilabel typed:`` - Identify Parameter Label
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__
        .local temp

        temp = ilabel __param__
        
        .if temp > $8000
            .fatal "Cannot store to ROM"
        .else
            sta temp
        .endif
    .endmacro

Yields the parameter label Identify, must be stored before use. Retains Scope of caller and scope lexis cannot be passed down because ``.ident`` (native ``ca65`` preprocessor directive) cannot identify scopes and is, therefore, scope constrained.

``dedtype int`` - Deduce Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda VRAM_BUFFER_LEN
    clc
    adc #(dedtype Score)
    sta VRAM_BUFFER_LEN

This function fetches the type assigned to the token passed. The token can always be evluated as ``t_{token}`` and should always have the same scope as the target token.

``isnum int`` - Is Type Numerical?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (isnum Score)
        .out "Score is number, passing..."
    .else
        .fatal "Failed : Incorrect Type"
    .endif


``isconst int`` - Is Type Preprocesor Constant?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (isconst Score)
        .out "Score is Constant, passing..."
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


``setireg int`` - Set Indexing Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    thisireg = setireg __param__

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

``index array, int`` - Index Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define MyArray {2, 5, 7}

    .out .sprintf("%d", (index MyArray, 1))

``append array, token`` - Append Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define Array {2, 5, 7}
    append Array, 5

``isArray token`` - Is Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define MyArray {2, 5, 7}

    .if (isArray MyArray)
        .out "Woah, that's sure a lot of numbers"
    .else
        .out "boo, too few numbers"
    .endif

.. warning::
    Expect vast quantities of logical/syntax errors when using preprocessor arrays as they were not designed mutable and poor handling of them is likely to cause problems. I wouldn't (unless you truly believe in your skills) form a dependancy on these at your backend for threat of catastrophic code debt.

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

``insert_header`` - Insert Header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .segment "HEADER"
    insert_header

.. note::
    The specification used with ``insert_header`` is `iNES <https://www.nesdev.org/wiki/NES_2.0>`_ 2. ``insert__header`` is the define that indicates if ``core`` has been included. There is no reason to use any other format than ``iNES2`` as of writing this. To fully use ``insert_header`` the user will need to modify the ``header`` constants in ``template/{scope}/constants.asm``.

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


``ldr gpr: mode`` - Load Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = ar
    ldr reg::imm, param
    bpl @task

``str gpr: mode`` - Store Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = yr
    str reg::wabs. param

``rcp typed:`` - Register Compare
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = ar
    rcp reg::zp, yr     ; needs i6502
    bne @task
    rcp reg::zpx, memory
    bne @task