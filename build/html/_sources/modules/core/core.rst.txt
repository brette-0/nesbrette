``core``
========

``itype label: param`` - Identify Type
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
    
``eindex int: addr, int, bool`` - Endian Index
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda eindex Health, 0, endian Health
    
``type type: label`` - Type of
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        paramtype = itype __param__
            ; this must be stored (gc issue?)
    .endmacro
    
``typeval int`` - Value Segment from Type
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        paramtype = itype __param__
        .if (typeval paramtype) = 8
            .warning "64bit Math is Expensive!"
        .endif
    .endmacro
    
``typeas label, int`` - Allocate Deductible Type Define
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    Score = $0300
    typeas Score, u32
    
``label type: label`` - Access Parameter Label
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .macro MyMacro __param__

        .out .sprintf("%d", label __param__)
    .endmacro

``ilabel type: label`` - Identify Parameter Label
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

``width`` - Width of
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda VRAM_BUFFER_LEN
    clc
    adc #(width Score)
    sta VRAM_BUFFER_LEN

``isnum`` - Is Type Numerical?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (isnum Score)
        .out "Score is number, passing..."
    .else
        .fatal "Failed : Incorrect Type"
    .endif


``isconst`` - Is Type Preprocesor Constant?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (isconst Score)
        .out "Score is Constant, passing..."
    .else
        .fatal "Failed : Incorrect Type"
    .endif


``detype`` - Isolate Type Algorithmically
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    temp .set 0
    detype __param__, temp
            ; this is really the only possible way

    .if temp ... 

.. note::
    ``detype`` does **not** like untyped values, please validate against untyped tokens before attempting to pass them to a typed field.


``null_coalesce int`` - Null Coalesce
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if __param__ = null
        __param__ .set 10
    .endif

``is_null int`` - is Null
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (is_null __param__)
        .fatal "NullReferenceException said C sharp"
    .endif


``setreg int, label`` - Set Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    setreg __param__, __out__


``setireg int, label`` - Set Indexing Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    setireg __param__, __index__


``confined int, int`` - If Confined
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    ArrayStart = $3fe
    typeas ArrayStart, u32

    .if !(confined ArrayStart)
        .fatal "Cannot Mitigate Page Overlap"
    .endif

``index array, int`` - Index Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define MyArray {2, 5, 7}

    .out .sprintf("%d", (index MyArray, 1))

``append array, token`` - Append Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define Array {2, 5, 7}
    append Array, 5

``isArray token`` - Is Array
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .define MyArray {2, 5, 7}

    .if (isArray MyArray)
        .out "Woah, that's sure a lot of numbers"
    .else
        .out "boo, too few numbers"
    .endif

``ispo2 int`` - Is Power of two?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .if (ispo2 __param__)
        ; optimized mode
    .else
        ; suboptimal mode
    .endif

``abs int`` - Absolute
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #(abs ExtremeValue)

``insert_header`` - Insert Header
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    .segment "HEADER"
    insert_header

.. note::
    The specification used with ``insert_header`` is `iNES <https://www.nesdev.org/wiki/NES_2.0>`_ 2.