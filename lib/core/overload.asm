; TODO: dev these
; TODO: chane 0 (do) 1 (overrule) 2 (DONOTEVALUTE) into enums
.macro sed
    jsr __toBCD
.endmacro
.macro cld __target__
    jsr __fromBCD
.endmacro
.macro lax ____operand____, __index__
    .if .xmatch(.left(1, ____operand____), #)
        .if .right(.tcount(____operand____)-1, ____operand____)
            lda ____operand____
            tax
        .else
            .feature ubiquitous_idents -
            lax #$00
            .feature ubiquitous_idents +
        .endif
        .exitmacro
    .endif

    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList lax .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lax .ident(.sprintf("__S%s", .string(__operand__))), index
        .else
            ___EvalInstrList lax __operand__, index
        .endif
    .endif
.endmacro
.macro brk ____operand____
    .byte $00
    .ifnblank ____operand____
        .byte ____operand____
    .else
        .ifdef  CONFIG_DEFAULT_BRK___operand__
            .if CONFIG_DEFAULT_BRK___operand__
                .byte $00
            .endif
        .else
            .byte $00
        .endif
    .endif
.endmacro
.macro beq __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        beq __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bne __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bne __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bpl __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bpl __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bmi __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bmi __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bcs __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bcs __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bcc __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bcc __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bvs __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bvs __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro bvc __relative__ 
    .if .match(__relative__, 0)
        .byte $f0, __relative__
    .elseif .def(__relative__) .and .const((*-2)-(__relative__)) .and ((*+2)-(__relative__) <= 127)
        .feature ubiquitous_idents -
        bvc __relative__
        .feature ubiquitous_idents +
    .else
        .byte $f0, __relative__
    .endif
.endmacro
.macro lda __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        .out .string(.right(.tcount(__operand__)-1, __operand__))
        ___EvalInstrList lda .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        .define __lda_op .right(.tcount(__operand__) -2, __operand__)
        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if .xmatch(.left(1, __operand__), [)
            overrule .set 2
        .elseif .xmatch(.right(1, __operand__), ])
            overrule .set 2
        .endif

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lda .ident(.sprintf("__S%s", .string(__lda_op))), index
        .else
            ___EvalInstrList lda __lda_op, index
        .endif
        .undefine __lda_op
        
    .elseif .xmatch(.left(1, {__operand__}), #)
        .feature ubiquitous_idents -
        lda __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if .xmatch(.left(1, __operand__), [)
            overrule .set 2
        .elseif .xmatch(.right(1, __operand__), ])
            overrule .set 2
        .endif

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lda .ident(.sprintf("__S%s", .string(__operand__))), index
        .else
            ___EvalInstrList lda __operand__, index
        .endif
    .endif
.endmacro
.macro sta __operand__, index
    .local operand
    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList sta .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .else
        operand = __operand__
    .endif

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    ___EvalInstrList sta operand, index
.endmacro
.macro ldx __operand__, index
    .local operand
    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList ldx .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        ldx __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList ldx .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList ldx operand, index
    .endif
.endmacro
.macro stx __operand__, index
    .local operand
    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList stx .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .else
        operand = __operand__
    .endif

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    ___EvalInstrList stx operand, index
.endmacro
.macro ldy __operand__, index
    .local operand
    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList ldy .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        ldy __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList ldy .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList ldy operand, index
    .endif
.endmacro
.macro sty __operand__, index
    .local operand
    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList sty .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .else
        operand = __operand__
    .endif

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    ___EvalInstrList sty operand, index
.endmacro
; there will be no "adc a" as the user may assume we can detect repeated use and missuse such a feature
.macro adc __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        adc TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        adc TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList adc .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        lda __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList lda .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList lda operand, index
    .endif
.endmacro
.macro and __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        and TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        and TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList and .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        and __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList and .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList and operand, index
    .endif
.endmacro
.macro asl __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList asl .right(.tcount(__operand__)-1, __operand__), index
    .elseif .xmatch(__operand__, a)
        .feature ubiquitous_idents -
        asl
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .blank(__operand__)
        .feature ubiquitous_idents -
        asl
        .feature ubiquitous_idents +
    .else
        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            ; use normalized access reference to fetch shadow
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList asl .right(.tcount(__operand__) -2, __operand__), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            asl __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList asl operand, index
        .endif
    .endif
.endmacro
.macro cmp __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        cmp TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        cmp TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList cmp .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        cmp __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList cmp .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList cmp operand, index
    .endif
.endmacro
.macro dec __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList dec .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY
        
        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList dec .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList dec __operand__, index
        .endif
    .endif
.endmacro
.macro eor __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        eor TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        eor TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList eor .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        eor __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList eor .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList eor operand, index
    .endif
.endmacro
.macro inc __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList inc .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY
        
        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList inc .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList inc __operand__, index
        .endif
    .endif
.endmacro
.macro lsr __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList lsr .right(.tcount(__operand__)-1, __operand__), index
    .elseif .xmatch(__operand__, a)
        .feature ubiquitous_idents -
        lsr
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .blank(__operand__)
        .feature ubiquitous_idents -
        lsr
        .feature ubiquitous_idents +
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            ; use normalized access reference to fetch shadow
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList lsr .right(.tcount(__operand__) -2, __operand__), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            lsr __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList lsr __operand__, index
        .endif
    .endif
.endmacro
.macro ora __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        ora TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        ora TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList ora .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        ora __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList ora .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList ora operand, index
    .endif
.endmacro
.macro rol __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList rol .right(.tcount(__operand__)-1, __operand__), index
    .elseif .xmatch(__operand__, a)
        .feature ubiquitous_idents -
        rol
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .blank(__operand__)
        .feature ubiquitous_idents -
        rol
        .feature ubiquitous_idents +
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            ; use normalized access reference to fetch shadow
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList rol .right(.tcount(__operand__) -2, __operand__), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            rol __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList rol __operand__, index
        .endif
    .endif
.endmacro
.macro ror __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList ror .right(.tcount(__operand__)-1, __operand__), index
    .elseif .xmatch(__operand__, a)
        .feature ubiquitous_idents -
        ror
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .blank(__operand__)
        .feature ubiquitous_idents -
        ror
        .feature ubiquitous_idents +
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            ; use normalized access reference to fetch shadow
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList ror .right(.tcount(__operand__) -2, __operand__), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            ror __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList ror __operand__, index
        .endif
    .endif
.endmacro
.macro sbc __operand__, index
    .local operand
    .if     .xmatch(__operand__, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        sbc TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(__operand__, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        sbc TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    

    overrule .set .xmatch(.left(1, __operand__), !)

    .if overrule
        ___EvalInstrList sbc .right(.tcount(__operand__)-1, __operand__), index
        .exitmacro
    .elseif .xmatch(.left(2, __operand__), ##)
        operand = .right(.tcount(__operand__) -2, __operand__)
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        sbc __operand__
        .feature ubiquitous_idents +
        .exitmacro
    .else
        operand = __operand__
    .endif

    resp .set 0
    
    contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

    .if .xmatch(.left(1, __operand__), [)
        overrule .set 2
    .elseif .xmatch(.right(1, __operand__), ])
        overrule .set 2
    .endif

    .if resp
        ; use normalized access reference to fetch shadow
        ___EvalInstrList sbc .ident(.sprintf("__S%s", .string(operand))), index
    .else
        ___EvalInstrList sbc operand, index
    .endif
.endmacro
.macro bit __operand__, index
    .feature ubiquitous_idents -
    .if     .xmatch(.left(1, __operand__), #)
        bit TABLE_ID + .right(.tcount(__operand__) - 1, __operand__)
    .else
            overrule .set .xmatch(.left(1, __operand__), !)
            .if overrule
                ___EvalInstrList bit .right(.tcount(__operand__)-1, __operand__), index
            .else

                resp .set 0
                
                contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

                .if resp
                    ; use normalized access reference to fetch shadow
                    ___EvalInstrList bit .ident(.sprintf("__S%s", .string(__operand__))), index
                .else
                    ___EvalInstrList bit __operand__, index
                .endif
            .endif
    .endif
    .feature ubiquitous_idents +
.endmacro
.macro cpx __operand__, index
    .if     .xmatch(__operand__, a)
        malloc foo, 1, fast
        sta foo
        cpx foo
        dealloc foo, 1, fast
        .exitmacro
    .elseif .xmatch(__operand__, y)
        malloc foo, 1, fast
        sty foo
        cpx foo
        dealloc foo, 1, fast
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList cpx .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList cpx .ident(.sprintf("__S%s", .string(__operand__))), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            cpx __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList cpx __operand__, index
        .endif
    .endif
.endmacro
.macro cpy __operand__, index
    .if     .xmatch(__operand__, a)
        malloc foo, 1, fast
        sta foo
        cpy foo
        dealloc foo, 1, fast
        .exitmacro
    .elseif .xmatch(__operand__, x)
        malloc foo, 1, fast
        stx foo
        cpy foo
        dealloc foo, 1, fast
        .exitmacro
    .endif

    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList cpy .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList cpy .ident(.sprintf("__S%s", .string(__operand__))), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            cpy __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList cpy __operand__, index
        .endif
    .endif
.endmacro
.macro jmp __operand__, index
    .local ptr

    .if .xmatch(.left(1, __operand__), [)
        .feature ubiquitous_idents -
        .ifblank index
            jmp __operand__
        .elseif .xmatch(.right(1, __operand__), ])
            pha
            lda __operand__, x
            sta ptr
            lda __operand__ + 1, x
            sta ptr
            pla

            jmp [ptr]
        .elseif .xmatch(.right(1, __operand__), y)
            pha
            lda __operand__, y
            sta ptr
            lda __operand__ + 1, y
            sta ptr
            pla

            jmp [ptr]
        .endif
        .feature ubiquitous_idents +
    .else
        overrule .set .xmatch(.left(1, __operand__), !)
        .if overrule
            ___EvalInstrList jmp .right(.tcount(__operand__)-1, __operand__), index
            .exitmacro
        .endif

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList jmp .ident(.sprintf("__S%s", .string(__operand__))), index
        .else
            ___EvalInstrList jmp __operand__, index
        .endif
    .endif
.endmacro
.macro jsr __operand__, index
    .local ptr, temp, exit

    ptr  .set null
    temp .set null



    .if .xmatch(.left(1, __operand__), [)
        .ifblank index
            malloc temp, 1
            
            sta temp
            callback exit
            lda temp
            
            jmp __operand__
            exit:

            dealloc temp, 1
        .elseif .xmatch(.right(1, __operand__), ])
            
            malloc ptr,  2
            malloc temp, 1

            sta temp
            callback exit
            lda __operand__, x
            sta ptr
            lda __operand__ + 1, x
            sta ptr
            lda temp

            jmp [ptr]
            exit:

            dealloc temp, 1
            dealloc ptr,  2
        .elseif

            malloc ptr,  2
            malloc temp, 1

            sta temp
            callback exit
            lda __operand__, y
            sta ptr
            lda __operand__ + 1, y
            sta ptr
            lda temp

            jmp [ptr]
            exit:

            dealloc temp, 1
            dealloc ptr,  2
        .endif
    .else
        overrule .set .xmatch(.left(1, __operand__), !)
        .if overrule
            ___EvalInstrList jsr .right(.tcount(__operand__)-1, __operand__), index
        .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList jsr .ident(.sprintf("__S%s", .string(__operand__))), index
        .else
            ___EvalInstrList jsr __operand__, index
        .endif
    .endif
.endmacro
.macro nop __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList nop .right(.tcount(__operand__)-1, __operand__), index
    .elseif .xmatch(.left(1, __operand__), #)
        .feature ubiquitous_idents -
        nop __operand__
        .feature ubiquitous_idents +
    .else
        ___EvalInstrList nop __operand__, index
    .endif
.endmacro
.macro slo __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList slo .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList slo .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList slo __operand__, index
        .endif
    .endif
.endmacro
.macro rla __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList rla .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList rla .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList rla __operand__, index
        .endif
    .endif
.endmacro
.macro sre __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList sre .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_SHADOWACESS

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList sre .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList sre __operand__, index
        .endif
    .endif
.endmacro
.macro rra __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList rra .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_SHADOWACESS

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList rra .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList rra __operand__, index
        .endif
    .endif
.endmacro
.macro sax __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList sax .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLYSHADOWACCESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList sax .ident(.sprintf("__S%s", .string(__operand__))), index
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList sax .right(.tcount(__operand__) -2, __operand__), index
        .elseif .xmatch(.left(1, __operand__), #)
            .feature ubiquitous_idents -
            sax __operand__
            .feature ubiquitous_idents +
        .else
            ___EvalInstrList sax __operand__, index
        .endif
    .endif
.endmacro
.macro dcp __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList dcp .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList dcp .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList dcp __operand__, index
        .endif
    .endif
.endmacro
.macro isc __operand__, index
    overrule .set .xmatch(.left(1, __operand__), !)
    .if overrule
        ___EvalInstrList isc .right(.tcount(__operand__)-1, __operand__), index
    .else

        resp .set 0
        
        contains resp, __operand__, LIBCORE_WRITEONLY
        contains resp, __operand__, LIBCORE_READONLY

        .if resp
            .fatal "string"
        .elseif .xmatch(.left(2, __operand__), ##)
            ___EvalInstrList isc .right(.tcount(__operand__) -2, __operand__), index
        .else
            ___EvalInstrList isc __operand__, index
        .endif
    .endif
.endmacro