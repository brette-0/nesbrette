``Syntax``
----------------------

.. write about different kinds of safety

``ins PPUSTAT`` - Access (with Shadow?)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    sta PPUCTRL
    sta SPPUCTRL

    ; read
    lda PPUCTRL

``ins ##ZP`` - Access Mirror
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    sta ##$00
    ; read
    lda ##foo

``ins !IRQSTATUS`` - Access Erroneous (with Shadow?)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str IRQSTATUS   ; read only needs no shadow reg

    str PPUCTRL
    str SPPUCTRL    ; weird to use ! here, but shadow is needed

    ; read
    ldr IRQSTATUS   ; read only needs no ! but works

    ldr SSPUCTRL    ; loads shadow if needed

``ins *PPUCTRL`` - Access without Shadow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str PPUCTRL

    ; read
    ldr PPUCTRL


``ins tar, r`` - Indexed Access R
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str PPUCTRL, y

    ; read
    ldr PPUCTRL, y 

``ins !tar, r`` - Indexed Access Forbidden R
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str PPUCTRL, y

    ; read
    ldr PPUCTRL, y 

``ins tar[r]`` - Indexed Access R with ca65hl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str PPUCTRL, r

    ; read
    ldr PPUCTRL, r 

``ins !tar[r]`` - Indexed Access Forbidden R with ca65hl
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str PPUCTRL, r

    ; read
    ldr PPUCTRL, r 

``ins [tar]`` - Indirect Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 
    
    ldy #$00
    ins [tar], y

``ins [tar, x]`` - Indexed Indirect Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 
    
    ; store
    str [PPUCTRL, x]

    ; read
    ldr [PPUCTRL, x]

``ins [tar, y]`` - Indirect Indexed Access
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; store
    str [PPUCTRL], y

    ; read
    ldr [PPUCTRL], y