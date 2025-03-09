``stack``
---------

Typically the stack is used by interrupts, calling, returning and pushing temporaries to free up the Accumolator, but there exists methodologies, optimisations and features of the 6502 that can be created with clever stack manipulation.

``ldstat`` - Load CPU Status Flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ldstat
    cmp #bf     ; break flag
    beq @handler; handle brk IRQs within IRQ vector
    

``ststat`` - Store CPU Status Flags
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ldstat
    ora #bf    ; enable break for next IRQ
    ststat      ; apply changes
    
``callback`` - Allocate Callback
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    @body:      ; example 'foo' function
        lda #$10
        sta Example
        rts

    @main:
        jsr @body
                ; justifies 'rts' at @body
        bne @main
                ; justifies calling @body as logic cannot be simplified
        callback @main
                ; pushes @main onto stack for next return
        jmp @body
                ; jumps to target, returns to prevent stack corruption

.. note::
    There are situations in which simply making the called function jump instead of return can prevent this complication, however, this is not true for all circumstances making this very useful.
``lds`` - Load Register with Stack Pointer at Stack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    lds         ; load stack at SP
    sta $00
    lds 1, 1    ; load (stack + 1) at SP
    sta $01
    jmp ($0000) ; jump to caller

``sts`` - Store Register Value at Stack Pointer in Stack
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; assume cycle-timed irq counter expiry
    lda #.hibyte $addr
    sts 1
    lda #.lobyte $addr
    sts 2, 1     ; modify return address from interrupt
    rti

.. warning::
    All instructions below require ``CONSTANTS_NESBRETTE_SYNTH_STACK_ADVANCED`` as they are not required or useful to the majority of even advanded stack use. Seriously evaluate the totality of your circumstances before utilising these.

``des`` - Decrement Stack at Stack Pointer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; assume $100, SP holds (target + 1)
    des
    pla         ; a => target

``ins`` - Increment Stack at Stack Pointer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    ; assume $100, SP holds (target - 1)
    ins
    pla         ; a => target
.. note::
    It should be noted that ``irol`` is twice as fast as ``iror`` and this cannot be helped.

``cps`` - Compare Against Stack at Stack Pointer
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    lda #$80
    cps
    bcs @negative
                ; handle negative temps differently, preserve Accumolator freedom