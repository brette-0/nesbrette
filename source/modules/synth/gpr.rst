``gpr``
-------

As interchangable as GPRs tend to be, users will often find themselves with only one GPR accessible and it occassionaly is the one they have already been using. By using instructions that deduce the register, and in turn the opcode, we gain the freedom to use the GPRs non-discriminately. Should the user's project build off ``nesbrette`` in a way that utilies the dynamic nature of the library to produce variant outputs they may choose to support GPR synethetics in their features.

``inr`` - Incrment Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    @timer:
        ldr ar:: tar, inreg
        inr
        cpr inreg:: $30
        bne @timer


``der`` - Decrment Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    @timer:
        ldr ar:: tar, inreg
        der
        bne @timer

``tar`` - Transfer A to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    tar inreg   ; a -> x

``tyr`` - Transfer Y to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    tyr inreg   ; y -> x
``txr`` - Transfer X to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    txr inreg   ; x -> y
``tra`` - Transfer Register to a
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    tra inreg   ; y -> a

``try`` - Transfer Register to Y
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = xr

    try inreg   ; x -> y

``trx`` - Transfer Register to X
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg = yr

    trx inreg   ; y -> x

``trr`` - Transfer Register to Register
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    inreg  = yr
    outreg = xr

    trr yr::xr  ; y -> x


``ldr`` - Load Register
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = ar
    ldr reg::imm, param
    bpl @task

``str`` - Store Register
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = yr
    str reg::wabs. param
    
``cpr`` - Compare Register
~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::
    
    reg = ar
    cpr reg::zp, param
    bne @task

