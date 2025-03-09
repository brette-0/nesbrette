``theory``
----------

.. note::
    These features *were* in ``nesbrette`` but were removed because of fault or lack of synthesis with the rest of the library. ``nesbrette``'s type machine and QOL is the identity of the library and thus features that offer instability with little to no advantage have no place.

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


``laxi`` - Load A & X with Immediate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    laxi $10    ; a, x => $10

.. warning::
    Do not use ``lax #imm`` as immediate opcode as it is **unstable** with chaotic entropy on Hardware and is not supported in `Mesen2 <https://mesen.ca>`_.