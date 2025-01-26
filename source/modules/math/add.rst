``add``
-----------

``add int::src, int::tar`` - Add Memory with Carry
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::


.. note::
    Because I don't expect you to need to do much of ``stz`` I decided that I'd make the rolled solution the default when storing to a ``u24`` or of equal size. If you have PRG/CPU space to unroll then I highly suggest you do as it the rolled solution is three times slower.