; untested
.macro ldz __gpr__
    /*
        (gpr)__gpr__
    */

    gpr .set ar
    .ifnblank __gpr__
        gpr .set setreg __gpr__
    .endif

    ldr imm: gpr, $00
.endmacro