Label Stack
===========

RAM management is a *crucial* element of NESDev, a common practice is to use ``.res Label, Length`` but this method prevents the user from choosing where exactly the data is stored in CPU Space and doesn't help with the case of handling temporary memory.  With the current method the user may choose from: Hardcoding targets for certain functions, or using integer literals and dedicated an area of RAM to temp usage.

Unfortunately both are terribly impractical, the former is bad because it's simply wastes RAM by not sharing the temorary space between functions and the latter is terrible because temporary functions run the risk of overwriting the other's contents if a complex hierachy of features are used.

``nesbrette`` solves this in a *fairly* classy way by creating a system in which a preprocessor function will allocate an offset in temp ram to a label as it's being evaluated. At the end of a feature that uses RAM, a feature is also used to de-allocate the label from RAM to ensure that RAM is only marked as used where the function has lifetime.

Because of how preprocessor works, it seems reasonable that zero fragmentation will occur with no loss of functionality or loss of performance by any metric from this method. This is because ``nesbrette`` provides the features ``malloc`` and ``dealloc`` to log when ram has a consistent semantic within the context.