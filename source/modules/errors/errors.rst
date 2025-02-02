``Errors``
-----------

``UnstableInstructionException : fatal``
""""""""""""""""""""""""""""""""

While ``nesbrette`` does support use of Illegal instructions, we only want to use the *safe* ones and only care to use the *useful* ones. Instructions like ``xaa`` and ``lax #imm`` are not much use at all and even instructions with safety nets like ``shy`` have little utility. NES Developers may feel inclinde to avoid illegal instructions entirely, however, ``nesbrette`` will *always* use them where its safe and useful, never will ``nesbrette`` use an unstable instruction without user specification.

If you are seeing this in your code, its because the feature you are trying to use is attempting to use an unstable instruction. If you did not expect this, configure your call for stable instructions.


Affects:
    - `LDZ <https://www.url.site>`_

``InvalidMemoryAddressModeException : fatal``
""""""""""""""""""""""""""""""""

Through use of the ``libcore.gpr`` module you have attempted to use an non-existant memory address mode. This may be because the value passed into the memory address mode parameter was invalid or that the passed memory address mode was invalid for the required instructions. Do remember that indexed direct storing belongs exclusively to ``sta`` and no other store instruction. 

For example, ``der`` cannot be used with the accumulator as the accumulator has no increment instruction. Similarly ``lda inabs`` doens't work as ``inabs`` belongs only to ``jmp``.


Affects:
    - `LDR <https://www.url.site>`_