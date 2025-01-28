``math``
========

All precomputed solutions are of much relative speed and non-constant width operations incur a 'performance threshold' through the Order(sizeof(n)) parameter which may complicate performance evaluation of software in any given state.

``add int:, int:`` - Add Memory with Carry
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    add u32: Score, u32: PentakillScore

``sub int:, int:`` - Subtract Memory with Carry
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sub u32: Timer, u32: FineSecond

``cmult int:, int`` - Constant Multiply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cmult u32: Damage, 5
            ; supercharge damage

.. note::
    Always use ``cmult`` over ``mult`` when performing multiplication with a deterministic multiplier as ``cmult`` is optimised to the extent it *cannot* be faster with binary long division as all logic is precomputed **unless** you need to multiply against a number larger than what ``ca65`` can handle. It should be known that a negative multiplier does incur a speed and size penalty.

``cdiv int:, int`` - Constant Divide
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    cdiv u32:: Power, 10
            ; some bomb maybe

.. warning::
    This feature is currently **unimplemented**

``mult int:, int:`` - Multiply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    mult u32: Score, u32: PentakillScore

.. note::
    ``mult`` uses a *very* optimised way of performing higher bit math unrolled for differing widths to reduce the amount of Program ROM wasted in which 'handlers' are defined based on the types if not already existing that perform positional calls into the 'body' that performs the heavy lifting. This means that the less variations of ``mult`` you use (``i8::i8``, ``u8::bu8`` etc..) the more Program ROM you save.

``div int:, int:`` - Multiply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    div u32: Damage, u16: EnemyArmour

.. warning::
    This hasn't been developed yet.

``sin gpr`` - Sine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sin

``cos gpr`` - Cosine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cos


``tan gpr`` - Tangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    tan


``sct gpr`` - Secant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    sct         ; sec is taken by Set Carry


``cot gpr`` - Cotangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    cot

``csc gpr`` - Cosecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    csc

``asin gpr`` - Arcsine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    asin

``acos gpr`` - Arcosine of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acos


``atan gpr`` - Arctangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    atan


``asct gpr`` - Arcsecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    asct

``acot gpr`` - Arcotangent of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acot

``acsc gpr`` - Arcosecant of Theta
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

    acsc

.. note::
    For obvious reasons all ``trig`` functions require either a Sine or Cosine Table that is at least ``64`` bytes in size indexed by angles that must be 8bit binary degrees. It is recommended that you include the table that belongs to the instruction you use most. 

    Choosing to use both ``cos`` with only a Sine table will only incur minute slowdown, but compared to the speed of the fetching ``sin`` with a Sine table may be considerable. It should be noted that all trigonometric indentities that are reciprocals or defined by a combination of Sine and Cosine will be fetched with additional slowdown unless their tables is also included.

    It should also be noted that Arc Identities require the fraction to be passed as it was fetched (Multiplied by ``256``) and will return the angle 'theta' in response in an 8bit binary degree respsonse.