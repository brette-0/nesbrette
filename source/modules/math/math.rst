``math``
========

All precomputed solutions are of much relative speed and non-constant width operations incur a 'performance threshold' through the Order(sizeof(n)) parameter which may complicate performance evaluation of software in any given state.

``add int::src, int::tar`` - Add Memory with Carry
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    add u32: Score, u32: PentakillScore

``sub int::src, int::tar`` - Subtract Memory with Carry
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sub u32: Timer, u32: FineSecond

``cmult int::src, const`` - Constant Multiply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cmult u32: Damage, 5
            ; supercharge damage

.. note::
    Always use ``cmult`` over ``mult`` when performing multiplication with a deterministic multiplier as ``cmult`` is optimised to the extent it *cannot* be faster with binary long division as all logic is precomputed **unless** you need to multiply against a number larger than what ``ca65`` can handle. It should be known that a negative multiplier does incur a speed and size penalty.

``cdiv int::src, const`` - Constant Divide
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    cdiv u32:: Power, 10
            ; some bomb maybe

.. warning::
    This feature is currently **unimplemented**

``mult int::src, int::tar`` - Multiply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    mult u32: Score, u32: PentakillScore

.. note::
    ``mult`` uses a *very* optimised way of performing higher bit math unrolled for differing widths to reduce the amount of Program ROM wasted in which 'handlers' are defined based on the types if not already existing that perform positional calls into the 'body' that performs the heavy lifting. This means that the less variations of ``mult`` you use (``i8::i8``, ``u8::bu8`` etc..) the more Program ROM you save.

.. note::
   It is **highly** suggested that you use ``MMC5`` or ``Rainbow`` Multiplication registers if your game will perform lots of multiplication as on Hardware the Algorithmi becomes incredibly simplified. 

``sin int::theta`` - Sine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sin u8: Theta

``cos int::theta`` - Cosine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cos u8: Theta


``tan int::Theta`` - Tangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    tan u8: Theta


``sct int::src`` - Secant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sct u8: Theta   ; sec is taken by Set Carry


``cot int::src`` - Cotangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cot u8: Theta

``csc int::src`` - Cosecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    csc u8: Theta

``asin int::theta`` - Arcsine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    asin u8: Theta

``acos int::theta`` - Arcosine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acos u8: Theta


``atan int::Theta`` - Arctangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    atan u8: Theta


``asct int::src`` - Arcsecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    asct u8: Theta

``acot int::src`` - Arcotangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acot u8: Theta

``acsc int::src`` - Arcosecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acsc u8: Theta