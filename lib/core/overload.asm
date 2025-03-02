.macro __lax __operand__, __index__
    .if .match(.left(1, __operand__), #)
        .out "Alpha"
        .ifnblank __index__
            .byte $ab, __operand__
        .elseif .right(.tcount(__operand__) - 1, __operand__) = $00
            .byte $ab, $00
        .else
            lda __operand__
            tax
        .endif
        .exitmacro
    .endif

    .feature ubiquitous_idents -
    .ifblank __index__
        lax __operand__
    .elseif  .xmatch(__index__, y)
        lax __operand__, y
    .else
        .fatal
    .endif

    .feature ubiquitous_idents +
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
        ___EvalInstrList lda operand, index
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
        ___EvalInstrList ldx operand, index
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
        ___EvalInstrList ldy operand, index
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
        ___EvalInstrList adc operand, index
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
        ___EvalInstrList and operand, index
    .endif
.endmacro
.macro asl operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList asl .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList asl operand, index
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
        ___EvalInstrList cmp operand, index
    .endif
.endmacro
.macro dec operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList dec .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList dec operand, index
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
        ___EvalInstrList eor operand, index
    .endif
.endmacro
.macro inc operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList inc .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList inc operand, index
    .endif
.endmacro
.macro lsr operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lsr .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList lsr operand, index
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
        ___EvalInstrList ora operand, index
    .endif
.endmacro
.macro rol operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rol .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList rol operand, index
    .endif
.endmacro
.macro ror operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList ror .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList ror operand, index
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
        ___EvalInstrList sbc operand, index
    .endif
.endmacro
.macro bit operand, index
    .feature ubiquitous_idents -
    .if     .xmatch(.left(1, operand), #)
        bit TABLE_ID + .right(.tcount(operand) - 1, operand)
    .else
        ___EvalInstrList and operand, index
    .endif
    .feature ubiquitous_idents +
.endmacro
.macro cpx operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList cpx .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList cpx operand, index
    .endif
.endmacro
.macro cpy operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList cpy .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList cpy operand, index
    .endif
.endmacro

; TODO: Make jmp foo[y|x] work
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
        ___EvalInstrList slo operand, index
    .endif
.endmacro
.macro rla operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rla .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList rla operand, index
    .endif
.endmacro
.macro sre operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList sre .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList sre operand, index
    .endif
.endmacro
.macro rra operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList rra .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList rra operand, index
    .endif
.endmacro
.macro sax operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList sax .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList sax operand, index
    .endif
.endmacro
.macro lax operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList lax .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList lax operand, index
    .endif
.endmacro
.macro dcp operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList dcp .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList dcp operand, index
    .endif
.endmacro
.macro isc operand, index
    overrule .set .xmatch(.left(1, operand), !)
    .if overrule
        ___EvalInstrList isc .right(.tcount(operand)-1, operand), index
    .else
        ___EvalInstrList isc operand, index
    .endif
.endmacro