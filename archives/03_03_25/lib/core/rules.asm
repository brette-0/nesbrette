; rules : Complex CPU Access rule enforcer

.macro SYSREAD __target__, __index__
    .local resp, aets, aea, aira

    aets .set null
    aea  .set null
    aira .set null

    deferror aats, warning
    deferror aea,  error
    deferror aira, error        ; indexed register locations

    .ifdef ::PROFILE_AllowAccessToStack
        deferror aats, ::PROFILE_AllowAccessToStack
    .endif

    .ifdef PROFILE_AllowAccessToStack
        deferror aats, PROFILE_AllowAccessToStack
    .endif
    
    .ifdef ::PROFILE_AllowErroneousAccess
        deferror aea, ::PROFILE_AllowErroneousAccess
    .endif

    .ifdef PROFILE_AllowErroneousAccess
        deferror aea, PROFILE_AllowErroneousAccess
    .endif

    .ifdef ::PROFILE_AllowIndexedRegisterAccess
        deferror aira, ::PROFILE_AllowIndexedRegisterAccess
    .endif

    .ifdef PROFILE_AllowIndexedRegisterAccess
        deferror aira, PROFILE_AllowIndexedRegisterAccess
    .endif

    .if (.hibyte(__target__) & %1110_0111) = $01
        report aats, "string"
    .endif

    resp .set 0
    contains resp, __target__, LIBCORE_STRICT_WRITEONLY
    .if resp
        .fatal "string"
    .endif

    resp .set 0
    contains resp, __target__, LIBCORE_WRITEONLY#
    
    .if (__target__ >= $2000) && (__target__ < $4000); && (!.blank(__index__))
        ; Throw error on indexed access
    .endif

    .if resp && (!overrule)
        ; check if there exists a shadow register
        report aea, "string"
    .endif

    ; even if __target__ suits a read, indexes may trigger dummy access
    ; thus there is an additional warning for this
    .ifnblank __index__
        .if resp
            report aira, "string"
        .endif
    .endif

    .if (__target__ >= $4000) && (__target__ <= $4014)
        report aea, "string"
    .endif

    .if __target__ & $fff0 = $4020 && .xmatch(LIBCORE_ROM, nes)
        report aea, "string"
    .endif
.endmacro

.macro SYSWRITE __target__, __index__
    .local resp

    deferror aats, warning
    deferror aea,  error
    deferror aira, error        ; indexed register locations

    .ifdef ::PROFILE_AllowAccessToStack
        deferror aats, ::PROFILE_AllowAccessToStack
    .endif

    .ifdef PROFILE_AllowAccessToStack
        deferror aats, PROFILE_AllowAccessToStack
    .endif
    
    .ifdef ::PROFILE_AllowErroneousAccess
        deferror aea, ::PROFILE_AllowErroneousAccess
    .endif

    .ifdef PROFILE_AllowErroneousAccess
        deferror aea, PROFILE_AllowErroneousAccess
    .endif

    .ifdef ::PROFILE_AllowIndexedRegisterAccess
        deferror aira, ::PROFILE_AllowIndexedRegisterAccess
    .endif

    .ifdef PROFILE_AllowIndexedRegisterAccess
        deferror aira, PROFILE_AllowIndexedRegisterAccess
    .endif

    TODO: Depend on LIBCORE::BUSCONFLICT

    .if (.hibyte(__target__) & %1110_0111) = $01
        report aats, "string"
    .endif

    resp .set 0
    contains resp, __target__, LIBCORE_STRICT_READONLY
    .if resp
        .fatal "string"
    .endif

    resp .set 0
    contains resp, __target__, LIBCORE_READONLY
    .if resp && (!overrule)
        ; check if there exists a shadow register
        report aea, "string"
    .endif

    .if .xmatch(LIBCORE_ROM, nes)
        report aea, "string"
    .else
        .if __target__ & $fff0 = $4030
            report aea, "string"
        .endif
        ; $403x is read only
    .endif
.endmacro

.macro rule __rule__, __param0__
    ; no variables are local to the macro, but the to the macro caller
    .if     .xmatch(__rule__, AllowAccessToStack)
        .ifndef __param0__
            deferror PROFILE_AllowAccessToStack, allow
        .elseif .xmatch(__param0__, -)
            deferror PROFILE_AllowAccessToStack, error
        .elseif .xmatch(__param0__, +)
            deferror PROFILE_AllowAccessToStack, allow
        .else
            deferror PROFILE_AllowAccessToStack, __param0__
        .endif
    .elseif .xmatch(__rule__, AllowErroneousAccess)
        .ifndef __param0__
            PROFILE_AllowErroneousAccess .set allow
        .elseif .xmatch(__param0__, -)
            PROFILE_AllowErroneousAccess .set error
        .elseif .xmatch(__param0__, +)
            PROFILE_AllowErroneousAccess .set allow
        .else
            deferror PROFILE_AllowErroneousAccess, __param0__
        .endif
    .elseif .xmatch(__rule__, AllowIndexedRegisterAccess)
        .ifndef __param0__
            PROFILE_AllowIndexedRegisterAccess .set allow
        .elseif .xmatch(__param0__, -)
            PROFILE_AllowIndexedRegisterAccess .set error
        .elseif .xmatch(__param0__, +)
            PROFILE_AllowIndexedRegisterAccess .set allow
        .else
            deferror PROFILE_AllowIndexedRegisterAccess, __param0__
        .endif
    .elseif .xmatch(__rule__, AllowSingleInstructionSerialAccess)
        .ifndef __param0__
            AllowSingleInstructionSerialAccess .set allow
        .elseif .xmatch(__param0__, -)
            AllowSingleInstructionSerialAccess .set error
        .elseif .xmatch(__param0__, +)
            AllowSingleInstructionSerialAccess .set allow
        .else
            deferror AllowSingleInstructionSerialAccess, __param0__
        .endif
    .elseif .xmatch(__rule__, AllowSingleInstructionSerialAccess)
        .ifndef __param0__
            AllowSingleInstructionSerialAccess .set allow
        .elseif .xmatch(__param0__, -)
            AllowSingleInstructionSerialAccess .set error
        .elseif .xmatch(__param0__, +)
            AllowSingleInstructionSerialAccess .set allow
        .else
            deferror AllowSingleInstructionSerialAccess, __param0__
        .endif
    .elseif .xmatch(__rule__, PerformAutomaticShadowWrites)
        .ifndef __param0__
            PerformAutomaticShadowWrites .set allow
        .elseif .xmatch(__param0__, -)
            PerformAutomaticShadowWrites .set error
        .elseif .xmatch(__param0__, +)
            PerformAutomaticShadowWrites .set allow
        .else
            deferror PerformAutomaticShadowWrites, __param0__
        .endif
    .else
        .fatal .sprintf("InvalidIdentifierException: rule '%s' does not exist", .string(__rule__))
    .endif
.endmacro

.macro shadow __foo__, __bar__
    .define __shadowtemp LIBCORE_WRITEONLYSHADOWACCESS
    .undefine LIBCORE_WRITEONLYSHADOWACCESS

    .define LIBCORE_WRITEONLYSHADOWACCESS __shadowtemp, __foo__
    .undefine __shadowtemp

    __bar__ .set null                           ; create variable for shadow register
    malloc __bar__, 1, slow                     ; allocate slow RAM for it
    ; do not deallocate, defines restored

    ; normnalized access reference
    .ident(.sprintf("__S%s", .string(__foo__))) .set __bar__
.endmacro