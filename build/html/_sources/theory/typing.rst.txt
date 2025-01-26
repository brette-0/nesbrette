Typing
======

The solution to performing higher bit math on low bit microprocessors always has been either assembled iteration or preprocessor iteration, however, by an exploit in the ``ca65`` string parser I managed to access a field left untouched. Any address may be typed, and type indicated with type symbols, enums and labels. If given ``stz u32:Phrase``, ``u32`` is accessed by methods unseen elsewhere and serially matched against an array of symbols to yield a 'type'.

Types may indicate number bit width, signature and endian. Types may also indicate register or preprocessor element, null exists as signed zero-width. There exists no intentional means to remove typing from ``nesbrette`` as I belive it enhances the experience and yields cleaner code. The type evluation 'operator' and methods are often used to obtain parameters for a type (seen most with regiters, describing an immediate 'affinity')

To avoid frequent type specification, the user may use ``typeas`` which will enable them the ability to pass their parameters without type specification as it will be deduced by the instruction handler. It should be noted that calling instruction bodies may yield a legal response but no performance garauntee is made. It is, however, suggested that type indication be used on type given labels to perform 'casts' between families of types.

.. warning::
    It is impossible to evaluate a collection of typed symbols, ``nesbrette`` will **never** combine collection and type use in a singular token.