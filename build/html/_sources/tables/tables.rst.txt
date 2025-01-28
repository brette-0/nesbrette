``Tables``
----------

Tables in ``nesbrette`` are created by calling ``tablemaker`` with a ``json`` containing a heirachy of requested tables and then executing the build task. An example is below:

.. code-block:: json

    {
        "code" : {
            "sin" : {
                "thetabits" : 8,
                "width" : 1,
                "shrink" : 1,
            },
            "reciprocal",
            "identity"
        }
        
    }

In order to use the table, ensure that you write:

.. code-block::
    
    .if .lobyte(*)      ; if lobyte nonzero, we are mid-page
        .align 256
    .endif

    __intable__         ; call engine to include table

.. note::
    Note that ``trig.shrink`` reduces the table size by a factor of ``4`` so it's quite Significant and only comes with a small speed penalty. With ``nesbrette`` you can get 32bit precise fractions from this table by setting the ``trig.width`` to ``4`` in which case the full page is loaded by values that can be used for Sine, Cosine, Tangent, Secant, Cotangent and Cosecant.


.. warning::
    Many features currently depend on ``i6502`` and therefore demand an Identity table, until the end of phase 1 there is no intention to offer ``6502/x`` support for any ``i6502/x`` solutions.