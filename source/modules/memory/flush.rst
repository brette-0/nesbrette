``flush``
---------

``ldz __gpr__``
""""""""""""""""""""""""""""""""""""""""

``includefrom memory, flush``

.. note::

    .. code-block::

        required:
            (ca65_int)          __gpr__         fails on invalid GPR

        dependacies:
            libcore

    .. code-block::

        ldz                     ; lda #$00                  2b 2c
        ldz xr                  ; ldx #$00                  2b 2c

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

        


`View Source Code on Github <https://github.com/brette-0/nesbrette/blob/main/lib/memory/flush.asm>`_