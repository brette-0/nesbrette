``Errors``
----------

``InvalidMemoryAddressModeException : fatal``
"""""""""""""""""""""""""""""""""""""""""""""

Through use of the ``libcore.gpr`` module you have attempted to use an non-existant memory address mode. This may be because the value passed into the memory address mode parameter was invalid or that the passed memory address mode was invalid for the required instructions. Do remember that indexed direct storing belongs exclusively to ``sta`` and no other store instruction. 

For example, ``der`` cannot be used with the accumulator as the accumulator has no increment instruction. Similarly ``lda inabs`` doens't work as ``inabs`` belongs only to ``jmp``.


Affects:
    - `LDR <https://www.url.site>`_

``IntereferingRegisterUseException : fatal``
""""""""""""""""""""""""""""""""""""""""""""



Affects:
    - `STZ <https://www.url.site>`_


``ConstantParameterValueException : fatal``
""""""""""""""""""""""""""""""""""""""""""""



Affects:
    - `STR <https://www.url.site>`_

``InvalidInstructionRequestException : fatal``
""""""""""""""""""""""""""""""""""""""""""""""


Affects:
    - `STR <https://www.url.site>`_

