.macro __lax __operand__, __index__
    .if .xmatch(.left(1, __operand__), #) && .right(.tcount(__operand__)-1, __operand__)
            lda __operand__
            tax
            .exitmacro
    .endif

    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lax .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lax .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList lax operand, index
        .endif
    .endif

.endmacro

.feature ubiquitous_idents +

; TODO: dev these
.macro sed __target__
    .ifblank __target__
        jsr __toBCD
        .exitmacro
    .endif
.endmacro

.macro cld __target__
    .ifblank __target__
        jsr __fromBCD
        .exitmacro
    .endif
.endmacro

.macro lax operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lax .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lax .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList lax operand, index
        .endif
    .endif
.endmacro

; break with aligned return support
.macro brk __operand__, __ptr__, __data__
    .local loptr_reg, hiptr_reg, d_reg

    loptr_reg .set null
    hiptr_reg .set null
    d_reg     .set null

    .ifnblank __ptr__
        loptr_reg .set .left( 1, __ptr__)
        hiptr_reg .set .right(1, __ptr__)

        .if (loptr_reg <> null) && (hiptr_reg <> null)
            loptr_reg .set setreg loptr_reg
            hiptr_reg .set setreg hiptr_reg

            .if     is_null loptr_reg
                .fatal ""
            .elseif is_null hiptr_reg
                .fatal ""
            .endif

            .if     loptr_reg = xr
                ldx #.lobyte(* + 2 + (2 * .blank(__data__)))
            .elseif loptr_reg = yr
                ldy #.lobyte(* + 2 + (2 * .blank(__data__)))
            .else
                lda #.lobyte(* + 2 + (2 * .blank(__data__)))
            .endif

            .if     hiptr_reg = xr
                ldx #.hibyte(* + 2 + (2 * .blank(__data__)))
            .elseif hiptr_reg = yr
                ldy #.hibyte(* + 2 + (2 * .blank(__data__)))
            .else
                lda #.hibyte(* + 2 + (2 * .blank(__data__)))
            .endif
        .endif

        .ifnblank __data__
            ralloc d_reg, loptr_reg, hiptr_reg
            ldr imm: d_reg, __data__
        .endif

        .byte $00
        .ifnblank __operand__
            .byte __operand__
        .else
            .ifdef  CONFIG_DEFAULT_BRK_OPERAND
                .if CONFIG_DEFAULT_BRK_OPERAND
                    .byte $00
                .endif
            .else
                .byte $00
            .endif
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
.macro lda operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lda .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lda .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList lda operand, index
        .endif
    .endif
.endmacro
.macro sta operand, index
    .local ptr
    .ifblank index
        .if .xmatch(.left(1, operand), [) && .xmatch(.right(1, operand), ])
            
            .feature ubiquitous_idents -

            malloc ptr, 2

            ldy #<.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr
            ldy #>.left(.tcount(operand) - 2, .right(.tcount(operand) - 1, operand))
            sty ptr + 1

            ldy #$00
            sta [ptr], y
            .feature ubiquitous_idents +
            

            dealloc ptr, 2
            .exitmacro
        .endif
    .endif
    ___EvalInstrList sta operand, index
.endmacro
.macro ldx operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList ldx .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList ldx .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList ldx operand, index
        .endif
    .endif
.endmacro
.macro stx operand, index
    ___EvalInstrList stx operand, index
.endmacro
.macro ldy operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList ldy .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList ldy .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList ldy operand, index
        .endif
    .endif
.endmacro
.macro sty operand, index
    ___EvalInstrList sty operand, index
.endmacro
.macro adc operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        adc TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        adc TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList adc .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList adc .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList adc operand, index
        .endif
    .endif
.endmacro
.macro and operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        and TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        and TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList and .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList and .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList and operand, index
        .endif
    .endif
.endmacro
; add implied mode a register operand
.macro asl operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList asl .right(.tcount(operand)-1, operand), index
    .elseif .xmatch(operand, a)
        .feature ubiquitous_idents -
        asl
        .feature ubiquitous_idents +
        .exitmacro
    .else
        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList asl .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList asl operand, index
        .endif
    .endif
.endmacro
.macro cmp operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        cmp TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        cmp TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList cmp .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList cmp .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList cmp operand, index
        .endif
    .endif
.endmacro
.macro dec operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList dec .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList dec .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList dec operand, index
        .endif
    .endif
.endmacro
.macro eor operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        eor TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        eor TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList eor .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList eor .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList eor operand, index
        .endif
    .endif
.endmacro
.macro inc operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList inc .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList inc .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList inc operand, index
        .endif
    .endif
.endmacro
.macro lsr operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lsr .right(.tcount(operand)-1, operand), index
    .elseif .xmatch(operand, a)
        .feature ubiquitous_idents -
        lsr
        .feature ubiquitous_idents +
        .exitmacro
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList lsr .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList lsr operand, index
        .endif
    .endif
.endmacro
.macro ora operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        ora TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        ora TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList ora .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList ora .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList ora operand, index
        .endif
    .endif
.endmacro
.macro rol operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rol .right(.tcount(operand)-1, operand), index
    .elseif .xmatch(operand, a)
        .feature ubiquitous_idents -
        rol
        .feature ubiquitous_idents +
        .exitmacro
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList rol .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList rol operand, index
        .endif
    .endif
.endmacro
.macro ror operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList ror .right(.tcount(operand)-1, operand), index
    .elseif .xmatch(operand, a)
        .feature ubiquitous_idents -
        asl
        .feature ubiquitous_idents +
        .exitmacro
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList ror .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList ror operand, index
        .endif
    .endif
.endmacro
.macro sbc operand, index
    .if     .xmatch(operand, x) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        sbc TABLE_ID, x
        
        .feature ubiquitous_idents +
        .exitmacro
    .elseif .xmatch(operand, y) && .defined(TABLE_ID)
        .feature ubiquitous_idents -
        
        sbc TABLE_ID, y
        
        .feature ubiquitous_idents +
        .exitmacro
    .endif
    
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList sbc .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList sbc .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList sbc operand, index
        .endif
    .endif
.endmacro
.macro bit operand, index
    .feature ubiquitous_idents -
    .if     .xmatch(.left(1, operand), #)
        bit TABLE_ID + .right(.tcount(operand) - 1, operand)
    .else
            overrule .set .xmatch(.left(1, operand), !)
            .if overrule
                ___EvalInstrList bit .right(.tcount(operand)-1, operand), index
            .else

                resp .set 0
                
                contains resp, operand, LIBCORE_SHADOWACESS

                .if resp
                    ; use normalized access reference to fetch shadow
                    ___EvalInstrList bit .ident(.sprintf("__S%s", .string(operand))), index
                .else
                    ___EvalInstrList bit operand, index
                .endif
            .endif
    .endif
    .feature ubiquitous_idents +
.endmacro
.macro cpx operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList cpx .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList cpx .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList cpx operand, index
        .endif
    .endif
.endmacro
.macro cpy operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList cpy .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList cpy .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList cpy operand, index
        .endif
    .endif
.endmacro
.macro jmp operand, index
    .local ptr

    .if .xmatch(.left(1, operand), [)
        .ifblank index
            jmp operand
        .elseif .xmatch(.right(1, operand), ])
            pha
            lda operand, x
            sta ptr
            lda operand + 1, x
            sta ptr
            pla

            jmp [ptr]
        .elseif
            pha
            lda operand, y
            sta ptr
            lda operand + 1, y
            sta ptr
            pla

            jmp [ptr]
        .endif
    .else
        overrule .set .xmatch(.left(1, operand), !)
        .if overrule
            ___EvalInstrList jmp .right(.tcount(operand)-1, operand), index
        .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList jmp .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList jmp operand, index
        .endif
    .endif
.endmacro
.macro jsr operand, index
    .local ptr, temp, exit

    ptr  .set null
    temp .set null



    .if .xmatch(.left(1, operand), [)
        .ifblank index
            malloc temp, 1
            
            sta temp
            callback exit
            lda temp
            
            jmp operand
            exit:

            dealloc temp, 1
        .elseif .xmatch(.right(1, operand), ])
            
            malloc ptr,  2
            malloc temp, 1

            sta temp
            callback exit
            lda operand, x
            sta ptr
            lda operand + 1, x
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
            lda operand, y
            sta ptr
            lda operand + 1, y
            sta ptr
            lda temp

            jmp [ptr]
            exit:

            dealloc temp, 1
            dealloc ptr,  2
        .endif
    .else
        overrule .set .xmatch(.left(1, operand), !)
        .if overrule
            ___EvalInstrList jsr .right(.tcount(operand)-1, operand), index
        .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList jsr .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList jsr operand, index
        .endif
    .endif
.endmacro
.macro nop operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList nop .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList nop operand, index
    .endif
.endmacro
.macro slo operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList slo .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList slo .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList slo operand, index
        .endif
    .endif
.endmacro
.macro rla operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rla .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList rla .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList rla operand, index
        .endif
    .endif
.endmacro
.macro sre operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList sre .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList sre .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList sre operand, index
        .endif
    .endif
.endmacro
.macro rra operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rra .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList rra .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList rra operand, index
        .endif
    .endif
.endmacro
.macro sax operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList sax .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList sax .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList sax operand, index
        .endif
    .endif
.endmacro
.macro dcp operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList dcp .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList dcp .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList dcp operand, index
        .endif
    .endif
.endmacro
.macro isc operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList isc .right(.tcount(operand)-1, operand), index
    .else

        resp .set 0
        
        contains resp, operand, LIBCORE_SHADOWACESS

        .if resp
            ; use normalized access reference to fetch shadow
            ___EvalInstrList isc .ident(.sprintf("__S%s", .string(operand))), index
        .else
            ___EvalInstrList isc operand, index
        .endif
    .endif
.endmacro