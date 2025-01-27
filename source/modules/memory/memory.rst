``memory``
==========

The majority of higher bit math functions is dealing with memory due to thin buses and registers. Analysing memory often can yield circumstantial optimisations, copying memory often is faster than indirectly fetching new targets and a great way to evade code debt is to utilise the well written ``juggle`` method.

``mssbyte int:`` - Most Significant Set Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    mssbyte u32: foo
    sta HEALTH_WIDTH
            ; could be used to render only so many hearts

``lssbyte int:`` - Least Significant Set Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lssbyte u32: foo
    sta USED_INDEX
            ; find first 'used' byte

``msubyte int:`` - Most Significant Unset Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    msubyte u32: foo
    sta UNUSED_INDEX
            ; find last 'free' byte

``lsubyte int:`` - Least Significant Unset Byte
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lsubyte u32: foo
    sta UNUSED_INDEX
            ; find first 'free' byte

.. note::
    Situations in which there are many calls to check the Most/Least Significant Set/Unset bit of the same valule, declaring a function like so
    
    .. code-block::
        
        @lssu_enemies:
            lsubyte u32: Enemies
            rts

        jsr @lssu_enemies   ; call to get value

``compare int:, int:`` - Compare Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    compare u32: foo, u32: bar
    beq @same   ; same as cmp u8: foo


.. warning::
    This code has not been tested for some time, and has been modified as of late, expect catastrophic failure.

``eval int:`` - Evaluate for CPU Flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    eval i32: Addr
    bmi @minus  ; functions like lda i8: Addr

.. warning::
    This code has not been tested for some time, and has been modified as of late, expect catastrophic failure.

``mempcy int:, int:`` - Copy out Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    memcpy u64:: Inputs, u64:: LastInputs
            ; to check if buttons where held or pressed
.. note::
    This task is unrolled by default as it is expected to be needed often as ``nesbrette`` avoids using indirect memory address modes where possible.

``juggle {tokens}, int:`` - Juggle Memory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    juggle {Addr1, Addr2}, w_Addr1: Temp
.. note::
    ``juggle`` depends on type deduction and cannot be type indicated within the array. The Temporary can be anywhere and should have enough memory for the final element to be passed into the first.

.. warning::
    This code hasn't been tested catastrophic results are expected.


``stz int:`` - Store Zeroes (Flush)
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

.. warning::
    This code hasn't been tested catastrophic results are expected.

``ldz gpr?`` - Load Zero
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    ldz
    @empty:
        sta Buffer, x
        dex
        bne @empty

.. warning::
    This code hasn't been tested catastrophic results are expected.


``mssb a | int:`` - Most Significant Set Bit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #$02
    mssb    ; a => 2
    mssb a  ; a => 2

    mssb u:32 Score
            ; a => MSSB u32: Score

.. warning::
    This code hasn't been tested catastrophic results are expected.


``lssb a | int:`` - Least Significant Set Bit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #$02
    lssb    ; a => 2
    lssb a  ; a => 2

    lssb u:32 Score
            ; a => LSSB u32: Score

.. warning::
    This code hasn't been tested catastrophic results are expected.


``msub a | int:`` - Most Significant Unset Bit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #$02
    msub    ; a => 2
    msub a  ; a => 2

    msub u:32 Score
            ; a => MSUB u32: Score

.. warning::
    This code hasn't been tested catastrophic results are expected.


``lsub a | int:`` - Least Significant Unset Bit
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lda #$02
    lsub    ; a => 2
    lsub a  ; a => 2

    lsub u:32 Score
            ; a => LSUB u32: Score

.. warning::
    This code hasn't been tested catastrophic results are expected.


``lshift a | int:`` - Left Shift
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    lshift 2    ; a => (a << 2)
    lshift u32: Out, 13
                ; u32: Out <<= 13

.. warning::
    This code hasn't been tested catastrophic results are expected.

``rshift a | int:`` - Right Shift
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    rshift 2    ; a => (a >> 2)
    rshift u32: Out, 13
                ; u32: Out >>= 13

.. warning::
    This code hasn't been tested catastrophic results are expected.