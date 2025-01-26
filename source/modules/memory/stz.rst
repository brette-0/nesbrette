``stz``
-------

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