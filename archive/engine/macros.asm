.macro libdata path                         ; must be done before includes, should be done first
    .incbin path 
.endmacro


.macro libconfig path noconst
    .ifndef noconst
        .include path + "/constants.asm"    ; if exists, must do before includes
    .endif
    .include path + "/addresses.asm"        ; must exist prior to includes
    .include path + "/config.asm"           ; must exist prior to includes
    .include path + "/includes.asm"         ; always comes last
.endmacro

.macro bitabs
    .byte $2c
.endmacro

.macro bitzp
    .byte $24
.endmacro