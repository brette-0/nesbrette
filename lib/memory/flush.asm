; TODO: MIGRATE FUNCITONALITY TO ldr imm: __gpr__, $00

.macro ldz __gpr__, __lax$__, __lax_level$__
    /*

        (gpr)__gpr__
        (opt: def)__lax$__
            ??= CONSTANTS_MEMORY_FLUSH_LAX ?? 1
        (opt: nb_error)__lax_level$__
            ??= UnstableInstructionException ?? error
    */

    ; check for wish to use lax (unreccomended)
    .ifnblank __lax$__
        perform_lax .set __lax$__
    .else
        .ifdef CONSTANTS_MEMORY_FLUSH_LAX
            perform_lax = CONSTANTS_MEMORY_FLUSH_LAX
        .else
            perform_lax .set 0
        .endif
    .endif

    ; modify rules (unreccomended)
    .ifblank __lax_level$__
        .ifdef UnstableInstructionException
            deferror UnstableInstructionException, lax_errorlevel
        .else
            deferror warning, lax_errorlevel
        .endif
    .else
        deferror (__lax$__), lax_errorlevel
    .endif

    gpr .set ar

    .ifnblank __gpr__
        gpr .set setmreg __gpr__
    .endif

    .if     gpr = ar
        lda #$00
    .elseif gpr = xr
        ldx #$00
    .elseif gpr = yr
        ldy #$00
    .elseif gpr = (ar + xr)
        .ifdef IDENTITY_TABLE
            laxi, $00
        .else
            .if perform_lax
                report lax_errorlevel, "Loading AX with immediate zero will not yield correct results on accurate devices." 
                lax #$00
            .else
                lda #$00
                tax
            .endif
        .endif
    .elseif gpr = (ar + yr)
        lda #$00
        tay
    .elseif gpr = (yr + xr)
        ldy #$00
        ldx #$00
    .elseif gpr = (ar + yr + xr)
        .if perform_lax
            lax #$00
        .else
            lda #$00
            tax
        .endif
        tay
    .else
        .fatal"Load Zero was passed an invalid parameter."
    .endif
.endmacro