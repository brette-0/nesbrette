``theory``
==========
   
``Includer``
~~~~~~~~

``nesbrette`` allows you to include modules with a basic ``include`` keyword, whats better is features that depend on certain modules can also include modules. This means the user needs only specify once what they need and then may use it to its fullest extent without needing to worry about its dependacies. ``nesbrette`` will throw warnings if a module requires a depenancy and it will notify you of what depenancies it is including as it does so, this warning can also be muted.

This feture is entirely compatible with ``ca65`` lexical scopes, and while macros and defines don't obey scope, the targets they have certainly will and therefore use of instructions that depend on an assembled code body will fail if said code body hasn't been assembled available within that lexical scope. This is different to ``global`` members which do not require assembled bodies to interact with and instead are completely macro or define based.

``Typing``
~~~~~~

The solution to performing higher bit math on low bit microprocessors always has been either assembled iteration or preprocessor iteration, however, by an exploit in the ``ca65`` string parser I managed to access a field left untouched. Any address may be typed, and type indicated with type symbols, enums and labels. If given ``stz u32:Phrase``, ``u32`` is accessed by methods unseen elsewhere and serially matched against an array of symbols to yield a 'type'.

Types may indicate number bit width, signature and endian. Types may also indicate register or preprocessor element, null exists as signed zero-width. There exists no intentional means to remove typing from ``nesbrette`` as I belive it enhances the experience and yields cleaner code. The type evluation 'operator' and methods are often used to obtain parameters for a type (seen most with regiters, describing an immediate 'affinity')

To avoid frequent type specification, the user may use ``typeas`` which will enable them the ability to pass their parameters without type specification as it will be deduced by the instruction handler. It should be noted that calling instruction bodies may yield a legal response but no performance garauntee is made. It is, however, suggested that type indication be used on type given labels to perform 'casts' between families of types.

.. warning::
    It is impossible to evaluate a collection of typed symbols, ``nesbrette`` will **never** combine collection and type use in a singular token.

``Warning``
~~~~~~~

When developing ``nesbrette`` I elected to use a ``warning`` system that could be suppressed optionally. This is because I often find that the warnings I am provided by libraries, or IDEs hold some merit but occassionaly hallucinate or do not exempt a safe use case. Considering this, I decided that all possible warnigns can be silenced, or turned into errors with ``pedantic`` mode, issues may become pedantic or suppressed by defining constants *or* by pasing suppression/pedantic as a parameter.

``Call Handler``
~~~~~~~~~~~~~~~~

Modern programming languages allow functions to share the same name as long as they use different parameter types. ``nesbrette`` is similar in the regard that it promotes 'templating' by simply enabling type detection to exist. How a call handler handles its parameters is case specific, typically integer types are treated unanimously whereas register types may incur seperate logic. 

``Memory Address Modes``
~~~~~~~~~~~~~~~~~~~~~~~~

On the NES there exists a few memory address modes that ``nesbrette`` has enums for. These enums are used in much of the library to ensure that the correct register is being used, or to enable indexing by checking the parameters as a collection. The main reason is to ensure that some instructions are assembled in the intended address mode. For example, some code should *only* use zero page memory for its speed, or perhaps you need to force usage of absolute even for addresses within the zero page for code alignment. 

.. build tasks