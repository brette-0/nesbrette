; tested working
.macro deferror __error__, __level__
    /*
        (nb_error)__error__
        (token)__level__
    */
    .if     .xmatch(__error__, allow)
        __level__ .set 0
    .elseif .xmatch(__error__, out)
        __level__ .set 1
    .elseif .xmatch(__error__, warning)
        __level__ .set 2
    .elseif .xmatch(__error__, error)
        __level__ .set 3
    .elseif .xmatch(__error__, fatal)
        __level__ .set 4
    .else
        __level__ .set __error__
    .endif
.endmacro


; tested working
.macro report __error__, __msg__
    /*
        (nb_error)__error__
        (ca65_str)__msg__
    */
    .ifblank __error__
        .fatal "REPORT REQUEST FAILED : NO ERROR TO REPORT"
    .endif

    .ifblank __msg__
        .fatal "REPORT REQUEST FAILED : NO MESSAGE TO REPORT"
    .endif

    .if     __error__ = 0
        .exitmacro
    .elseif __error__ = 1
        .out __msg__
        .exitmacro
    .elseif __error__ = 2
        .warning __msg__
        .exitmacro
    .elseif __error__ = 3
        .error __msg__
        .exitmacro
    .elseif __error__ = 4
        .fatal __msg__
    .endif
    
    .fatal .sprintf("Could not handle '%s', ensure that it is configured correctly!", __error__)
.endmacro