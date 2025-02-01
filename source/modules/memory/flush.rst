``flush``
---------

``ldz __gpr__, __lax$__, __laxlevel$__``
""""""""""""""""""""""""""""""""""""""""

``includefrom memory, flush``

.. note::

    .. code-block::

        required:
            (ca65_int)          __gpr__         fails on invalid GPR
        
        optional:
            (ca65_bool)         __lax$__        lax use flag
            (ca65_int | token)  __laxlevel$__   contents validated

        dependacies:
            libcore

    If ``__lax$__`` is defined then ``nesbrette`` will set the use of ``lax`` as the ``__lax$__`` flag. In the majority case in which the flag isn't set, ``nesbrette`` will attempt to evaluate ``UnstableInstructionException`` which will indicate the response for this situation in current scope's context. If none of these values exist then ``nesbrette`` will simply *not* use ``lax`` of course in which it will use only ``6502`` instructions, as ``i6502`` has no advantage here.

    .. code-block::

        ldz                     ; lda #$00                  2b 2c
        ldz xr                  ; ldx #$00                  2b 2c
        ldz (ar + yr)           ; lda #$00 => tay           3b 4c
        ldz (xr + yr)           ; ldx #$00 => ldy #$00      4b 4c
        ldz (ar + xr), 1, allow ; lax #$00                  2b 2c
        ldz (ar + xr + yr)      ; lda #$00 => tax => tay    4b 6c

        ldz (ar + xr + yr), 1, allow
            ; lax #$00 => tay                               3b 4c

    .. warning::
        Do not use unstable instructions if you care about your code *actually* being able to run on the intended hardware. If you simply don't care about this, or think you know better than me here.

    `Source Code <https://github.com/brette-0/nesbrette/blob/main/lib/memory/flush.asm>`_

``stz __target__``
""""""""""""""""""""""""""""""""""""""""

.. note::

    .. code-block::

        required:
            (nb: int, ident: addr) __target__
        
        optional:



        dependacies:
            libcore

    Explanation.

    .. code-block::

        


`View libmem.flush Source Code on Github <https://github.com/brette-0/nesbrette/blob/main/lib/memory/flush.asm>`_