``Errors``
----------

``InvalidMemoryAddressModeException : fatal``
"""""""""""""""""""""""""""""""""""""""""""""

Through use of the ``libcore.gpr`` module you have attempted to use an non-existant memory address mode. This may be because the value passed into the memory address mode parameter was invalid or that the passed memory address mode was invalid for the required instructions. Do remember that indexed direct storing belongs exclusively to ``sta`` and no other store instruction. 

For example, ``der`` cannot be used with the accumulator as the accumulator has no increment instruction. Similarly ``lda inabs`` doens't work as ``inabs`` belongs only to ``jmp``.

``IntereferingRegisterUseException : fatal``
""""""""""""""""""""""""""""""""""""""""""""

This will raise when you attempt to complete a feature that has two GPR dependant tasks being requested to share and neither GPU could yield the desired result.

``ConstantParameterValueException : fatal``
""""""""""""""""""""""""""""""""""""""""""""

This will raise when a ``cas65`` preprocessor parameter has a size that is either two small, negative or too simple depending on the context of the caller. Ensure that the values you pass seem appropriate.

``InvalidGeneralPurposeRegister : fatal``
"""""""""""""""""""""""""""""""""""""""""

This will raise when code that takes advantage of ``libcore.qol`` and ``libcore.gpr`` has found your parameters unsatisfying. It normally means that you likely have corrupted your ``gpr`` parameters. 

``InvalidWriteLocationException : fatal``
"""""""""""""""""""""""""""""""""""""""""

This occurs when attempting to perform ``str`` on assumed 'ROM Space', depending on ``LIBCORE_MAPPER`` this will not fire. Just because ``str`` didn't find anything doesn't mean its not there, be careful to write safe code!


``SourceTargetWidthMismatchException : warning``
""""""""""""""""""""""""""""""""""""""""""""""""

This occurs when attempting to perform ``str`` on assumed 'ROM Space', depending on ``LIBCORE_MAPPER`` this will not fire. Just because ``str`` didn't find anything doesn't mean its not there, be careful to write safe code!