; TODO: Add ca65hl support

.macro lax __operand__, __index__
    .local pass

    .if .xmatch(.left(1, __rightside__) = #)
        .ifnblank __index__
            .byte $ab, __operand__
        .elseif __operand__ = $00
            .byte $ab, $00
        .endif
        lda __rightside__
        tax
        .exitmacro
    .endif

    .repeat .tcount(__rightside__), iter
        .if .xmatch(.left(1, .right(iter, __rightside__)), ,)
            index   =  iter
        .endif
    .endrepeat

    .ifnblank __index__
        .if .xmatch(.left(1, __operand__), [)
            operand = .left(index - 1, .right(index, __operand__))
            .byte $b3, __operand__
        .elseif .xmatch(__index__, y)
            operand = .right(index, __operand__)
            .if __operand__ > $ff
                .byte $bf, __operand__
            .else
                .byte $b7, __operand__
            .endif
            ; absy, zpy
        .elseif .xmatch(__index__, x)
            operand = .right(index, __operand__)
            ; absx | zpx
            .fatal  ; not valid
        .endif
    .else
        .if .xmatch(.left(1, __operand__), [)
            operand = .left(index - 1, .right(index, __operand__))
            .byte $a3, __operand__
        .else
            .if __operand__ > $ff
                .byte $af, __operand__
            .else
                .byte $a7, __operand__
            .endif
        .endif
    .endif
.endmacro

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
        loptr_reg .set xr
        hiptr_reg .set yr
        
        .if !is_null __ptr__
            loptr_reg .set .left( 1, __ptr__)
            loptr_reg .set .right(1, __ptr__)
            
            loptr_reg .set setreg loptr_reg
            hiptr_reg .set setreg hiptr_reg

            .if     is_null loptr_reg
                .fatal
            .elseif is_null hiptr_reg
                .fatal
            .endif
        .endif

        ldr loptr_reg: imm, .lobyte(* + 4 + (2 * .blank(__data__)))
        ldr hiptr_reg: imm, .hibyte(* + 2 + (2 * .blank(__data__)))
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
.endmacro