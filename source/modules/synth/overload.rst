``overload``
------------

The following instructions overload the existing ``6502`` mnemonics, be it enabling illegal instruction support for ``ca65hl/CustomSyntax``, or enabling safety features for ``lax``, fixing the quirks of ``brk``'s ungenerated but thrown-away operand or attatching whole new functions to the unused ``sed`` and ``cld`` there is a world to be gained from mnemonic overloading.

``brk byte, reg: reg, byte`` - Break with Options
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    brk                 ; brk $00
    brk $02             ; brk $02
    brk null            ; brk
    brk $02, yr: xr     ; ldxy PC : brk $02
    brk $02, ar: xr, 3  ; ldax PC : ldy #$03 : brk
    

``bit abs, zp, #imm`` - Bitcheck with idtable Immediate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    bit PPUSTAT
    bit $00

    table id
    bit #$42
    
``sed`` - Convert to BCD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    lda #$10
    sed ; a = $16

``cld`` - Convert from BCD
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    lda #$16
    cld ; a = $10

``bxx`` - Branch Variants with Literal Operand Support
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    beq ahead   ; branch to ahead
    beq $02     ; branch ahead $02

.. warning::
    All instructions below require ``CONSTANTS_NESBRETTE_SYNTH_STACK_ADVANCED`` as they are not required or useful to the majority of even advanded stack use. Seriously evaluate the totality of your circumstances before utilising these.

``lax zp|zpy|abs|absy|inabsx|inabsy|imm`` -Safe Load AX
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: 

    lax #$00    ; lax #$00 (safe)
    lax #$01    ; lda #$00 : tax
    lax #$01, ! ; lax #$01 (unsafe)