.ifndef INCLUDES_SYNTH_OVERLOAD

INCLUDES_SYNTH_OVERLOAD := null ; to check if included
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

.endif