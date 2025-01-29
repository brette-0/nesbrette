.define isallowed(error_level) \
    .xmatch(error_level, allow)

.define isfatal(error_level) \
    .xmatch(error_level, fatal)

.define iserror(error_level) \
    .xmatch(error_level, error)

.define iswarning(error_level) \
    .xmatch(error_level, warn)

.define isout(error_level) \
    .xmatch(error_level, out)

.macro report __error__, __msg__
    .ifblank __error__
        .fatal "REPORT REQUEST FAILED : NO ERROR TO REPORT"
    .endif

    .ifblank __msg__
        .fatal "REPORT REQUEST FAILED : NO MESSAGE TO REPORT"
    .endif

    .if isallowed __error__ 
        .exitmacro
    .endif

    .if isfatal __error__
        .fatal __msg__
        .exitmacro
    .endif

    .if iserror __error__
        .error __msg__
        .exitmacro
    .endif

    .if iswarning __error__
        .warning __msg__
        .exitmacro
    .endif

    .if isout __error__
        .out __msg__
        .exitmacro
    .endif

    
    .fatal .sprintf("Could not handle '%s', ensure that it is configured correctly!", __error__)
.endmacro