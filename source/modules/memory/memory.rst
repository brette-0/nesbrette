``memory``
==========

``MSSbyte int::addr`` - Most Significant Set Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    MSSByte u32: foo
    sta HEALTH_WIDTH
            ; could be used to render only so many hearts

``LSSbyte int::addr`` - Least Significant Set Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    LSSByte u32: foo
    sta USED_INDEX
            ; find first 'used' byte

``MSUbyte int::addr`` - Most Significant Unset Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    MSUByte u32: foo
    sta UNUSED_INDEX
            ; find last 'free' byte

``LSUbyte int::addr`` - Least Significant Unset Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    LSUByte u32: foo
    sta UNUSED_INDEX
            ; find first 'free' byte

``compare int::src, int::tar`` - Compare Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    compare u32: foo, u32: bar
    beq @same   ; same as cmp u8: foo


.. warning::
    This code has not been tested for some time, expect catastrophic failure.

``eval int::src`` - Evaluate for CPU Flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    eval i32: Addr
    bmi @minus  ; functions like lda i8: Addr

.. warning::
    This code has not been tested for some time, expect catastrophic failure.

``mempcy int::src, int::tar`` - Copy out Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    memcpy u64:: Inputs, u64:: LastInputs
            ; to check if buttons where held or pressed
.. note::
    This task is unrolled as it is expected to be needed often as ``nesbrette`` avoids using indirect memory address modes where possible.

``stz int::addr`` - Store Zeroes (Flush)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    ; stz int::addr, reg::reg?, value?, unroll? 
    ; 6c < x <= 116c
    ; 5b < x <= 26b

    stz u32: Score      ; reset score
    temp .set Score + 2
    stz u16: temp       ; reset high bytes of score
    .del temp

    stz u24: Name, null::null, $00, 1
        ; wipe Name array with any registers and unroll

    stz u64: Enemies, ar::yr, $ea
        ; no unroll, use registers A and Y to wipe enemies to enemy $ea (empty)

.. note::
    Because I don't expect you to need to do much of ``stz`` I decided that I'd make the rolled solution the default when storing to a ``u24`` or of equal size. If you have PRG/CPU space to unroll then I highly suggest you do as it the rolled solution is three times slower.